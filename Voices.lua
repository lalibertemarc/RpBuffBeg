-- RpBuffBeg lines, one set per personality (keys from ns.PERSONAS in Data.lua).
-- asks: you ask your target for a buff. refreshes: the buff they can give you is about to drop
-- (ns.REFRESH_THRESHOLD). thanks: the thank-you button. One line is picked at random, never the
-- same twice in a row. Placeholders: {name}, {buff} (asks and refreshes), {me} and {my} ("us" and
-- "our" in a group). Never start a line with {me} or {my} (it would come out in lower case).
local _, ns = ...

ns.VOICES = {
bold = {
    asks = {
        "{name}! You there. {buff}, on {me}. I'll put it to good use.",
        "{name}, I'm about to do something reckless. {buff} would make it slightly less reckless.",
        "Cast {buff} on {me}, {name}. Whatever's out there won't know what hit it.",
        "{name}, the next fight is going to be glorious. Give {me} {buff} and come watch.",
        "{name}, I never ask twice, and I rarely ask once. {buff}, if you please.",
        "Give {me} {buff}, {name}, and I'll tell everyone it was the secret to my victory.",
        "{name}, I've charged worse odds with less. But {buff} would make it a fair fight. For them.",
        "{name}! {buff}! I've got a whole lot of trouble to go and find!",
        "{name}, every hero needs a blessing before the charge. Give {me} {buff}.",
        "{name}, lend {me} {buff} and I'll bring you back a trophy. Possibly with teeth.",
    },
    refreshes = {
        "{name}, {my} {buff} is wearing thin and the fighting isn't. Top it up!",
        "{name}, {my} {buff} is fading. The enemy isn't. Again, if you would!",
        "Another {buff}, {name}! The last one got used up being magnificent.",
        "{name}, {my} {buff} is almost spent. Renew it, and I'll spend this one even better.",
    },
    thanks = {
        "Ha! That's the stuff, {name}. Now watch me use it.",
        "Thank you, {name}! I'll name my next victory after you.",
        "{name}, I feel unstoppable. More than usual, even.",
        "Much obliged, {name}. If anything out there survives, I'll send it your way.",
        "Thanks, {name}! I'd say I owe you, but you'll see me earn it.",
        "That'll do nicely, {name}. Stand back, this is going to be fun.",
        "{name}, you have my thanks and a front row seat.",
        "Now that's a blessing! Thanks, {name}. Somebody, somewhere, is about to regret everything.",
    },
},

cheerful = {
    asks = {
        "Hi, {name}! Would you be a dear and cast {buff} on {me}? You're the best!",
        "{name}! Lovely day for a {buff}, isn't it? Could I have one?",
        "Oh, {name}, could you spare a {buff} for {me}? I'll owe you a pie!",
        "{name}, a little {buff} would make my whole day. Pretty please?",
        "Hello, {name}! Fancy sharing a little {buff}? It looks wonderful on everyone.",
        "{name}, you look like someone who gives the best {buff} in town. May I?",
        "Excuse me, {name}! Any chance of a {buff}? I promise to use it for good.",
        "{name}, friend! I'd love some {buff}, if it's no trouble.",
        "{name}, would you sprinkle a little {buff} on {me}? I'll sing your praises all day!",
        "Oh, {name}, {buff} would be just the thing! Would you mind terribly?",
    },
    refreshes = {
        "{name}, {my} {buff} is running out, and I was having so much fun with it! One more?",
        "Oops, {my} {buff} is fading, {name}. Could I have a fresh one, please?",
        "{name}, your {buff} was so lovely I wore it right out! Another, please?",
        "{name}, {my} {buff} is nearly gone. Top it up for a friend?",
    },
    thanks = {
        "Thank you, {name}! You're wonderful!",
        "Oh, that's lovely! Thanks so much, {name}!",
        "{name}, you've made my whole day. Thank you!",
        "Thanks a bunch, {name}! I owe you a pie. A big one.",
        "You're a treasure, {name}! Thank you!",
        "Thank you, thank you, {name}! I feel brilliant!",
        "{name}, that was so kind. Thank you, friend!",
        "Hooray! Thanks, {name}! Have a wonderful day!",
    },
},

wise = {
    asks = {
        "{name}, the river does not refuse the thirsty. Would you share {buff}?",
        "A wise traveler never refuses help, {name}. A kind one offers it. Would you give {me} {buff}?",
        "{name}, the long road is shorter with {buff}. Would you grant it?",
        "{name}, they say a gift given freely weighs nothing. Would you give {me} {buff}?",
        "Patience is a virtue, {name}. So, I am told, is generosity. Would you give {me} {buff}?",
        "{name}, the oak shelters the traveler without asking why. Would you shelter {me} with {buff}?",
        "{name}, one candle lights another and loses nothing. Would you spare {me} {buff}?",
        "Strength shared is strength doubled, {name}. Would you cast {buff} on {me}?",
        "{name}, every journey needs a blessing at the start. Would you give {me} {buff}?",
        "{name}, the humble ask, and the generous answer. I ask: {buff}, if you would.",
    },
    refreshes = {
        "{name}, all things fade, even {buff}. Would you renew it?",
        "The tide goes out, {name}, and so does {my} {buff}. Would you bring it back in?",
        "{name}, {my} {buff} has served its season. A new one, if you would.",
        "Nothing lasts, {name}, but {buff} can be renewed. Would you?",
    },
    thanks = {
        "Thank you, {name}. Kindness is never wasted.",
        "{name}, a gift given freely is the richest kind. Thank you.",
        "My thanks, {name}. May your road be as kind as you.",
        "{name}, I will remember this. The world needs more like you.",
        "Thank you, {name}. The giver is twice blessed.",
        "{name}, you have lightened my road. I am grateful.",
        "Well given, {name}. May it return to you tenfold.",
        "Thank you, {name}. Small kindnesses move mountains.",
    },
},

gruff = {
    asks = {
        "{name}. {buff}. Please. There, I said it.",
        "Oi, {name}. Give {me} {buff}, would you. Don't make a fuss about it.",
        "{name}, I hate asking. So I'll ask once. {buff}.",
        "Right, {name}. {buff}. On {me}. Today, ideally.",
        "{name}, my knees hurt, my back hurts, and I've no {buff}. Fix one of those.",
        "Don't look at me like that, {name}. Just cast {buff}.",
        "{name}, I've walked all day and I've no patience left. {buff}, please. Quick about it.",
        "Hmph. {name}. {buff}. I'd do it myself if I could.",
        "{name}, in my day we didn't need {buff}. It's not my day anymore. Give it here.",
        "{name}, I'm not begging. I'm asking. Grumpily. {buff}.",
    },
    refreshes = {
        "{name}. {buff}. Again. It wore off, like everything does.",
        "Oi, {name}, {my} {buff} is falling off. Cheap stuff. Another.",
        "{name}, your {buff} didn't last. Shocking. Do it again.",
        "{name}. {buff} is fading. Don't make me ask twice. Again, I mean.",
    },
    thanks = {
        "Hmph. Thanks, {name}.",
        "{name}. Good. Fine. Thanks.",
        "Suppose that'll do. Thanks, {name}.",
        "{name}, that's... decent. Don't let it go to your head.",
        "Thanks, {name}. Don't expect a hug.",
        "Right. Ta, {name}.",
        "{name}. Not bad. Not bad at all. Thanks.",
        "Fine, fine. Thank you, {name}. Happy now?",
    },
},

roguish = {
    asks = {
        "{name}, my friend, how about a little {buff} for {me}? I'll owe you one. Maybe.",
        "Psst, {name}. {buff}. Nobody needs to know.",
        "{name}, I'll trade you a secret for {buff}. Good secret, too.",
        "{name}, I'd pick your pocket for {buff}, but asking seemed friendlier.",
        "{name}, give {me} {buff}, and I'll forget I saw you earlier.",
        "{name}, I've got a little job tonight. {buff} would really help the odds.",
        "Evening, {name}. Fancy giving {me} {buff}? I'll split the take with you. Probably.",
        "{name}, call it an investment: {buff} for {me}, and returns in the morning.",
        "{name}, I swear on my honest face: {buff} will be used for good. Mostly.",
        "{name}, I'd steal {buff} if spells could be stolen. Spare me the trouble?",
    },
    refreshes = {
        "{name}, {my} {buff} slipped away. Can't think who took it. Another?",
        "{name}, your {buff} ran off like a mark at dawn. One more?",
        "{name}, {my} {buff} is almost gone. Funny how that keeps happening. Again?",
        "Same deal as last time, {name}? Another {buff}, same terms.",
    },
    thanks = {
        "Pleasure doing business, {name}.",
        "{name}, you're a soft touch, and I love you for it. Thanks.",
        "Thanks, {name}. Your coin purse is still where you left it. I checked.",
        "{name}, I owe you one. Don't tell anyone I said that.",
        "Nice. Thanks, {name}. I'll put in a good word with the right people.",
        "{name}, you've a generous soul. Rare, in my line of work. Thanks.",
        "Thanks, {name}. If anyone asks, you never saw me.",
        "{name}, you're a friend. I've got very few of those. Thanks.",
    },
},

mystic = {
    asks = {
        "{name}, the stars foretold you would give {me} {buff}. Shall we not keep them waiting?",
        "The spirits whisper your name, {name}. They also whisper {buff}.",
        "{name}, I dreamed of you last night. You were casting {buff} on {me}.",
        "{name}, the omens are clear: {buff}, from your hands, today.",
        "{name}, the cards say a stranger will give {me} {buff}. You are that stranger.",
        "{name}, the smoke curled into the shape of {buff} this morning. Then into your face.",
        "The wind brought me to you, {name}. It wants {me} to have {buff}.",
        "{name}, refusing the omens is bad luck. The omens say {buff}.",
        "{name}, I have read the bones. They say {buff}, and they are rarely wrong.",
        "{name}, the veil is thin today. Give {me} {buff}, and I will tell you what lies beyond.",
    },
    refreshes = {
        "{name}, the spirits say {my} {buff} is fading. They are right, as always.",
        "{name}, I sense {my} {buff} slipping away like smoke. Renew it?",
        "{name}, the moon has turned, and {my} {buff} with it. Again?",
        "The omens warned me {buff} would fade, {name}. They also said you'd renew it.",
    },
    thanks = {
        "The spirits are pleased, {name}. So am I.",
        "{name}, it was written. And now it is done. Thank you.",
        "Thank you, {name}. Your aura glows a little brighter for it.",
        "{name}, the stars will remember this kindness.",
        "My thanks, {name}. I see good fortune in your future. Very soon.",
        "{name}, the omens were true. Thank you.",
        "Thank you, {name}. The wind carries your name more kindly now.",
        "{name}, a kindness given echoes beyond the veil. Thank you.",
    },
},

scholarly = {
    asks = {
        "{name}, might I study your {buff}? Firsthand. On {me}, ideally.",
        "{name}, for purely academic purposes, could you cast {buff} on {me}?",
        "{name}, I'm writing a treatise on {buff}. A practical demonstration would be invaluable.",
        "Fascinating robes, {name}. Fascinating spells, too. Could I have {buff}, for my notes?",
        "{name}, my research shows travelers with {buff} live forty percent longer. Would you?",
        "{name}, I've read everything on {buff}, but I've never felt one of yours. May I?",
        "Excuse me, {name}, would you cast {buff} on {me}? I'd like to time how long it lasts.",
        "{name}, I've a theory that {buff} improves concentration. Help me test it?",
        "{name}, a footnote in my journal is waiting for you. Give {me} {buff}, and I'll fill it in.",
        "{name}, I'd be ever so grateful for {buff}. Strictly in the interest of science.",
    },
    refreshes = {
        "{name}, {my} {buff} has run its course. Fascinating. May I have another sample?",
        "{name}, my notes say {buff} lasts about this long. Could you renew it so I can confirm?",
        "{name}, {my} {buff} is fading right on schedule. Would you renew it for the second trial?",
        "{name}, experiment one is ending. May I have {buff} again, for experiment two?",
    },
    thanks = {
        "Thank you, {name}! I'll cite you in my next paper.",
        "{name}, excellent casting. Textbook. Thank you.",
        "Fascinating. Thank you, {name}. That's going straight in the journal.",
        "{name}, a fine specimen of a spell. Many thanks.",
        "Thank you, {name}. Your contribution to science is noted.",
        "{name}, thank you! The data is very promising.",
        "Most kind, {name}. I'll add you to the acknowledgments.",
        "Thank you, {name}. I feel smarter already. Measurably.",
    },
},

timid = {
    asks = {
        "Um, {name}? Sorry to bother you... could I maybe have {buff}? Only if it's no trouble.",
        "{name}, I, um... {buff}? Please? Sorry.",
        "Excuse me, {name}... I don't suppose you'd have a {buff} to spare? It's fine if not!",
        "{name}? Hi. Sorry. Could you... {buff}? Thank you. Sorry.",
        "{name}, it's very scary out there, and {buff} would help so much. If you don't mind...",
        "S-sorry, {name}! I didn't mean to stare, I was just hoping for {buff}...",
        "{name}, I practiced asking you for {buff} three times. Um. Could I have it?",
        "Um, {name}, would {buff} be too much to ask? I can go away, it's fine.",
        "{name}... please, {buff}? There are wolves out there. Big ones.",
        "{name}, I'm so sorry to interrupt, but could I possibly have {buff}? Please?",
    },
    refreshes = {
        "Um, {name}? The {buff} is fading... could I have another? Sorry.",
        "{name}, sorry, I know you already gave {me} {buff}, but it's almost gone...",
        "S-sorry again, {name}! {buff}... one more? Please?",
        "{name}, I hate to ask twice, but {my} {buff} is wearing off...",
    },
    thanks = {
        "Oh! Thank you, {name}! Thank you so much!",
        "{name}, thank you... that was really kind.",
        "Th-thank you, {name}! I feel much braver now.",
        "Thank you, {name}. Sorry for bothering you. Thank you!",
        "{name}, you didn't have to... but thank you.",
        "Oh, wow. Thank you, {name}. Really.",
        "Thank you, {name}! Maybe the wolves won't be so scary now.",
        "{name}... thanks. You're very nice.",
    },
},

noble = {
    asks = {
        "{name}, you may cast {buff} upon {me}. Consider it an honor.",
        "{name}, my family has been blessed for generations. Do continue the tradition: {buff}.",
        "Ah, {name}. {buff}, if you would. One does not ask twice.",
        "{name}, a person of my station requires {buff}. See to it.",
        "{name}, I shall permit you to give {me} {buff}. Do try to be quick.",
        "{name}, my steward usually handles this, but my steward is indisposed. {buff}, please.",
        "{name}, I find myself unblessed. Most irregular. {buff}, at once.",
        "{name}, you have the look of capable help. Prove it: {buff}.",
        "{name}, I'll have {buff}. And do mind the cape.",
        "{name}, I am told you are the finest caster in the area. {buff}, then.",
    },
    refreshes = {
        "{name}, {my} {buff} has lapsed. Unacceptable. Renew it.",
        "{name}, your {buff} was adequate but brief. Another, please.",
        "{name}, it appears {my} {buff} is fading. Do something about that.",
        "{name}, kindly renew {my} {buff}. Standards must be maintained.",
    },
    thanks = {
        "Adequate, {name}. You may go.",
        "{name}, you have served admirably. I shall mention you at court.",
        "Very good, {name}. My thanks, such as they are.",
        "{name}, splendid. You'll be remembered in my memoirs. A footnote, perhaps.",
        "Thank you, {name}. One does appreciate good service.",
        "{name}, that will do. Here, have a nod of approval.",
        "Most satisfactory, {name}. My family thanks you.",
        "{name}, well done. You may tell your friends you blessed me.",
    },
},

charming = {
    asks = {
        "{name}, has anyone told you your {buff} is as lovely as your eyes? Could I have one?",
        "Well hello, {name}. Cast {buff} on {me}, and I'll cast a smile on you.",
        "{name}, I'd ask for your heart, but I'll settle for {buff}. For now.",
        "{name}, a {buff} from you would make me feel... special.",
        "{name}, they say {buff} looks best when cast by someone beautiful. Shall we test it?",
        "Oh, {name}, you wouldn't refuse {me} {buff}, would you? Not with that smile.",
        "{name}, darling, a little {buff}? I'll think of you every time it glows.",
        "{name}, I came over to ask for {buff}, and now I've forgotten my own name.",
        "{name}, you have magic hands, I can tell. Show me: {buff}?",
        "{name}, buy you a drink later? For now, a {buff} would be lovely.",
    },
    refreshes = {
        "{name}, {my} {buff} is fading. Just like me, when you're not around.",
        "{name}, I miss your {buff} already. Another, darling?",
        "{name}, your last {buff} wore off. I couldn't stop thinking about it.",
        "{name}, renew {my} {buff}? It's the closest I get to holding your hand.",
    },
    thanks = {
        "{name}, you're a dream. Thank you.",
        "Thank you, {name}. I'll be blushing for hours.",
        "{name}, that felt wonderful. You're wonderful.",
        "Mmm, thank you, {name}. Same time tomorrow?",
        "{name}, you have a gift. Several, clearly. Thank you.",
        "Thank you, darling {name}. Consider my heart stolen.",
        "{name}, you're as kind as you are lovely. Thank you.",
        "{name}, I'll write a song about you. A love song. Thank you.",
    },
},

devout = {
    asks = {
        "{name}, would you bless {me} with {buff}? The road ahead is long.",
        "In good faith, {name}, I ask for {buff}. May kindness guide your hand.",
        "{name}, I pray each morning for a kind soul. Would you answer that prayer with {buff}?",
        "{name}, blessed are the generous. Would you share {buff} with {me}?",
        "{name}, may the heavens smile on you. And perhaps on me, through {buff}?",
        "{name}, a blessing given is a blessing returned. Would you give {me} {buff}?",
        "{name}, I ask humbly, as a pilgrim: would you grant {me} {buff}?",
        "{name}, I have prayed for strength. I believe you are the answer. {buff}, please?",
        "Peace be with you, {name}. Would you bless {me} with {buff}?",
        "{name}, the faithful look out for one another. Would you cast {buff} on {me}?",
    },
    refreshes = {
        "{name}, {my} {buff} fades, as all earthly things do. Would you renew the blessing?",
        "{name}, forgive me. {buff} is leaving me. Would you bless {me} once more?",
        "{name}, the blessing grows faint. Would you renew {my} {buff}?",
        "{name}, I ask again, humbly: {buff}, before the old one fades.",
    },
    thanks = {
        "Bless you, {name}. Truly.",
        "{name}, your kindness is a prayer answered. Thank you.",
        "Thank you, {name}. I'll keep you in my prayers tonight.",
        "May you be blessed in turn, {name}. Thank you.",
        "{name}, I give thanks for you. Truly.",
        "Thank you, {name}. The heavens saw that, I'm sure of it.",
        "{name}, your generosity honors us all. Thank you.",
        "Peace and blessings, {name}. Thank you.",
    },
},

mercenary = {
    asks = {
        "{name}, what's your rate for a {buff}? I'm good for it.",
        "{name}, {buff}, and I'll owe you a favor. Favors are worth more than gold.",
        "{name}, I'm on contract and the contract says I need {buff}. Help a professional out?",
        "{name}, give {me} {buff} and I'll split the loot. Ten percent. Fine, fifteen.",
        "{name}, time is money. {buff}, and we both get back to earning.",
        "{name}, {buff} on {me} is a sound investment. Returns guaranteed. Mostly.",
        "{name}, how about a deal? {buff} for {me}, and I won't charge you for the escort later.",
        "{name}, I pay my debts. Give {me} {buff}, and you'll get yours.",
        "{name}, a {buff} now saves a repair bill later. Basic economics.",
        "{name}, name your price for {buff}. Then lower it, we're friends.",
    },
    refreshes = {
        "{name}, the {buff} contract on {me} just expired. Renew at the same rate?",
        "{name}, {my} {buff} is nearly spent. Repeat business?",
        "{name}, another {buff}? I'm a loyal customer.",
        "{name}, {my} {buff} is running out. Same deal as last time?",
    },
    thanks = {
        "Good doing business with you, {name}.",
        "{name}, I'll put that on your tab. In your favor, for once.",
        "Thanks, {name}. That's worth at least a silver. I'll owe you.",
        "{name}, solid work. I'd hire you.",
        "Thanks, {name}. Consider your account in good standing.",
        "{name}, you just earned a discount on my services. Thanks.",
        "Much obliged, {name}. Debts get paid. I'll remember.",
        "{name}, fair trade. Well, you got nothing. Thanks anyway.",
    },
},
}

