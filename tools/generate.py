"""Writes new RpBuffBeg lines with a local LLM (Ollama) into Generated.lua.

The hand-written lines in Voices*.lua are the examples and the fallback: every pool (personality x
asks/refreshes/thanks) gets fresh lines in the same voice, accent and placeholders. In game, /buffbeg lines mix|only|off picks how they're used.

Personalities of your own (tools/new_persona.py, kept in tools/personas.json) are generated the same
way from their description and seed lines, and go into Generated.lua with them.

Needs Ollama running (https://ollama.com) with the model pulled:  ollama pull llama3.1:8b

    python tools/generate.py                          # every pool, plain voice (no accent)
    python tools/generate.py --persona bold,timid     # just those personalities
    python tools/generate.py --kind thanks --count 30 # just thank-yous, 30 per pool
    python tools/generate.py --accent dwarf           # dwarf-accent pools (orc, troll, dwarf, all)
    python tools/generate.py --append                 # add to the pools instead of replacing them
    python tools/generate.py --list                   # how many generated lines each pool has

Progress is kept in tools/generated.json (rewritten after every pool, so Ctrl+C loses nothing) and
Generated.lua is rebuilt from it. Both are personal: git-ignored, never packaged.
"""
import argparse
import difflib
import json
import random
import re
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CACHE = ROOT / "tools" / "generated.json"
PERSONAS_FILE = ROOT / "tools" / "personas.json"
OUTPUT = ROOT / "Generated.lua"
SOURCES = {"plain": "Voices.lua", "orc": "VoicesOrc.lua", "troll": "VoicesTroll.lua", "dwarf": "VoicesDwarf.lua"}
KINDS = ["asks", "refreshes", "thanks"]

# Longest line before {name}/{buff} are filled in. The hand-written ones stay under ~110; a full name
# and "Greater Blessing of Wisdom" add about 40 more, and /say cuts off at 255.
MAX_LEN = 130

KIND_TASK = {
    "asks": "You walk up to another player, {name}, and ask them out loud to cast the buff {buff} on you. Every "
            "line must clearly ask for it (give {me} {buff}, cast {buff} on {me}, {buff}, please...).",
    "refreshes": "{name} already gave you {buff} earlier and it is about to wear off. Every line must clearly ask "
                 "them to cast it again.",
    "thanks": "{name} just cast a buff on you. Thank them. Do not name the buff: there is no {buff} placeholder here.",
}

ACCENT_STYLE = {
    "plain": "Plain English, no accent.",
    "orc": "An orc: short blunt sentences, dropped articles and verbs ('I go now', 'You are strong'), "
           "the odd Orcish word (Lok'tar, Throm-ka, zug zug, Mak'gora). Write the words normally, not phonetically.",
    "troll": "A Darkspear troll: Caribbean-style dialect ('dere', 'dem', 'mon', 'me gonna', 'ya'), relaxed and "
             "sly, the odd voodoo or loa reference.",
    "dwarf": "A dwarf: Scottish-style dialect ('aye', 'ye', 'tae', 'wee', 'cannae', 'ken'), ale, stone and beards. "
             "You may use {lad}, which becomes 'lad' or 'lass' for the target.",
}


def parse_voices(path):
    """Voices*.lua -> {persona: {kind: [lines]}}."""
    out = {}
    persona = pool = None
    for raw in path.read_text(encoding="utf-8").splitlines():
        m = re.match(r"^(\w+) = \{", raw)
        if m:
            persona = out.setdefault(m.group(1), {})
            continue
        m = re.match(r"^    (\w+) = \{", raw)
        if m and persona is not None:
            pool = persona.setdefault(m.group(1), [])
            continue
        m = re.match(r'^\s+"(.*)",?\s*$', raw)
        if m and pool is not None:
            pool.append(m.group(1).replace('\\"', '"').replace("\\\\", "\\"))
    return out


def parse_personas():
    """Data.lua's personalities: key -> (label, desc). "mixed" left out."""
    text = (ROOT / "Data.lua").read_text(encoding="utf-8")
    found = re.findall(r'\{ key = "(\w+)", label = "([^"]+)", desc = "([^"]+)" \}', text)
    return {key: (label, desc) for key, label, desc in found if key != "mixed"}


