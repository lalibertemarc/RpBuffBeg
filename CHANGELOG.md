# RpBuffBeg

## Unreleased

- **Class asks retired.** Personalities no longer have extra asks for each class you play: every ask comes from the personality's own 20. 552 lines in all, times four with the accents.
- **Generated lines (your own install).** `tools/generate.py` has a local LLM (Ollama) write more lines in each personality's voice into `Generated.lua`, and `tools/new_persona.py` adds personalities of your own. Neither is packaged. `/buffbeg lines mix | only | off` picks how generated lines are used.

## v1.1.0

- **Twice the lines.** Every personality now has 20 asks, 10 refreshes and 16 thank-yous, and 4 asks for each class instead of 2 (so class lines no longer just alternate): 984 lines in all. Gruff mages, timid rogues hiding behind barrels, mercenary priests selling resurrections at fifty silver.
- **Orc, troll and dwarf accents.** Every line also comes in an orc, troll and dwarf version, same personality, same joke: Lok'tar, mon, and by me beard. Your race picks it, and only your accent is kept in memory. Dwarves call your target "lad" or "lass".

## v1.0.0

- **First release.** Target a friendly player whose class can buff you and ask them for it, in `/say`, in your character's own voice: "Um, Bob Smith? Sorry to bother you... could I maybe have Arcane Intellect? Only if it's no trouble." A coin button beside the icon thanks them.
- **Twelve personalities**, picked per character: bold, cheerful, wise, gruff, roguish, mystic, scholarly and timid (a character's Campfire Tales Forever personality is picked up on first login), plus noble, charming, devout and mercenary, or "a bit of everything". Each has its own asks, refreshes and thank-yous, and its own asks for each class you play: 480 lines in all. Change it on the options page (with a preview), by right-clicking the icon, or with `/buffbeg persona`.
- **Only what you need.** Paladins are asked for Kings, then Might (warriors and rogues) or Wisdom (everyone else); druids for Mark of the Wild; priests for Fortitude, then Divine Spirit if you use mana; mages for Arcane Intellect if you use mana. Nothing you already have, unless it's about to drop, and nothing your target is too young to know.
- **Say or whisper.** `/say` by default; whisper your target instead on the options page or with `/buffbeg whisper`.
- **Plays well with EzBlessings and EzMinion.** On a paladin, the icon sits under the EzBlessings button instead of on top of it. On a warlock with EzMinion, RpBuffBeg stays off and lets your minions do the work.
- Works in WoW Forever and Classic Era. In Era, paladins are asked for Might or Wisdom before Kings (a talent there), and a buff is asked for again with 2 minutes left.
