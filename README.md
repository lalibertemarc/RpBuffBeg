# RpBuffBeg

*Ask nicely. Or not. It depends who you are.*

A WoW Forever and Classic Era roleplay addon. Target a friendly player whose class can buff you and RpBuffBeg asks them for it in `/say` (or a whisper, if you prefer), in your character's own voice. Pick a personality and every ask and every thank-you fits it:

> Um, Bob Smith? Sorry to bother you... could I maybe have Arcane Intellect? Only if it's no trouble. *(timid)*

> Bob Smith, what's your rate for a Blessing of Kings? I'm good for it. *(mercenary)*

## Personalities

Bold, Cheerful, Wise, Gruff, Roguish, Mystic, Scholarly and Timid (the same set as Campfire Tales Forever; a character's Campfire Tales personality is picked up on first login), plus Noble, Charming, Devout and Mercenary, or "A bit of everything". Each has 10 asks, 4 refreshes and 8 thank-yous, plus 2 asks for each class of your own (a timid warrior, a gruff mage, a charming warlock...), used 3 times in 10. 480 lines in all.

Pick it per character in Esc > Options > AddOns > RpBuffBeg (with a Preview button), by right-clicking the icon, or with `/buffbeg persona <name>`.

## What you ask for

| Their class | You ask for |
|---|---|
| Paladin | Blessing of Kings (level 20+), then Blessing of Might if you're a warrior or rogue, Blessing of Wisdom otherwise. Classic Era: Might/Wisdom first, since Kings is a talent there |
| Druid | Mark of the Wild |
| Priest | Power Word: Fortitude, then Divine Spirit (level 30+) if you use mana |
| Mage | Arcane Intellect, if you use mana |

You never ask for a buff you already have, unless it's about to drop (20 minutes left; 2 in Classic Era), and never for one your target is too low level to know. Group versions count as given.

## Features

- **Icon next to the target frame**, shown while your target has a buff for you. With [EzBlessings](https://github.com/lalibertemarc/EzBlessings) on a paladin, it sits just under the EzBlessings button instead, and follows it if you move it. Click to ask. A check mark means you have everything they can give; a gold border means a buff is fading and the click asks for a refresh. Right-click to change your personality.
- **Thank-you button** (the coin) beside it.
- **Say or whisper.** Lines go out in `/say` by default; switch to whispering them to your target on the options page or with `/buffbeg whisper`. The setting is shared by all your characters.
- **Clickable names.** Your target's name in your own line becomes a class-colored player link in your chat.
- **Key bindings** for both under Options > Keybindings > RpBuffBeg. They work with the interface hidden.
- **Steps aside for [EzMinion](https://github.com/lalibertemarc/EzMinion).** On a warlock with EzMinion loaded, RpBuffBeg stays off (no icon, bindings or options), since EzMinion already orders your buffs. Other classes are unaffected.

Edit the lines in `Voices.lua` (`{name}`, `{buff}`, and `{me}`/`{my}`, which become "us"/"our" in a group) and the buffs in `Data.lua`.

## Install

Install from CurseForge or Wago, or download the zip from the [Releases](../../releases) page and extract the `RpBuffBeg` folder into your client's AddOns folder:

```
World of Warcraft\_classic_beta_\Interface\AddOns\
World of Warcraft\_classic_era_\Interface\AddOns\
```

## Commands

Use `/buffbeg` or `/rpbb`.

| Command | Does |
|---|---|
| `/buffbeg` | Ask your target for a buff |
| `/buffbeg thanks` | Thank your target |
| `/buffbeg persona [name]` | Show or change your personality |
| `/buffbeg say` / `whisper` | Say your lines (default) or whisper them to your target |
| `/buffbeg preview` | Sample lines in your personality (only you see them) |
| `/buffbeg config` | Open the options |
| `/buffbeg lock` / `unlock` | Lock or unlock the button (Shift-drag always moves it) |
| `/buffbeg reset` | Reset the button position |