def load_custom():
    """Personalities of your own: key -> {"label", "desc", "seeds": {kind: [lines]}}."""
    return json.loads(PERSONAS_FILE.read_text(encoding="utf-8")) if PERSONAS_FILE.exists() else {}


def load_cache():
    """tools/generated.json: accent -> persona -> kind -> [lines]."""
    cache = json.loads(CACHE.read_text(encoding="utf-8")) if CACHE.exists() else {}
    # Before class asks were retired: accent -> "voices"/"class_asks" -> persona -> pool.
    return {a: s["voices"] if "voices" in s or "class_asks" in s else s for a, s in cache.items() if s}


def prompt_for(accent, label, desc, kind, examples, borrowed, count):
    placeholders = ["{name} = the target's name (use it in every line)"]
    if kind != "thanks":
        placeholders.append("{buff} = the buff's name, e.g. Arcane Intellect (use it in every line)")
    placeholders.append("{me} = 'me' or 'us', only after a verb or preposition (give {me}, on {me}, for {me}), "
                        "never as the subject; {my} = 'my' or 'our'. Never start a line with {me} or {my}")
    if accent == "dwarf":
        placeholders.append("{lad} = 'lad' or 'lass' (optional)")
    task = KIND_TASK[kind]
    system = (
        "You write short in-character /say chat lines for a roleplayer in classic World of Warcraft (vanilla, "
        "level 1-60, Alliance and Horde, no later expansions). One player asks another for a buff spell.\n"
        f"Personality: {label}. {desc}\n"
        f"Voice: {ACCENT_STYLE[accent]}\n"
        "Rules: each line is one or two short spoken sentences, under 110 characters, said out loud to the other "
        "player. No *actions*, no emojis, no hashtags, no quotation marks around the line, no modern slang or "
        "real-world references, and nothing about the game's interface (icons, buttons, bars, addons). "
        "{buff} is a spell's name: never write 'a {buff}', 'an {buff}', 'some {buff}' or 'your {buff}'. "
        "Be witty and specific like the examples, not generic. Every line different from the others.\n"
        "Placeholders, written exactly like this with curly braces:\n- " + "\n- ".join(placeholders)
    )
    user = f"Situation: {task}\n\n"
    if examples:
        user += "Examples in this voice:\n" + "\n".join(f"- {e}" for e in examples) + "\n\n"
    if borrowed:
        copy = "format and accent" if accent != "plain" else "format"
        user += (f"Examples from OTHER personalities (copy only their {copy}, not their personality):\n"
                 + "\n".join(f"- {e}" for e in borrowed) + "\n\n")
    user += (f"Write {count} NEW lines in the {label} voice described above. Don't reuse the examples' jokes. "
             'Reply as JSON: {"lines": ["...", "..."]}')
    return system, user


def ollama(host, model, system, user, temperature):
    body = {
        "model": model,
        "stream": False,
        "messages": [{"role": "system", "content": system}, {"role": "user", "content": user}],
        "format": {"type": "object", "properties": {"lines": {"type": "array", "items": {"type": "string"}}},
                   "required": ["lines"]},
        "options": {"temperature": temperature, "num_ctx": 4096},
    }
    req = urllib.request.Request(f"{host}/api/chat", json.dumps(body).encode(), {"Content-Type": "application/json"})
    with urllib.request.urlopen(req, timeout=600) as resp:
        content = json.loads(resp.read().decode("utf-8"))["message"]["content"]
    lines = json.loads(content).get("lines", [])
    return [l for l in lines if isinstance(l, str)]


TYPOGRAPHY = {"‘": "'", "’": "'", "“": '"', "”": '"', "…": "...", "–": "-", "—": ", "}


