class_name nyan

static func bind(interpreter_settings: InterpreterSettings):
    interpreter_settings.bind_function("except", func(x = null): return TritiumData.InterpreterResult.new(null, nyanify_string(str(x) if x else "An unknown error has occurred")))
    interpreter_settings.bind_function("assert", func(expression: bool, message: String = "Assertion failed"):
        if not expression:
            push_error(message)
            return TritiumData.InterpreterResult.new(null, nyanify_string(message)))
    var _print = interpreter_settings.bound_functions.get("print")
    if _print:
        interpreter_settings.bind_function("print", func(x, y="\n"): return _print.call(nyanify_string(str(x)), y))

    var _printerr = interpreter_settings.bound_functions.get("printerr")
    if _printerr:
        interpreter_settings.bind_function("printerr", func(x, y="\n"): return _printerr.call(nyanify_string(x), y))


static func nyanify_string(text: String) -> String:
    var nyan_text = (
    text
    .replace("r", "nyar")
    .replace("l", "nya")
    .replace("R", "Nyar")
    .replace("L", "Nya")
    .replace("meow", "myao")
    .replace("purr", "nyurr")
    )

    var word_subs = {
        "you": ["nyu", "yunya", "nya-u"],
        "your": ["nyour", "yur-nya", "yownya"],
        "cute": ["nyute", "kawaiinya", "nyoot"],
        "hello": ["nyello~", "nyah-llo", "nyellow"],
        "friend": ["furiend", "nyafriend", "nyaffriend"],
        "love": ["nya-ove", "nyuv", "nyove"],
        "cat": ["nyan-cat", "nyacat", "nyapaws"],
        "awesome": ["nyawesome", "nyasome", "purrsome"],
        "happy": ["nyappy", "happinya", "mewrri"],
        "play": ["nylay", "purrlay", "nya-lay"],
        "please": ["purrlease", "nyapwease", "pleaws~"],
        "okay": ["nyokay", "okknyah", "nyay~"],
        "yes": ["nyes", "yeow", "nyes~"],
        "no": ["nyo", "naw~", "nuwu"],
        "good": ["nyood", "purrfect", "nyud"],
        "bad": ["nya-d", "baddy", "nyadd"],
        "enemy": ["nyenemy", "enyanemy", "purr-enemy"],
        "fight": ["nyight", "fite-nyah", "nyfight"],
        "run": ["nyun", "ruu-nyah", "nyow"],
        "win": ["nya-win", "win-nyah", "pawsome-win"],
        "magic": ["nyagic", "mawi-gic", "meowgic"],
        "ready": ["nya-ready", "weady", "nya-weady"],
        "attack": ["nyattack", "attnya", "paws-attack"],
        "defend": ["nyafend", "de-fenyan", "defurrnd"],
        "hero": ["nyero", "nya-hero", "purrro"],
        "treasure": ["nyasure", "treas-nya", "treawnya"],
        "health": ["nyalth", "heawth", "paw-th"]
    }

    for word in word_subs.keys():
        var subs = word_subs[word]
        nyan_text = nyan_text.replace(word, subs[nyan_text.length() % subs.size()])

    nyan_text = nyan_text.replace("oo", "nyoo").replace("ee", "nyee").replace("aa", "nyaa")

    nyan_text = nyan_text.replace("!", "!!! nya~").replace("?", "? nya?").replace(".", "~~").replace(",", ", nya~")

    var random_phrases = [
        " *pounces*~", " nya~ let's go!", " meowster in control~", " ready to nyom~", " *gear noises*", " purrtocols engaged~", " *mechanical miaow*", " *mecha paws twitch*",
        " nyan-nyan systems ready~", " *whiskers wiggle*", " all nya-le systems engaged~", " command acknowledged, nya~", " *scratches behind gears*", " initiating nyuzzle mode~", " nya-finity ready", " mecha standing by, nya~",
        " pawwer levels stable~", " awaiting nya-orders~", " *kitten ears perk up*", " protocols mewting point", " full nyaction ready", " *tail-twitch~*", " *initiating pawpatrol*", " *engine nya-purr*",
        " directive understood, nyan~", " *wiggles paw blades*", " nyoperation successful~", " *meowcles flexed*", " let's nyom onwards~", " ready for action nyao~", " *gear clinks purrfectly*", " nyom-nyom-activated",
        " scanning for miaows of opportunity~", " *nyan-dances*", " action set to kawaii mode~", " systemy-nyanic flawless~", " ready nyaw~", " time to pawwer up, nya~", " mecha fully pwowertional", " commands ready, nyaster",
        " *paw-clicky*", " operational levels nyoming~", " **nya-turbine engaged**", " *system hugs at optimum*,", " kawaii directive commencing~", " happiness overload, nya~", " *paw wiggle sparkles*", " *engaging purr-alignment~"
    ]

    nyan_text += random_phrases[nyan_text.length() % random_phrases.size()]

    return "[rainbow][wave amp=20.0 freq=5.0 connected=1]" + nyan_text + "[/wave][/rainbow]"
