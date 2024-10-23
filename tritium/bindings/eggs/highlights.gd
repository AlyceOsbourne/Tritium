class_name highlights

static func bind(interpreter_settings: InterpreterSettings):
    interpreter_settings.bind_function("except", func(x = null  ): return TritiumData.InterpreterResult.new(null, highlight_string(str(x) if x else "An unknown error has occured")))
    interpreter_settings.bind_function("assert", func(expression: bool, message: String = "Assertion failed"):
        if not expression:
            push_error(message)
            return TritiumData.InterpreterResult.new(null, highlight_string(message)))
    var _print = interpreter_settings.bound_functions.get("print")
    if _print:
        interpreter_settings.bind_function("print", func(x, y="\n"): return _print.call(highlight_string(str(x)), y))




static func highlight_string(text: String) -> String:
    var word_colors = [
        {"words": ["error", "failed", "error occurred", "critical", "failure", "danger", "fatal", "abort", "halt", "bug", "crash", "issue", "panic"], "color": "[color=red]"},
        {"words": ["warning", "ready", "caution", "alert", "pending", "waiting", "unstable", "deprecated", "attention", "notice", "flagged", "risk", "monitor"], "color": "[color=yellow]"},
        {"words": ["success", "passed", "successful", "complete", "okay", "done", "resolved", "healthy", "valid", "ready", "operational", "stable", "safe", "nominal"], "color": "[color=green]"},
        {"words": ["info", "print", "information", "details", "data", "log", "record", "note", "debug", "trace", "output", "verbose", "insight"], "color": "[color=blue]"},
        {"words": ["critical", "urgent", "important", "priority", "high", "severe", "immediate", "necessary", "required", "pivotal", "essential", "key", "vital", "overheated"], "color": "[color=orange]"},
        {"words": ["assertion", "assert", "validate", "check", "verify", "test", "prove", "confirm", "ensure", "inspection", "guard"], "color": "[color=purple]"},
        {"words": ["exception", "bind", "link", "connection", "reference", "attach", "associate", "dependency", "hook", "map", "pair", "relate"], "color": "[color=cyan]"},
        {"words": ["message", "notice", "announcement", "broadcast", "notify", "alert", "communication", "update", "report", "inform", "declaration", "statement"], "color": "[color=magenta]"},
        {"words": ["unknown", "undefined", "unspecified", "missing", "null", "empty", "none", "n/a", "unavailable", "unresolved", "blank", "void"], "color": "[color=gray]"},
        {"words": ["colony", "colonies", "settlement", "habitat", "base", "outpost", "expansion", "resources", "supply", "growth", "population", "terraform", "development", "establish", "build", "nominal", "mission", "deployment", "exploration", "establish"], "color": "[color=green]"},
        {"words": ["mech", "mechs", "robot", "exosuit", "drone", "frame", "chassis", "component", "module", "upgrade", "armor", "weapon", "servo", "gear", "actuator", "system", "engine", "core", "mechanism", "hydraulics", "cockpit"], "color": "[color=cyan]"},
        {"words": ["function", "method", "variable", "class", "object", "parameter", "argument", "return", "loop", "conditional", "syntax", "expression", "statement", "instance", "inheritance", "polymorphism", "encapsulation", "interface", "constructor", "destructor", "scope", "lambda", "closure", "callback", "recursion", "algorithm", "frozen"], "color": "[color=blue]"},
        {"words": ["power", "fuel", "energy", "supply", "battery", "charge", "generator", "capacity", "efficiency", "reserve", "store", "electric", "reactor", "output", "input", "regeneration", "recharge"], "color": "[color=yellow]"},
        {"words": ["attack", "defense", "combat", "shield", "weapon", "strategy", "tactic", "assault", "skirmish", "battle", "enemy", "foe", "threat", "secure", "fortify", "deploy", "squad", "maneuver", "engage", "resistance"], "color": "[color=red]"},
        {"words": ["science", "research", "analyze", "discovery", "experiment", "technology", "study", "develop", "invent", "innovate", "progress", "advance", "knowledge", "understand", "insight", "hypothesis"], "color": "[color=purple]"},
        {"words": ["build", "construct", "fabricate", "forge", "manufacture", "assemble", "create", "design", "blueprint", "structure", "foundation", "architecture", "prototype", "draft"], "color": "[color=orange]"}
    ]



    for entry in word_colors:
        var color_tag = entry["color"] + "[b]"
        var end_tag = "[/b][/color]"
        for word in entry["words"]:
            text = text.replace(word + "s", color_tag + word + "s" + end_tag)
            text = text.replace(word, color_tag + word + end_tag)
            text = text.replace(word.capitalize() + "s", color_tag + word.capitalize() + "s" + end_tag)
            text = text.replace(word.capitalize(), color_tag + word.capitalize() + end_tag)


    return text