def clean(line, kind, accent):
    """The line ready for Lua, or (None, reason) when it breaks a rule."""
    for a, b in TYPOGRAPHY.items():
        line = line.replace(a, b)
    line = re.sub(r"^\s*(?:[-*\d.)]+\s+)?", "", line).strip().strip('"').strip()
    if not line.isascii():
        return None, "non-ascii"
    if "|" in line or "*" in line or "\n" in line or "#" in line:
        return None, "bad char"
    if len(line) > MAX_LEN:
        return None, "too long"
    allowed = {"name", "buff", "me", "my"} | ({"lad"} if accent == "dwarf" else set())
    used = set(re.findall(r"\{(\w+)\}", line))
    if used - allowed or re.search(r"[{}]|\[\w+\]|<\w+>", re.sub(r"\{\w+\}", "", line)):
        return None, "bad placeholder"
    if "name" not in used:
        return None, "no {name}"
    if kind == "thanks" and "buff" in used:
        return None, "{buff} in thanks"
    if kind != "thanks" and "buff" not in used:
        return None, "no {buff}"
    if re.search(r"\b(a|an|some|your)\s+\{buff\}", line, re.I):
        return None, "article before {buff}"
    if re.search(r"\{me\}\s+(am|is|are|was|need|needs|want|wants|could|would|will|can|have|has)\b", line, re.I):
        return None, "{me} as subject"
    if re.match(r"\{m[ey]\}", line):
        return None, "starts with {me}/{my}"
    return line, None


def norm(line):
    return re.sub(r"[^a-z{} ]", "", line.lower())


def too_similar(line, others):
    n = norm(line)
    for o in others:
        sm = difflib.SequenceMatcher(None, n, o)
        if sm.real_quick_ratio() > 0.8 and sm.quick_ratio() > 0.8 and sm.ratio() > 0.8:
            return True
    return False


def generate_pool(args, accent, label, desc, kind, hand, borrow, have):
    """Up to args.count new lines for one pool, checked against the hand-written ones and those already
    kept. borrow: other personalities' lines, shown for format (and accent) to a personality of your
    own, which has few lines to go on."""
    seen = [norm(l) for l in hand + have]
    kept, rejected = [], {}
    for _ in range(3):
        want = args.count - len(kept)
        if want <= 0:
            break
        examples = random.sample(hand, min(args.examples, len(hand)))
        borrowed = random.sample(borrow, min(len(borrow), max(6 - len(examples), 4 if accent != "plain" else 0)))
        system, user = prompt_for(accent, label, desc, kind, examples, borrowed, want + 5)
        try:
            raw = ollama(args.host, args.model, system, user, args.temperature)
        except (json.JSONDecodeError, KeyError) as e:
            rejected["bad reply"] = rejected.get("bad reply", 0) + 1
            print(f"      bad reply ({e}), retrying")
            continue
        for reply in raw:
            line, why = clean(reply, kind, accent)
            if not why and too_similar(line, seen):
                why = "too similar"
            if why:
                rejected[why] = rejected.get(why, 0) + 1
                if args.verbose:
                    print(f"      x {why}: {reply}")
                continue
            kept.append(line)
            seen.append(norm(line))
    return kept[:args.count], rejected


def lua_string(s):
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'


