class_name godoblins

static func bind(interpreter_settings: InterpreterSettings):
    interpreter_settings.bind_function("except", func(x = null  ): return TritiumData.InterpreterResult.new(null, goblinify_string(str(x) if x else "An unknown error has occured")))
    interpreter_settings.bind_function("assert", func(expression: bool, message: String = "Assertion failed"):
        if not expression:
            push_error(message)
            return TritiumData.InterpreterResult.new(null, goblinify_string(message)))
    var _print = interpreter_settings.bound_functions.get("print")
    if _print:
        interpreter_settings.bind_function("print", func(x, y="\n"): return _print.call(goblinify_string(str(x)), y))

    var _printerr = interpreter_settings.bound_functions.get("printerr")
    if _printerr:
        interpreter_settings.bind_function("printerr", func(x, y="\n"): return _printerr.call(goblinify_string(str(x)), y))



static func goblinify_string(text: String) -> String:
    var goblin_text = (
    text
    .replace("r", "gr")
    .replace("l", "gl")
    .replace("R", "Gr")
    .replace("L", "Gl")
    .replace("th", "t'k")
    .replace("Th", "T'k")
    )

    var word_subs = {
        "you": "ye",
        "You": "Ye",
        "your": "yer",
        "Your": "Yer",
        "you're": "yer",
        "love": "loot",
        "Love": "Loot",
        "very": "heapin'",
        "isn't": "ain't",
        "no": "nah",
        "Oh": "Oi",
        "oh": "oi",
        "this": "dis",
        "that": "dat",
        "thank": "fanks",
        "mine": "me",
        "for": "fer",
        "friend": "crony",
        "sorry": "bah",
        "me": "meself",
        "my": "me",
        "stop": "stahp",
        "cute": "shinies",
        "happy": "jolly",
        "excited": "frothin'",
        "good": "gud",
        "bad": "rotten",
        "hello": "oi oi",
        "hi": "oi",
        "why": "wot fer",
        "please": "beg ya",
        "yes": "aye",
        "okay": "righto",
        "help": "gimme a hand",
        "wow": "blimey",
        "really": "reel gud",
        "right": "proper",
        "attack": "smash",
        "enemy": "git",
        "health": "fixins",
        "damage": "bust",
        "mana": "magicky juice",
        "magic": "tricksies",
        "shield": "clanker",
        "level": "ladder",
        "boss": "big'un",
        "quest": "job",
        "player": "runt",
        "game": "scrap",
        "skill": "knack",
        "bonus": "extra loot",
        "mission": "raid",
        "victory": "booty",
        "defeat": "squashed",
        "points": "shinies",
        "score": "stash",
        "fight": "scuffle",
        "battle": "brawl",
        "defend": "guard",
        "run": "leg it",
        "win": "nab",
        "lose": "get bopped",
        "hero": "chump",
        "villain": "big bad",
        "danger": "scraps ahead",
        "treasure": "loot",
        "reward": "spoils",
    }

    for word in word_subs.keys():
        goblin_text = goblin_text.replace(word, word_subs[word])

    goblin_text = goblin_text.replace("oo", "uu").replace("ee", "e'eh").replace("aa", "a'ah")

    goblin_text = goblin_text.replace("!", "!! Gahaha").replace("?", "? Oy?").replace(".", "... hrmph").replace(",", ", ya see?")

    var random_phrases = [
        " whatcha want, boss?", " Gobbo on standby~", " Scrappin' n' clankin'~", " Gettin' gud vibes!", " *gremlin cacklin'*", " crankin' gears~", " *fiddles wit' bolts*", " ready fer scrap!",
        " *oil splatter*", " where's da fun at?", " gobbo here~", " *tinker tinker*", " engine’s purrin'~", " *crank spinny~*", " directives? Nah, fun tings!", " waitin' ta plunder~",
        " *bolts clankin'*", " *spanner twist*", " gobbo loves shiny jobs~", " ready fer scrap~", " need me, call yer gobbo!", " *antenna buzzin'*", " *goblin hummin'*", " *gear gnaw*",
        " *chortle snortle*", " gobbo primed!", " *grease gobble~*", " We’s gonna wreck it!", " *engine grumbles*", " shinies spotted~", " *brakes squeak*", " gimme sumthin' ta do~",
        " *tools rattlin'*", " gears on da move~", " *metallic chuckle*", " diagnostics done—meh!", " whatcha waitin' fer?", " *gear chew~*", " mecha’s dancin'~", " all oiled up!",
        " *boosters prepped~*", " let’s go, ya knobhead~", " *clang clang*", " gobbo’s on watch~", " powah's maxed~", " ready ta do goblin tings~", " *metallic rasp*", " *wiggle wrench~*",
        " standby fer a smash~", " *gears rattle~*", " gobbo dun see nothin' wrong!", " *cackle fit*", " *wiggly bits~*", " scannin’ fer trouble~", " ready ta rumble~", " *mech fidget*"
    ]

    goblin_text += random_phrases[goblin_text.length() % random_phrases.size()]

    var goblin_subs = {
        "func": "fwunk",
        "function": "fwunktion",
        "signal": "buzzin",
        "extends": "stretches",
        "yield": "giveway",
        "self": "meself",
        "ready": "revved",
        "true": "yup",
        "false": "nope",
        "null": "zilch",
        "tool": "widget",
        "print": "squawk",
        "export": "fling",
        "process": "scrap",
        "instance": "gadget",
        "setget": "setygrab",
        "preload": "preshovel",
        "Vector2": "Vect-grunt2",
        "Node2D": "Nodwob2D",
        "queue_free": "queue_fer_free",
        "enum": "enumb",
        "input": "inpoke",
        "texture": "t'xture",
        "sprite": "sp'rite",
        "animation": "an'mation",
        "resource": "scrounge",
        "shader": "shadie",
        "camera": "spy-eye",
        "collision": "crash",
        "body": "hull",
        "area": "territ'ry",
        "rigidbody": "rigid-hull",
        "kinematic": "k'namit'k",
        "group": "gang",
        "node": "chunk",
        "scene": "shindig",
        "script": "scribblin'",
        "input_map": "inpoke_map",
        "viewport": "v'port",
        "animation_player": "an'mation_playa",
        "control": "dominate",
        "panel": "panew",
        "label": "tag",
        "button": "buttn",
        "timer": "tickin",
        "collision_shape": "crashie_form",
        "navigation": "nav'y",
        "audio_stream": "sound_rip",
        "polygon": "poly-junk",
        "resource_loader": "loot_wrangler",
        "material": "mat'rial",
        "texture_rect": "t'xture_box",
        "animation_tree": "an'mation_bush",
        "parallax": "pa'lax",
        "grid": "gruddle",
        "margin": "gobbo_space",
        "visibility": "see'able"
    }

    for term in goblin_subs.keys():
        goblin_text = goblin_text.replace(term, goblin_subs[term])

    var custom_emojis = [
        " (￣皿￣)", " (⊙ꇴ⊙)", " (≖_≖)", " (☠_☠)", " (•̀ᴗ•́)و", " (¬‿¬)", " (*≧ω≦)", " (ಠ_ಠ)",
        " (*´з`)", " (｀∀´)Ψ", " (*≧▽≦)", " (◣∀◢)⊃", " (✧∀✧)｣", " (*¬*)", " (¬ω¬)", " (*≖ω≖*)",
        " (>^w^<)", " (¬‿¬)", " (>‿◠)", " (¬◡¬)b", " (¬▿¬)", " (*≧ｍ≦)", " (｡◝‿◜｡)", " (≧ヮ≦)",
        " (⍩◔ᴗ◔)", " (⋋_⋌)", " (>_<*)", " (◕◞◕)", " (˵•‿•˵)", " (*≧▽≦)", " (>ω<)", " (>∇<)"
    ]

    goblin_text += custom_emojis[goblin_text.length() % custom_emojis.size()]

    return goblin_text

const godoblins = [
    "Tr1bute",
    "LastElf",
    "Melonyyy!",
    "Ako",
    "Bitlytic",
]