-- Extra asks for your own class, by personality. Used instead of the asks above ns.CLASS_CHANCE of the time.
ns.CLASS_ASKS = {
bold = {
    WARRIOR = {
        "{name}, I've got a shield, a sword and a bad idea. Add {buff} and it becomes a good one.",
        "{name}, I charge first and ask questions never. Give {me} {buff} before I go.",
    },
    PALADIN = {
        "{name}, my hammer is ready and my faith is strong. {buff} would make them unbreakable.",
        "{name}, I bless others all day. Bless {me} back with {buff}, and I'll smite twice as hard.",
    },
    HUNTER = {
        "{name}, my pet and I are going after the biggest beast in the land. {buff}, for luck?",
        "{name}, one arrow, one kill. With {buff}, maybe two kills.",
    },
    ROGUE = {
        "{name}, I'll be in and out before they blink. With {buff}, before they breathe.",
        "{name}, I take what I want from the shadows. Today I just ask: {buff}.",
    },
    PRIEST = {
        "{name}, I keep everyone alive. Help keep me standing: {buff}.",
        "{name}, even a healer charges in sometimes. Give {me} {buff}, and watch.",
    },
    SHAMAN = {
        "{name}, the storm answers me. With {buff}, it'll answer louder.",
        "{name}, my totems are down and my blood is up. {buff}, quick!",
    },
    MAGE = {
        "{name}, I'm about to set something very large on fire. {buff} would help it burn.",
        "{name}, I've blinked into worse. Give {me} {buff} and I'll blink right back out.",
    },
    WARLOCK = {
        "{name}, demons fear me. With {buff}, they'll fear me more.",
        "{name}, I've stared into the Nether and laughed. {buff}, so I can laugh louder.",
    },
    DRUID = {
        "{name}, bear, cat or tree, I go in first. {buff}, for whatever shape I'm in.",
        "{name}, nature fights with me. Give {me} {buff} and nature fights harder.",
    },
},
cheerful = {
    WARRIOR = {
        "{name}! I'm off to hit things! {buff} would make the hitting extra fun!",
        "Hi, {name}! My shield's polished and my smile's ready. Just missing {buff}!",
    },
    PALADIN = {
        "{name}, I hand out blessings all day! Would you hand one back? {buff}, please!",
        "Hello, {name}! My hammer and I would love some {buff}!",
    },
    HUNTER = {
        "{name}! My pet says hi! We'd both love some {buff}!",
        "Hi, {name}! Could you spare a {buff}? My pet will do a trick for you!",
    },
    ROGUE = {
        "Hello, {name}! Don't worry, I'm one of the friendly rogues! Could I have {buff}?",
        "{name}! I promise I only stab the bad ones! {buff}, please?",
    },
    PRIEST = {
        "{name}, I heal people all day, and I love it! Would you give {me} {buff} in return?",
        "Hi, {name}! A healer with {buff} is a happy healer!",
    },
    SHAMAN = {
        "{name}! The spirits are in a great mood today, and {buff} would make mine even better!",
        "Hello, {name}! I'll drop you a totem if you drop {me} {buff}!",
    },
    MAGE = {
        "{name}! I'll conjure you a snack for a {buff}! Deal?",
        "Hi, {name}! Want a sandwich? It's free! A {buff} would be lovely, though!",
    },
    WARLOCK = {
        "{name}! My imp says please! Well, it said something. Could I have {buff}?",
        "Hi, {name}! I'm a nice warlock, honest! Could I have {buff}?",
    },
    DRUID = {
        "{name}! I'll turn into a bear and give you a hug for a {buff}!",
        "Hello, {name}! The flowers told me you give the best {buff}!",
    },
},
wise = {
    WARRIOR = {
        "{name}, a shield protects others; {buff} protects the shield. Would you?",
        "{name}, the blade that is cared for lasts longest. Would you care for this one with {buff}?",
    },
    PALADIN = {
        "{name}, even those who bless must sometimes be blessed. Would you give {me} {buff}?",
        "{name}, the Light flows best in both directions. Would you share {buff}?",
    },
    HUNTER = {
        "{name}, the hunter waits, the hunter watches, and sometimes the hunter asks. {buff}, please.",
        "{name}, my companion and I walk far. {buff} would ease the trail.",
    },
    ROGUE = {
        "{name}, the shadow knows the value of a friend in the light. Would you give {me} {buff}?",
        "{name}, a quiet blade needs a steady hand. {buff} would steady mine.",
    },
    PRIEST = {
        "{name}, the healer must also be healed. Would you give {me} {buff}?",
        "{name}, one who tends the flock still needs shelter. Would you grant {buff}?",
    },
    SHAMAN = {
        "{name}, the elements give to those who give. Would you give {me} {buff}?",
        "{name}, earth, air, fire and water ask nothing. I ask only {buff}.",
    },
    MAGE = {
        "{name}, knowledge is power, and power is better shared. Would you share {buff}?",
        "{name}, the arcane teaches patience. My patience asks for {buff}.",
    },
    WARLOCK = {
        "{name}, one who walks with shadow is wise to keep friends in the light. {buff}, please.",
        "{name}, even dark paths need a lamp. Would you light mine with {buff}?",
    },
    DRUID = {
        "{name}, the forest gives freely. Will you, with {buff}?",
        "{name}, the wild is balance. Your {buff} would restore mine.",
    },
},
gruff = {
    WARRIOR = {
        "{name}. Took three arrows today. Don't want a fourth. {buff}.",
        "{name}, my armor's dented and my patience is worse. {buff}.",
    },
    PALADIN = {
        "{name}, I've blessed every ungrateful soul from here to the coast. My turn. {buff}.",
        "{name}, my hammer's heavy and my temper's heavier. {buff}, please.",
    },
    HUNTER = {
        "{name}, my pet ate my lunch. I'll take {buff} instead.",
        "{name}, out of arrows, out of patience. Not out of manners. {buff}, please.",
    },
    ROGUE = {
        "{name}. Stabbing's hard work. {buff}.",
        "{name}, don't watch your purse, just cast {buff}.",
    },
    PRIEST = {
        "{name}, I heal fools all day. Heal my mood: {buff}.",
        "{name}, I've buffed the whole lot of them and nobody buffs me. {buff}.",
    },
    SHAMAN = {
        "{name}, the spirits are quiet and my totems are broken. {buff}, at least.",
        "{name}, carried four totems up this hill. {buff}. I've earned it.",
    },
    MAGE = {
        "{name}, I conjured water for everyone and got no thanks. Give {me} {buff}, that'll do.",
        "{name}. Mana's low, mood's lower. {buff}.",
    },
    WARLOCK = {
        "{name}, my imp won't shut up. {buff} won't fix that, but it'll help.",
        "{name}. Soul shards are dear, and so's my patience. {buff}.",
    },
    DRUID = {
        "{name}, been a tree all day. Stiff. {buff}.",
        "{name}, I'm a bear before breakfast. Don't test it. {buff}.",
    },
},
roguish = {
    WARRIOR = {
        "{name}, I hit hard, and I hit honest. Mostly. {buff}?",
        "{name}, my shield's for show and my sword's for hire. {buff} raises my rate.",
    },
    PALADIN = {
        "{name}, a paladin asking a favor. Don't tell the order. {buff}?",
        "{name}, I'm the kind of paladin who doesn't ask questions. {buff}, no questions?",
    },
    HUNTER = {
        "{name}, my pet's trained to fetch. Purses, mostly. Give {me} {buff} and it leaves yours alone.",
        "{name}, I know every trail in this land, and a few shortcuts. {buff}, and I'll share one.",
    },
    ROGUE = {
        "{name}, I'd steal {buff}, but it seemed rude. Spare one?",
        "{name}, you'll never see me again. Unless you give {me} {buff}. Then you'll see me grateful.",
    },
    PRIEST = {
        "{name}, I hear confessions, and I keep secrets. Give {me} {buff}, and I'll keep yours.",
        "{name}, a priest who plays cards. Shocking. {buff}, and I'll deal you in.",
    },
    SHAMAN = {
        "{name}, the spirits told me you're a soft touch. Prove them right: {buff}?",
        "{name}, I'll read your fortune for a {buff}. It's a good fortune, I promise.",
    },
    MAGE = {
        "{name}, I can teleport out of any trouble. {buff} helps me get into it.",
        "{name}, I'll make a coin vanish, and then {buff} appear. Your turn first.",
    },
    WARLOCK = {
        "{name}, I've a demon who owes me a favor. Give {me} {buff}, and you can have it.",
        "{name}, I'll trade you a healthstone for {buff}. Slightly used.",
    },
    DRUID = {
        "{name}, I can be a cat. Cats get away with everything. {buff}?",
        "{name}, I'll pick you some herbs for a {buff}. Somebody else's herbs.",
    },
},
mystic = {
    WARRIOR = {
        "{name}, I dreamed my shield broke. {buff} might change that.",
        "{name}, the bones say a warrior falls today. Give {me} {buff}, so it isn't me.",
    },
    PALADIN = {
        "{name}, the Light whispered your name to me. And {buff}.",
        "{name}, I saw your {buff} in a vision. It glowed.",
    },
    HUNTER = {
        "{name}, my pet growled at a shadow only it could see. {buff} would ease us both.",
        "{name}, the beasts speak of you. They say you'd give {me} {buff}.",
    },
    ROGUE = {
        "{name}, the shadows told me where you'd be. They also mentioned {buff}.",
        "{name}, I walk unseen, but the spirits see me. They want {me} to have {buff}.",
    },
    PRIEST = {
        "{name}, the shadows and the Light both point at you. {buff}, please.",
        "{name}, my prayers last night ended with your name. And {buff}.",
    },
    SHAMAN = {
        "{name}, the elements are restless today. {buff} would calm them.",
        "{name}, the earth spirit says you're kind. The air spirit says {buff}.",
    },
    MAGE = {
        "{name}, the ley lines hum your name. They also hum {buff}.",
        "{name}, I scried this moment a week ago. You gave {me} {buff}. Shall we?",
    },
    WARLOCK = {
        "{name}, a voice from the Nether said you'd help. It's usually lying. Prove it right: {buff}.",
        "{name}, my demon sensed your kindness. It shuddered. {buff}, please.",
    },
    DRUID = {
        "{name}, the Dream showed me your face. And {buff}.",
        "{name}, the moon is full, the owls are calling, and they all say {buff}.",
    },
},
scholarly = {
    WARRIOR = {
        "{name}, I'm studying how much damage armor absorbs. {buff} would help the results.",
        "{name}, I've counted every dent in this shield. {buff} might keep the count low.",
    },
    PALADIN = {
        "{name}, I've studied blessings for years. Yours would make a fine comparison: {buff}?",
        "{name}, as a scholar of the Light, I'd love to observe your {buff}. Closely.",
    },
    HUNTER = {
        "{name}, my pet and I are cataloguing the local wildlife. {buff} keeps the cataloguer alive.",
        "{name}, I'm tracking a rare beast. {buff} would help my field notes survive.",
    },
    ROGUE = {
        "{name}, I'm researching locks. Strictly in theory. {buff} would help my concentration.",
        "{name}, I study anatomy. For stabbing. Could I have {buff}?",
    },
    PRIEST = {
        "{name}, I'm comparing schools of faith. Your {buff} would be a fine data point.",
        "{name}, I'm writing on the theology of {buff}. May I experience it?",
    },
    SHAMAN = {
        "{name}, I'm recording how the elements react to {buff}. Would you help?",
        "{name}, my totems have all been catalogued. {buff} has not. Yet.",
    },
    MAGE = {
        "{name}, I've a theory {buff} interacts with my arcane studies. Help me test it?",
        "{name}, the library has nothing on your {buff}. Let me fix that.",
    },
    WARLOCK = {
        "{name}, purely academic: how does {buff} react with fel energy? Let's find out.",
        "{name}, my grimoire has a blank page labeled {buff}. Help me fill it?",
    },
    DRUID = {
        "{name}, I'm studying how {buff} affects shapeshifting. A sample, please?",
        "{name}, I've pressed every leaf in this forest. Now I'd like {buff}.",
    },
},
timid = {
    WARRIOR = {
        "{name}, um, I know warriors are supposed to be brave, but... {buff}? Please?",
        "{name}, my shield's very big, but I'm still scared. {buff} would help...",
    },
    PALADIN = {
        "{name}, I'm a paladin, but I get nervous too. Could I have {buff}?",
        "{name}, um, I bless others, but I'm too shy to ask for... {buff}? Please?",
    },
    HUNTER = {
        "{name}, my pet is braver than me. Could I have {buff}? So I can keep up?",
        "{name}, I hide behind my pet a lot. {buff} would help me hide less.",
    },
    ROGUE = {
        "{name}, I'm a rogue because I like hiding. {buff} would help me hide better.",
        "{name}, sorry, I snuck up on you by accident. Could I have {buff}?",
    },
    PRIEST = {
        "{name}, I heal everyone, but I'm too shy to ask for... {buff}?",
        "{name}, um, could I have {buff}? I'll heal you later. Promise.",
    },
    SHAMAN = {
        "{name}, the thunder scares me, even when it's mine. Could I have {buff}?",
        "{name}, my totems keep falling over. Could I at least have {buff}?",
    },
    MAGE = {
        "{name}, I set my own robe on fire this morning. {buff} would help. Please?",
        "{name}, um, I could conjure you some water? For {buff}?",
    },
    WARLOCK = {
        "{name}, my demon scares me sometimes. {buff} would make me feel safer.",
        "{name}, um, I'm a warlock, but a nice one. Could I have {buff}?",
    },
    DRUID = {
        "{name}, I turn into a cat when I'm nervous. Could I have {buff} before I do?",
        "{name}, um, I'm very good at being a tree. Trees don't have to talk. {buff}?",
    },
},
noble = {
    WARRIOR = {
        "{name}, my family has led armies for generations. {buff}, for the heir.",
        "{name}, my armor was forged for a king. Bless it accordingly: {buff}.",
    },
    PALADIN = {
        "{name}, my order's sigil is older than your village. {buff}, if you please.",
        "{name}, I've knighted lesser folk than you. {buff}, and I'll remember your name.",
    },
    HUNTER = {
        "{name}, I hunt for sport, not supper. {buff}, so the sport stays elegant.",
        "{name}, my hound has a longer pedigree than you do. {buff}, for us both.",
    },
    ROGUE = {
        "{name}, I am no common thief. I'm an uncommon one. {buff}, please.",
        "{name}, the family business is discretion. {buff} would be discreetly appreciated.",
    },
    PRIEST = {
        "{name}, I've tended to royalty. You may tend to me: {buff}.",
        "{name}, my sermons are attended by nobility. {buff} would suit the pulpit.",
    },
    SHAMAN = {
        "{name}, the spirits answer to my bloodline. You may as well: {buff}.",
        "{name}, my ancestors were great shamans. Honor them: {buff}.",
    },
    MAGE = {
        "{name}, I studied at the finest academies. {buff} would complete my education.",
        "{name}, I conjure only the finest food. {buff}, and you may have a bite.",
    },
    WARLOCK = {
        "{name}, my demons are of the highest breeding. {buff}, to match.",
        "{name}, even the dark arts deserve refinement. {buff}, if you please.",
    },
    DRUID = {
        "{name}, my grove is the most exclusive in the land. {buff}, for its keeper.",
        "{name}, even my bear form has manners. {buff}, please.",
    },
},
charming = {
    WARRIOR = {
        "{name}, I'd fight a dragon for you. Give {me} {buff} first?",
        "{name}, my shield is strong, but my heart is soft. {buff}?",
    },
    PALADIN = {
        "{name}, I've seen the Light, and it's nothing next to your smile. {buff}?",
        "{name}, my oath forbids lying, so trust me: {buff} from you would be heavenly.",
    },
    HUNTER = {
        "{name}, my pet likes you. It's never wrong. {buff}?",
        "{name}, I've tracked many things, but never anyone like you. {buff}, darling?",
    },
    ROGUE = {
        "{name}, I came to steal your purse, but you stole my heart. {buff} instead?",
        "{name}, I'm sneaky, but I'll be honest: I'd love {buff} from you.",
    },
    PRIEST = {
        "{name}, I confess, I came over just for you. And {buff}.",
        "{name}, I heal hearts for a living. Mine's racing. {buff}?",
    },
    SHAMAN = {
        "{name}, the spirits say we're meant to be. They also say {buff}.",
        "{name}, there's lightning in the air. Or maybe it's you. {buff}?",
    },
    MAGE = {
        "{name}, I'd portal anywhere with you. Start with {buff}?",
        "{name}, my magic is powerful, but it can't make me look away from you. {buff}?",
    },
    WARLOCK = {
        "{name}, I've made pacts with demons, but I'd rather make one with you. {buff}?",
        "{name}, they say my soul is half gone. You can have the rest for {buff}.",
    },
    DRUID = {
        "{name}, I'd turn into a cat and curl up in your lap. After {buff}, of course.",
        "{name}, nature made you beautiful. Make me stronger: {buff}?",
    },
},
devout = {
    WARRIOR = {
        "{name}, I fight so others need not. Would you bless my sword arm with {buff}?",
        "{name}, my shield guards the faithful. Would you guard me with {buff}?",
    },
    PALADIN = {
        "{name}, the Light asks us to share its gifts. Would you share {buff}?",
        "{name}, I've sworn my oath. Would you seal it with {buff}?",
    },
    HUNTER = {
        "{name}, the wild teaches respect for every gift. Would you gift {me} {buff}?",
        "{name}, my companion and I give thanks for every blessing. {buff} most of all.",
    },
    ROGUE = {
        "{name}, even those in shadow seek a blessing. Would you give {me} {buff}?",
        "{name}, I walk a narrow path. {buff} would help me keep to it.",
    },
    PRIEST = {
        "{name}, I pray for others every day. Would you answer one prayer for me: {buff}?",
        "{name}, the faithful lift each other up. Would you lift me with {buff}?",
    },
    SHAMAN = {
        "{name}, the spirits bless those who honor them. Would you honor me with {buff}?",
        "{name}, I give thanks to earth and sky. Give {me} {buff}, and I'll give thanks for you too.",
    },
    MAGE = {
        "{name}, magic is a gift, and gifts should be shared. Would you share {buff}?",
        "{name}, I seek wisdom in all things. {buff} would bless the search.",
    },
    WARLOCK = {
        "{name}, I walk among shadows, but I still pray. Would you bless {me} with {buff}?",
        "{name}, a soul needs every blessing it can find. Mine more than most. {buff}?",
    },
    DRUID = {
        "{name}, nature is sacred, and so is kindness. Would you bless {me} with {buff}?",
        "{name}, I tend the groves and give thanks daily. Would you give {me} {buff}?",
    },
},
mercenary = {
    WARRIOR = {
        "{name}, I tank for coin. {buff} means fewer repair bills. You'd be helping the economy.",
        "{name}, my sword's for hire. {buff} raises my rate. I'll cut you in.",
    },
    PALADIN = {
        "{name}, I'll trade you a blessing for a blessing. Yours first: {buff}.",
        "{name}, I'm a paladin for hire. {buff}, and I'll throw in a free heal.",
    },
    HUNTER = {
        "{name}, I sell pelts by the dozen. {buff}, and I'll give you the family discount.",
        "{name}, my pet works for food. I work for {buff}.",
    },
    ROGUE = {
        "{name}, I'm a professional. Professionals invest in {buff}. Help me out?",
        "{name}, I'll trade you a lockbox for {buff}. Opened, of course.",
    },
    PRIEST = {
        "{name}, my heals aren't free, but for {buff}, I'll make an exception.",
        "{name}, I'll heal you for free next time. Today, {buff} for me.",
    },
    SHAMAN = {
        "{name}, one totem, one {buff}. Fair trade?",
        "{name}, the spirits work for nothing. I don't. {buff}, and we're square.",
    },
    MAGE = {
        "{name}, portals cost gold. {buff} costs you nothing. Give {me} one, and I'll knock a silver off.",
        "{name}, I'll throw in a stack of conjured water for {buff}. Best deal in town.",
    },
    WARLOCK = {
        "{name}, summons are on the house if you give {me} {buff}.",
        "{name}, one healthstone for one {buff}. You won't get a better deal.",
    },
    DRUID = {
        "{name}, herbs, leather, a battle rez in a pinch. All negotiable. {buff} first.",
        "{name}, I'll trade you an Innervate later for {buff} now.",
    },
},
}