def write_lua():
    """Generated.lua from tools/generated.json and tools/personas.json."""
    cache, custom = load_cache(), load_custom()
    # Your personalities' seed lines speak too, in the plain set ahead of the generated ones.
    for key, p in custom.items():
        for kind, seeds in p.get("seeds", {}).items():
            pools = cache.setdefault("plain", {}).setdefault(key, {})
            pools[kind] = seeds + [l for l in pools.get(kind, []) if l not in seeds]
    out = [
        "-- RpBuffBeg: lines written by a local LLM (tools/generate.py), same shape as Voices*.lua, one set",
        "-- per accent (\"plain\" = no accent), and personalities of your own (tools/new_persona.py). Rebuilt",
        "-- from tools/generated.json and tools/personas.json: don't edit by hand. Personal: git-ignored, never",
        "-- packaged. /buffbeg lines picks how they're used.",
        "local _, ns = ...",
        "",
        "ns.CUSTOM_PERSONAS = {",
    ]
    out.extend(f"    {{ key = {lua_string(k)}, label = {lua_string(p['label'])}, desc = {lua_string(p['desc'])} }},"
               for k, p in custom.items())
    out += ["}", "", "ns.GENERATED = {"]
    for accent in sorted(cache):
        out.append(f"{accent} = {{")
        for persona in sorted(cache[accent]):
            out.append(f"    {persona} = {{")
            for kind, lines in sorted(cache[accent][persona].items()):
                if not lines:
                    continue
                out.append(f"        {kind} = {{")
                out.extend(f"            {lua_string(l)}," for l in lines)
                out.append("        },")
            out.append("    },")
        out.append("},")
    out.append("}")
    OUTPUT.write_text("\n".join(out) + "\n", encoding="utf-8", newline="\n")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--model", default="llama3.1:8b")
    ap.add_argument("--host", default="http://localhost:11434")
    ap.add_argument("--accent", default="plain", help="plain, orc, troll, dwarf or all (comma-separated)")
    ap.add_argument("--persona", default="all", help="personality keys, comma-separated, or all")
    ap.add_argument("--kind", default="all", help="asks, refreshes, thanks (comma-separated), or all")
    ap.add_argument("--count", type=int, default=20, help="lines per pool")
    ap.add_argument("--examples", type=int, default=8, help="hand-written lines shown to the model")
    ap.add_argument("--temperature", type=float, default=0.9)
    ap.add_argument("--append", action="store_true", help="add to the pools instead of replacing them")
    ap.add_argument("--list", action="store_true", help="show generated line counts and exit")
    ap.add_argument("--verbose", action="store_true", help="print every rejected line and why")
    args = ap.parse_args()

    cache = load_cache()
    if args.list:
        for accent, personas in sorted(cache.items()):
            for persona, pools in sorted(personas.items()):
                counts = ", ".join(f"{k} {len(v)}" for k, v in sorted(pools.items()))
                print(f"{accent:6} {persona:10} {counts}")
        return

    personas = parse_personas()
    custom = load_custom()
    personas.update({k: (p["label"], p["desc"]) for k, p in custom.items()})
    accents = list(SOURCES) if args.accent == "all" else args.accent.split(",")
    wanted = list(personas) if args.persona == "all" else args.persona.split(",")
    kinds = KINDS if args.kind == "all" else args.kind.split(",")
    for name, valid in (("accent", SOURCES), ("persona", personas), ("kind", KINDS)):
        bad = [v for v in {"accent": accents, "persona": wanted, "kind": kinds}[name] if v not in valid]
        if bad:
            sys.exit(f"Unknown {name}: {', '.join(bad)}. Choose from: {', '.join(valid)}")

    try:
        urllib.request.urlopen(f"{args.host}/api/tags", timeout=5)
    except (urllib.error.URLError, OSError):
        sys.exit(f"Can't reach Ollama at {args.host}. Start it (Ollama app, or `ollama serve`) and try again.")

    jobs = []
    for accent in accents:
        hand = parse_voices(ROOT / SOURCES[accent])
        for persona in wanted:
            mine = persona in custom
            own = custom[persona]["seeds"] if mine else hand[persona]
            for kind in kinds:
                # A personality of your own also sees every hand-written one's lines, for the format.
                borrow = [l for pools in hand.values() for l in pools[kind]] if mine else []
                jobs.append((accent, persona, kind, own.get(kind, []), borrow))

    print(f"{len(jobs)} pools with {args.model}")
    started = time.time()
    for n, (accent, persona, kind, hand, borrow) in enumerate(jobs, 1):
        target = cache.setdefault(accent, {}).setdefault(persona, {})
        have = target.get(kind, []) if args.append else []
        label, desc = personas[persona]
        t = time.time()
        new, rejected = generate_pool(args, accent, label, desc, kind, hand, borrow, have)
        target[kind] = have + new
        CACHE.write_text(json.dumps(cache, indent=1, ensure_ascii=False), encoding="utf-8")
        write_lua()
        skipped = ", ".join(f"{k} {v}" for k, v in sorted(rejected.items())) or "none"
        print(f"[{n}/{len(jobs)}] {accent} {persona} {kind}: +{len(new)} ({time.time() - t:.0f}s, rejected: {skipped})")
    print(f"Done in {(time.time() - started) / 60:.1f} min. Wrote {OUTPUT.name}; /reload in game.")


if __name__ == "__main__":
    main()
