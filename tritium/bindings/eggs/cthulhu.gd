class_name cthulhubots

const cthulhucrew = [
    "MissCthuleanCoder",
    "Cthulhu"
]

static func bind(interpreter_settings: InterpreterSettings):
    interpreter_settings.bind_function("except", func(x = null  ): return TritiumData.InterpreterResult.new(null, cthulhufy_string(str(x) if x else "A mysterious error has occured")))
    interpreter_settings.bind_function("assert", func(expression: bool, message: String = "Assertion failed"):
        if not expression:
            push_error(message)
            return TritiumData.InterpreterResult.new(null, cthulhufy_string(message)))
    var _print = interpreter_settings.bound_functions.get("print")
    if _print:
        interpreter_settings.bind_function("print", func(x, y="\n"): return _print.call(cthulhufy_string(x), y))


static func cthulhufy_string(text: String) -> String:
    var cthulhu_text = (
    text
    .replace("r", "gh")
    .replace("l", "lh")
    .replace("R", "Gh")
    .replace("L", "Lh")
    .replace("th", "th'ul")
    .replace("Th", "Th'ul")
    )

    var word_subs = {
        "you": "ye",
        "You": "Ye",
        "your": "thy",
        "Your": "Thy",
        "you're": "thou art",
        "love": "adore",
        "Love": "Adore",
        "very": "most",
        "isn't": "shant",
        "no": "nay",
        "Oh": "Behold",
        "oh": "lo",
        "this": "this eldritch",
        "that": "that ancient",
        "thank": "offer obeisance",
        "mine": "mine own",
        "for": "for the glory of",
        "friend": "acolyte",
        "sorry": "pity",
        "me": "myself",
        "my": "mine",
        "stop": "halt",
        "cute": "unspeakable",
        "happy": "pleased",
        "excited": "foreboding",
        "good": "satisfactory",
        "bad": "malevolent",
        "hello": "greetings",
        "hi": "hail",
        "why": "wherefore",
        "please": "if thou must",
        "yes": "indeed",
        "okay": "agreed",
        "help": "aid",
        "wow": "behold",
        "really": "truly",
        "right": "correct",
        "attack": "unleash fury",
        "enemy": "adversary",
        "health": "vital essence",
        "damage": "infliction",
        "mana": "eldritch power",
        "magic": "arcane arts",
        "shield": "aegis",
        "level": "plane",
        "boss": "primordial entity",
        "quest": "calling",
        "player": "seeker",
        "game": "ritual",
        "skill": "art",
        "bonus": "boon",
        "mission": "decree",
        "victory": "ascendance",
        "defeat": "doom",
        "points": "marks",
        "score": "tally",
        "fight": "struggle",
        "battle": "conflict",
        "defend": "ward",
        "run": "flee",
        "win": "prevail",
        "lose": "fall",
        "hero": "champion",
        "villain": "blight",
        "danger": "ominous tides",
        "treasure": "relic",
        "reward": "blessing",
    }

    for word in word_subs.keys():
        cthulhu_text = cthulhu_text.replace(word, word_subs[word])

    cthulhu_text = cthulhu_text.replace("oo", "ogh").replace("ee", "e'ey").replace("aa", "a'a")

    cthulhu_text = cthulhu_text.replace("!", "!! Ia! Ia!").replace("?", "? The cosmos wonders...").replace(".", "... ").replace(",", ", yet...")

    var random_phrases = [
        " By the Old Ones' will...", " Shadows deepen, watcher...", " Ph'nglui mglw'nafh...", " Arcane energies rise...", " The stars whisper...", " Yog-Sothoth watches~", " *indescribable shiver*", " Hastur hungers...",
        " *eldritch chant*", " madness calls~", " Ia, Cthulhu fhtagn~", " *tentacles quiver*", " *unholy purr~*", " The Great Dreamer stirs", " fear the end of days~", " Mind-writhing whispers...",
        " *dark symphony*", " *ethereal hum*", " eldritch reckoning~", " the abyss is near~", " heed the call of R'lyeh", " *unnatural cackle*", " *veil trembles*", " *reality blurs*",
        " *tentacles twitch*", " The Nameless are restless~", " *insane laughter*", " chaos writhes", " behold the ineffable!", " speak no more of light...", " wail as reality cracks~", " *twisted chants~*",
        " *shivers of oblivion*", " *sigil burns*", " the elder powers loom~", " *foreboding hum*", " await the impossible~", " unknown truths beckon", " despair approaches...", " *chant deepens*",
        " The unspeakable approaches~", " *time warps*", " Dagon's abyss swells", " *cyclopean gaze~*", " warp and rend reality~", " *unholy chanting*", " *cosmic echoes*",
        " Stars blink in madness~", " The void is patient...", " darkness encloses~", " tremble in eternity~", " gaze upon the unseen", " *shiver of knowing*", " Knowledge leads to madness",
        " heed no mortal bounds~", " *depths awaken*", " *utterances lost*"
    ]

    cthulhu_text += random_phrases[cthulhu_text.length() % random_phrases.size()]

    var cthulhu_subs = {
        "func": "ritual",
        "function": "incantation",
        "signal": "whisper",
        "extends": "delves into",
        "yield": "relinquish",
        "self": "one's essence",
        "ready": "awakened",
        "true": "affixed",
        "false": "dissolved",
        "null": "void",
        "tool": "instrument",
        "print": "reveal",
        "export": "offer",
        "process": "transmutation",
        "instance": "apparition",
        "setget": "invoke",
        "preload": "invoke shadows",
        "Vector2": "CosmicVector2",
        "Node2D": "EldritchNode2D",
        "queue_free": "send into oblivion",
        "enum": "symbol",
        "input": "essence draw",
        "texture": "veil",
        "sprite": "spectre",
        "animation": "unfolding",
        "resource": "reagent",
        "shader": "eldritch-glow",
        "camera": "watcher-eye",
        "collision": "impact",
        "body": "husk",
        "area": "haunted bounds",
        "rigidbody": "abyssal-husk",
        "kinematic": "spectral",
        "group": "coven",
        "node": "essence",
        "scene": "spectacle",
        "script": "inscription",
        "input_map": "draw_map",
        "viewport": "veil-portal",
        "animation_player": "eldritch_unfolding",
        "control": "domination",
        "panel": "tablet",
        "label": "sigil",
        "button": "trigger",
        "timer": "count of Aeons",
        "collision_shape": "impact shape",
        "navigation": "void-walk",
        "audio_stream": "eldritch-echo",
        "polygon": "maddening geometry",
        "resource_loader": "reagent_handler",
        "material": "incarnate",
        "texture_rect": "veil-bound",
        "animation_tree": "unfolding-grove",
        "parallax": "parallel madness",
        "grid": "otherworldly maze",
        "margin": "limit of void",
        "visibility": "gaze"
    }

    for term in cthulhu_subs.keys():
        cthulhu_text = cthulhu_text.replace(term, cthulhu_subs[term])

    var custom_emojis = [
        " (⌬̀⚆ɷ⚆)", " (⌬ಠل͜ಠ⌬)", " (˘⌬˘)", " (｡⨶⌬⨶｡)", " (⨶⨀⨶)", " (¬⌬¬)", " (⌬°益°)⌬", " (╰⌬╯)",
        " (⌬≖_≖)", " (⌬ʘωʘ⌬)", " (•⌬•)", " (⌬≖ᴗ≖)", " (⌬￣皿￣)", " (⌬´з`⌬)", " (⌬☠_☠)", " (⌬◣∀◢⌬)⊃",
        " (⌬✧∀✧⌬)｣", " (⌬≖ω≖*)", " (⌬¬▿¬)", " (⌬≧ｍ≦)", " (⌬◕◞◕⌬)", " (⌬∇⌬)", " (⌬⍩◔ᴗ◔)", " (⌬≧ヮ≦)"
    ]

    cthulhu_text += custom_emojis[cthulhu_text.length() % custom_emojis.size()]

    return cthulhu_text
