"""Adds a personality of your own to RpBuffBeg, then has the local LLM write its lines.

You give it a name, a one-sentence description (shown in the personality dropdown, and what the model
goes by) and a few seed lines of your own: the more you write, the more the generated lines sound like
you. It's saved in tools/personas.json, written into Generated.lua (your install only, never packaged)
and shows up in the personality dropdown and /buffbeg persona after a /reload.

    python tools/new_persona.py                 # create one, or edit one of yours (type its key)
    python tools/new_persona.py --list          # your personalities
    python tools/new_persona.py --remove pirate # delete one and its generated lines
"""
import argparse
import json
import re
import subprocess
import sys

import generate as g

HELP = """Placeholders: {name} = your target (put it in every line), {buff} = the buff's name (asks and
refreshes only, never in thanks), {me} / {my} = me/my, or us/our in a group (only after a verb:
"give {me} {buff}", never at the start of a line). Under 110 characters, no * or |."""

KIND_HELP = {
    "asks": "ASKS: you ask your target for a buff. Example: {name}, cast {buff} on {me}, there's a dragon to annoy.",
    "refreshes": "REFRESHES: the buff they gave you is about to wear off. Example: {name}, {my} {buff} is fading. Again!",
    "thanks": "THANKS: they just buffed you. Example: Thank you, {name}! I owe you a drink.",
}


def save(custom):
    g.PERSONAS_FILE.write_text(json.dumps(custom, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
    g.write_lua()


def ask(prompt, default=""):
    shown = f" [{default}]" if default else ""
    reply = input(f"{prompt}{shown}: ").strip()
    return reply or default


def yes(prompt, default=True):
    reply = input(f"{prompt} [{'Y/n' if default else 'y/N'}]: ").strip().lower()
    return default if not reply else reply.startswith("y")


def ask_seeds(kind, current):
    """Seed lines for one kind, typed one per line; an empty line finishes."""
    print("\n" + KIND_HELP[kind])
    if current:
        print("  Current:")
        for line in current:
            print("    " + line)
        if not yes("  Replace them?", default=False):
            return current
    print("  Type a few lines (3-5 is plenty), Enter on an empty line when done.")
    lines = []
    while True:
        reply = input("  > ").strip()
        if not reply:
            return lines
        line, why = g.clean(reply, kind, "plain")
        if why:
            print(f"    Not kept ({why}). Try again.")
        else:
            lines.append(line)


def create(custom):
    builtin = g.parse_personas()
    print("New personality. Its key is what you type in /buffbeg persona <key>: lower case letters only.")
    print("Type one of yours to edit it: " + (", ".join(custom) or "(none yet)") + "\n")
    while True:
        key = ask("Key (e.g. pirate)").lower()
        if not re.fullmatch(r"[a-z]+", key):
            print("  Letters only.")
        elif key in builtin or key == "mixed":
            print(f"  {key} is one of the addon's own personalities. Pick another key.")
        else:
            break
    old = custom.get(key, {})
    if old:
        print(f"Editing {key}. Enter keeps what's in brackets.")
    label = ask("Name in the dropdown", old.get("label", key.capitalize()))
    print("One sentence on how they talk. The model goes by this, so be specific.")
    print("  e.g. A salty sea dog. Every buff is plunder, every friend a shipmate.")
    desc = ""
    while not desc:
        desc = ask("Description", old.get("desc", ""))
    print("\n" + HELP)
    seeds = {kind: ask_seeds(kind, old.get("seeds", {}).get(kind, [])) for kind in g.KINDS}
    custom[key] = {"label": label, "desc": desc, "seeds": seeds}
    save(custom)
    print(f"\nSaved {label} ({key}) to tools/personas.json and Generated.lua.")

    if yes("\nWrite its lines with the local LLM now (a few minutes)?"):
        script = str(g.ROOT / "tools" / "generate.py")
        subprocess.run([sys.executable, script, "--persona", key], check=False)
        if yes("Also with the orc, troll and dwarf accents (about 3x as long)?", default=False):
            subprocess.run([sys.executable, script, "--persona", key, "--accent", "orc,troll,dwarf"], check=False)
    else:
        print(f"Later: python tools/generate.py --persona {key}")
    print(f"\nIn game: /reload, then /buffbeg persona {key} (or pick {label} in the options) and /buffbeg preview.")


def remove(custom, key):
    if key not in custom:
        sys.exit(f"No personality of yours called {key}. Yours: {', '.join(custom) or 'none'}")
    del custom[key]
    cache = g.load_cache()
    for personas in cache.values():
        personas.pop(key, None)
    # Accents that only had this personality.
    cache = {a: personas for a, personas in cache.items() if personas}
    g.CACHE.write_text(json.dumps(cache, indent=1, ensure_ascii=False), encoding="utf-8")
    save(custom)
    print(f"Removed {key} and its generated lines. Characters using it go back to the default after /reload.")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--list", action="store_true", help="show your personalities")
    ap.add_argument("--remove", metavar="KEY", help="delete one of your personalities and its lines")
    args = ap.parse_args()
    custom = g.load_custom()
    if args.list:
        for key, p in custom.items():
            counts = ", ".join(f"{k} {len(v)}" for k, v in p["seeds"].items())
            print(f"{key:12} {p['label']}: {p['desc']} (seed lines: {counts})")
        if not custom:
            print("None yet. Run python tools/new_persona.py to make one.")
    elif args.remove:
        remove(custom, args.remove.lower())
    else:
        try:
            create(custom)
        except (KeyboardInterrupt, EOFError):
            print("\nCancelled.")


if __name__ == "__main__":
    main()
