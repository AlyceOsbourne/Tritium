class_name cthulhubots

const cthulhucrew = [
    "MissCthuleanCoder",
    "Cthulhu",
    "lagmaister",
    "Dovos",
    "Helbeglin"
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
    var _printerr = interpreter_settings.bound_functions.get("printerr")
    if _print:
        interpreter_settings.bind_function("printerr", func(x, y="\n"): return _printerr.call(cthulhufy_string(x), y))

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
        "you": ["ye", "thou", "thyself"],
        "You": ["Ye", "Thou", "Thyself"],
        "your": ["thy", "thine"],
        "Your": ["Thy", "Thine"],
        "you're": ["thou art", "ye be"],
        "love": ["adore", "worship", "revere"],
        "Love": ["Adore", "Worship", "Revere"],
        "very": ["most", "exceedingly"],
        "isn't": ["shant", "shall not be"],
        "no": ["nay", "nevermore"],
        "Oh": ["Behold", "Lo"],
        "oh": ["lo", "hark"],
        "this": ["this eldritch", "this accursed"],
        "that": ["that ancient", "that cursed"],
        "thank": ["offer obeisance", "give tribute"],
        "mine": ["mine own", "my eldritch"],
        "for": ["for the glory of", "in honor of"],
        "friend": ["acolyte", "fellow cultist"],
        "sorry": ["pity", "regret"],
        "me": ["myself", "mine essence"],
        "my": ["mine", "my eldritch"],
        "stop": ["halt", "cease"],
        "cute": ["unspeakable", "abominable"],
        "happy": ["pleased", "content in madness"],
        "excited": ["foreboding", "filled with dread"],
        "good": ["satisfactory", "acceptable"],
        "bad": ["malevolent", "accursed"],
        "hello": ["greetings", "hail"],
        "hi": ["hail", "greetings"],
        "why": ["wherefore", "for what purpose"],
        "please": ["if thou must", "should it please thee"],
        "yes": ["indeed", "verily"],
        "okay": ["agreed", "so be it"],
        "help": ["aid", "assist in ritual"],
        "wow": ["behold", "marvel"],
        "really": ["truly", "verily"],
        "right": ["correct", "true"],
        "attack": ["unleash fury", "strike with wrath"],
        "enemy": ["adversary", "foe"],
        "health": ["vital essence", "life force"],
        "damage": ["infliction", "harm"],
        "mana": ["eldritch power", "arcane energy"],
        "magic": ["arcane arts", "eldritch sorcery"],
        "shield": ["aegis", "ward"],
        "level": ["plane", "tier"],
        "boss": ["primordial entity", "ancient overlord"],
        "quest": ["calling", "holy mission"],
        "player": ["seeker", "participant in ritual"],
        "game": ["ritual", "arcane trial"],
        "skill": ["art", "eldritch talent"],
        "bonus": ["boon", "eldritch blessing"],
        "mission": ["decree", "divine task"],
        "victory": ["ascendance", "glory"],
        "defeat": ["doom", "ruin"],
        "points": ["marks", "sigils"],
        "score": ["tally", "reckoning"],
        "fight": ["struggle", "engage in battle"],
        "battle": ["conflict", "warfare"],
        "defend": ["ward", "protect"],
        "run": ["flee", "escape"],
        "win": ["prevail", "triumph"],
        "lose": ["fall", "be undone"],
        "hero": ["champion", "savior"],
        "villain": ["blight", "bane"],
        "danger": ["ominous tides", "threatening omens"],
        "treasure": ["relic", "eldritch artifact"],
        "reward": ["blessing", "boon from beyond"]
    }

    for word in word_subs.keys():
        var subs = word_subs[word]
        cthulhu_text = cthulhu_text.replace(word, subs[cthulhu_text.length() % subs.size()])

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
        "func": ["ritual", "arcane invocation"],
        "function": ["incantation", "eldritch operation"],
        "signal": ["whisper", "eldritch sign"],
        "extends": ["delves into", "embraces"],
        "yield": ["relinquish", "offer unto the void"],
        "self": ["one's essence", "the vessel"],
        "ready": ["awakened", "prepared for ritual"],
        "true": ["affixed", "bound"],
        "false": ["dissolved", "banished"],
        "null": ["void", "emptiness"],
        "tool": ["instrument", "implement of fate"],
        "print": ["reveal", "utter forth"],
        "export": ["offer", "present unto the void"],
        "process": ["transmutation", "eldritch flow"],
        "instance": ["apparition", "manifestation"],
        "setget": ["invoke", "call upon"],
        "preload": ["invoke shadows", "summon from beyond"],
        "Vector2": ["CosmicVector2", "OtherworldlyVector2"],
        "Node2D": ["EldritchNode2D", "AccursedNode2D"],
        "queue_free": ["send into oblivion", "banish to the void"],
        "enum": ["symbol", "sigil"],
        "input": ["essence draw", "ritual interaction"],
        "texture": ["veil", "shroud"],
        "sprite": ["spectre", "apparition"],
        "animation": ["unfolding", "eldritch motion"],
        "resource": ["reagent", "component"],
        "shader": ["eldritch-glow", "arcane shimmer"],
        "camera": ["watcher-eye", "gazer"],
        "collision": ["impact", "convergence"],
        "body": ["husk", "vessel"],
        "area": ["haunted bounds", "cursed territory"],
        "rigidbody": ["abyssal-husk", "eldritch-shell"],
        "kinematic": ["spectral", "phantasmal"],
        "group": ["coven", "gathering"],
        "node": ["essence", "arcane point"],
        "scene": ["spectacle", "eldritch vision"],
        "script": ["inscription", "arcane scroll"],
        "input_map": ["draw_map", "interaction glyph"],
        "viewport": ["veil-portal", "eldritch window"],
        "animation_player": ["eldritch_unfolding", "arcane conductor"],
        "control": ["domination", "eldritch command"],
        "panel": ["tablet", "eldritch plate"],
        "label": ["sigil", "rune"],
        "button": ["trigger", "arcane switch"],
        "timer": ["count of Aeons", "temporal sigil"],
        "collision_shape": ["impact shape", "convergence form"],
        "navigation": ["void-walk", "abyssal traverse"],
        "audio_stream": ["eldritch-echo", "arcane resonance"],
        "polygon": ["maddening geometry", "non-Euclidean form"],
        "resource_loader": ["reagent_handler", "eldritch_fetcher"],
        "material": ["incarnate", "substance of the void"],
        "texture_rect": ["veil-bound", "shroud-frame"],
        "animation_tree": ["unfolding-grove", "arcane arbor"],
        "parallax": ["parallel madness", "layered depths"],
        "grid": ["otherworldly maze", "eldritch lattice"],
        "margin": ["limit of void", "edge of the abyss"],
        "visibility": ["gaze", "eldritch perception"]
    }

    for term in cthulhu_subs.keys():
        var subs = cthulhu_subs[term]
        cthulhu_text = cthulhu_text.replace(term, subs[cthulhu_text.length() % subs.size()])

    var custom_emojis = [
        " (⌬̀⚆ɷ⚆)", " (⌬ಠل͜ಠ⌬)", " (˘⌬˘)", " (｡⨶⌬⨶｡)", " (⨶⨀⨶)", " (¬⌬¬)", " (⌬°益°)⌬", " (╰⌬╯)",
        " (⌬≖_≖)", " (⌬ʘωʘ⌬)", " (•⌬•)", " (⌬≖ᴗ≖)", " (⌬￣皿￣)", " (⌬´з`⌬)", " (⌬☠_☠)", " (⌬◣∀◢⌬)⊃",
        " (⌬✧∀✧⌬)｣", " (⌬≖ω≖*)", " (⌬¬▿¬)", " (⌬≧ｍ≦)", " (⌬◕◞◕⌬)", " (⌬∇⌬)", " (⌬⍩◔ᴗ◔)", " (⌬≧ヮ≦)"
    ]

    cthulhu_text += custom_emojis[cthulhu_text.length() % custom_emojis.size()]

    return "[font=res://tritium/editor/Dignity of Labour.otf]%s[/font]" % cthulhu_text
