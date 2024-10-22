class_name uwu

static func bind(interpreter_settings: InterpreterSettings):
    interpreter_settings.bind_function("except", func(x = null  ): return TritiumData.InterpreterResult.new(null, uwufy_string(str(x) if x else "An unknown error has occured")))
    interpreter_settings.bind_function("assert", func(expression: bool, message: String = "Assertion failed"):
        if not expression:
            push_error(message)
            return TritiumData.InterpreterResult.new(null, uwufy_string(message)))
    var _print = interpreter_settings.bound_functions.get("print")
    if _print:
        interpreter_settings.bind_function("print", func(x, y="\n"): return _print.call(uwufy_string(str(x)), y))

    var _printerr = interpreter_settings.bound_functions.get("printerr")
    if _print:
        interpreter_settings.bind_function("printerr", func(x, y="\n"): return _printerr.call(uwufy_string(x), y))


static func uwufy_string(text: String) -> String:
    var uwu_text = (
    text
    .replace("r", "w")
    .replace("l", "w")
    .replace("R", "W")
    .replace("L", "W")
    .replace("th", "d")
    .replace("Th", "D")
    )

    var word_subs = {
        "you": ["yuwu", "yuu", "yuw"],
        "You": ["UwU", "Yuwu", "Yuu"],
        "your": ["ur", "yuwr", "yur"],
        "Your": ["Ur", "Yuwr", "Yur"],
        "you're": ["ur", "yuw're", "yur're"],
        "love": ["wuv", "wove", "wub"],
        "Love": ["Wuv", "Wove", "Wub"],
        "very": ["vewy", "vawy", "vewi"],
        "isn't": ["isn't it? UwU", "isn't it? OwO", "isn't it? ^w^"],
        "no": ["nuu", "naw", "nwu"],
        "Oh": ["Owo", "OwO", "Owu"],
        "oh": ["owo", "owu", "o~"],
        "this": ["dis", "diss", "dis~"],
        "that": ["dat", "datt", "dat~"],
        "thank": ["fank", "fwank", "fawnk"],
        "mine": ["moin", "moine", "mwin"],
        "for": ["fuwa", "fow", "fo~"],
        "friend": ["fwiend", "fwend", "fwiendy"],
        "sorry": ["sowwy", "sworry", "sowwi"],
        "me": ["mwe", "mwee", "mwew"],
        "my": ["mai", "maii", "mwy"],
        "stop": ["stwop", "stoppu", "stwop~"],
        "cute": ["kawaii~", "kyute", "kawwaii"],
        "happy": ["happi~", "happii", "happiw"],
        "sad": ["s-sad~", "saddo", "saddy"],
        "excited": ["excitwed~", "excitewd", "excitedo"],
        "good": ["gwood", "gwoody", "gwud"],
        "bad": ["bwad", "bwaddy", "bawwd"],
        "hello": ["hewwo~", "hewwo", "hewwoe"],
        "hi": ["hai~", "hii", "haii"],
        "why": ["whai~", "whei", "whyy"],
        "please": ["pwease~", "pwii", "pwe~"],
        "yes": ["yus", "yees", "yess~"],
        "okay": ["okie~", "okkie", "okayw"],
        "help": ["hewlp~", "hewpp", "hewpie"],
        "wow": ["w-woah~", "wooah", "woahh~"],
        "really": ["weawwy~", "reawwy", "weally~"],
        "right": ["wight~", "wright", "wite~"],
        "attack": ["attwack~", "attacku", "attwak"],
        "enemy": ["enemwyyy", "enemwi", "enwemy"],
        "health": ["heawth~", "heawthy", "heawf~"],
        "damage": ["damwage~", "dammage", "damwag~"],
        "mana": ["manya~", "manwa", "manw~"],
        "magic": ["mawigic~", "magik", "mawi~"],
        "shield": ["shiewld~", "shieldy", "shieww"],
        "level": ["wevel~", "wewwel", "wevwi"],
        "boss": ["bwoss~", "bossy", "bosw"],
        "quest": ["kwest~", "questy", "kwesty~"],
        "player": ["pwayew~", "playewr", "pwaywer"],
        "game": ["gawme~", "gaame", "gamew"],
        "skill": ["skiww~", "skillie", "skilw"],
        "bonus": ["bownus~", "bonwus", "boonus"],
        "stage": ["stawge~", "staggie", "stawge"],
        "mission": ["mishyawn~", "missiony", "mishon"],
        "victory": ["victowy~", "victori", "victwy"],
        "defeat": ["defweat~", "defeatw", "defwet"],
        "points": ["pwoints~", "poinwts", "pwint"],
        "score": ["scwore~", "scwor", "scoore"],
        "fight": ["fwight~", "fightie", "fighw"],
        "battle": ["bawttle~", "battwie", "bawtt~"],
        "defend": ["defwend~", "defendie", "defewnd"],
        "run": ["wun~", "runnie", "wunn"],
        "win": ["w-win~", "winn", "winn~"],
        "lose": ["woose~", "loosie", "woos~"],
        "hero": ["hewwo~", "herwo", "hewro"],
        "villain": ["viwwain~", "villwany", "villaiw"],
        "danger": ["dangew~", "dangie", "dawnger"],
        "treasure": ["twesuwe~", "tweaswi", "tweasur~"],
        "reward": ["weward~", "rewarwd", "wew~"]
    }

    for word in word_subs.keys():
        var subs = word_subs[word]
        uwu_text = uwu_text.replace(word, subs[uwu_text.length() % subs.size()])

    uwu_text = uwu_text.replace("oo", "o~").replace("ee", "e~").replace("aa", "a~")

    uwu_text = uwu_text.replace("!", "!!! OwO").replace("?", "? owo").replace(".", "~~~").replace(",", ", uwu~")

    var random_phrases = [
        " mechie activated~", " UwU command received~", " >w< ready to obey~", " ^w^ all systems go~", " *gear noises*", " protocols engaged~", " *beeps happily*", " *mech pounces*",
        " *wheels spinny*", " system standing by~", " *mechanical whirr*", " mechie reporting~", " *gear shift*", " control engaged~", " directives acknowledged~", " ready for nuzzles~",
        " *servo whine*", " *exhaust puff*", " mechie is happi~", " directive received~", " waiting for orderz~", " *antenna twitch*", " *radar spin~*", " *wiggly chassis*",
        " *signal flares*", " *mecha blush*", " full powewr mode~", " *click clack*", " systems nominal~", " mechy wuvs tasks~", " *ignition sparkles~*", " *turbo charge~*",
        " *initiating cuddle protocols*", " *wub-wub engaged~*", " mechy standyby~", " *servo smile*", " *happily beeping*", " mechie twying best~", " all powewr to cuteness~", " *twitty circuits*",
        " *sparkwe sparkle~*", " awaiting uwu commands~", " *engine whirrs cuwtely*", " system diagnostics compwete~", " pwease give me owders~", " *antenna waggle*", " *mwecha dancing*", " *pewfectly oiled~*",
        " *boosters ignited~*", " weady fow action~", " *metal clinkies*", " powew levew optimum~", " *wobot heawt activated~*", " pwepawe fow operational cuddwes~", " *tactical wuv mode*", " systems awigned UwU~",
        " *executing pwayfullness*", " wooking fow diwection~", " *hug defense stwategy~*", " kawaii powew max~", " *giddy mode~*", " owders awways pwioritized~", " *wheels wiggwe~*", " *mechanical purrs*",
        " *sparkwing mechie energy~*", " *wuv-fiwwed responses*", " initiating happi pwotocol~", " *bouncy bouncy~*", " owders compwete, nyext task~", " *whirrr-clicky~*", " *optimizing for cute*", " *wagging metal taiw~*",
        " standby fow hug attack~", " *excess wub detected*", " no pwobwems found~", " *tiny giggles*", " *fuzzy circuits~*", " scwanning fow affection UwU~", " aww systems fwowwing~", " *wiggling on spot~*"
    ]

    uwu_text += random_phrases[uwu_text.length() % random_phrases.size()]

    var godot_subs = {
        "func": "fwunc",
        "function": "fwunction",
        "signal": "signyawl",
        "extends": "extwendz",
        "yield": "yiewld",
        "self": "sewlf",
        "ready": "weady",
        "true": "twue",
        "false": "fawse",
        "null": "nuww",
        "tool": "toowl",
        "print": "pwint",
        "export": "expowt",
        "process": "pwocess",
        "instance": "instwance",
        "setget": "setyget",
        "preload": "pweload",
        "Vector2": "Vectow2~",
        "Node2D": "Nodwe2D",
        "queue_free": "queue_fwree",
        "enum": "enwum",
        "input": "inpwut",
        "texture": "textwure",
        "sprite": "spwite",
        "animation": "animyawtion",
        "resource": "wesouwce",
        "shader": "shawder",
        "camera": "camewra",
        "collision": "cwowwision",
        "body": "bwody",
        "area": "awea",
        "rigidbody": "wigidbwody",
        "kinematic": "kinyematic",
        "group": "gwoup",
        "node": "nyode",
        "scene": "scwene",
        "script": "scwipt",
        "input_map": "inpwut_mwap",
        "viewport": "viewpowt",
        "animation_player": "animyawtion_pwayew",
        "control": "contwow",
        "panel": "panyew",
        "label": "wabew",
        "button": "buttwon",
        "timer": "timew~",
        "collision_shape": "cwowwision_shapew~",
        "navigation": "navyawtion",
        "audio_stream": "awdyo_stweam~",
        "polygon": "powygon~",
        "resource_loader": "wesouwce_wowdew~",
        "material": "matewiaw~",
        "texture_rect": "textwure_werct~",
        "animation_tree": "animyawtion_twee~",
        "parallax": "pawawwax~",
        "grid": "gwrid~",
        "margin": "mawgin~",
        "visibility": "visibiwity~"
    }

    for term in godot_subs.keys():
        uwu_text = uwu_text.replace(term, godot_subs[term])

    var custom_emojis = [
        " (✿◆◆)", " (ಠ_ಠ)", " (〒◆〒)", " (｡◆｡)", " (〒△〒)", " (ಠ_▲)", " (ಠ◆◆)", " (*웃応웃)",
        " (｡♥‿♥｡)", " (✪ω✪)", " (｡•̀ᴗ-)✧", " (⁄ ⁄•⁄ω⁄•⁄ ⁄)", " (✿╹◡╹)", " (◕‿◕✿)", " (❀◕‿◕)", " (｡♥‿♥｡)",
        " (⺣◡⺣)♡*", " (♡°▽°♡)", " (≧◡≦)", " (｡♥‿♥｡)", " (✿♥‿♥✿)", " (´･ω･)", " (｡♥‿♥｡)",
        " (ꈍᴗꈍ)", " (｡･ω･｡)ﾉ♡", " (*≧ω≦)", " (｡♥‿♥｡)", " (⌒‿⌒) ", " (⁎⁍ᴗ⁍⁎)✧", " (｡•́︿•̀｡)",
        " (≧ω≦)", " (♥ω♥*)", " (☆▽☆)", " (⌒▽⌒)☆", " (｡♥‿♥｡)", " (⌒‿⌒｡)", " (⌒ω⌒)", " (≧◡≦✿)"
    ]

    uwu_text += custom_emojis[uwu_text.length() % custom_emojis.size()]

    return uwu_text

const uwucrew = [
        "Bity",
        "Bitlytic",
        "Jwduth",
        "Hano",
        "kollyr",
        "Qwertayguy",
        "Lukysa",
        "Lost stars",
        "Cosmic Sandwich",
        "Demiqas",
        "Newey",
        "SlugCat",
        "Lucretios"
    ]
