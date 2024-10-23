extends Resource
class_name Tritium

@export var settings: InterpreterSettings = InterpreterSettings.new()

signal started(code: String)
signal tokens(array: Array)
signal ast(ast: TritiumAST.ASTNode)
signal meta(data: Dictionary)
signal stdout(string: String)
signal stderr(string: String)
signal complete(result: TritiumData)

var easter_eggs = {
    func(mech): return uwu.uwucrew.has(mech.name): func(settings: InterpreterSettings): settings.bind_module(load("res://tritium/bindings/eggs/uwu.gd")),
    func(mech): return godoblins.godoblins.has(mech.name): func(settings: InterpreterSettings): settings.bind_module(load("res://tritium/bindings/eggs/arr.gd")),
    func(mech): return cthulhubots.cthulhucrew.has(mech.name): func(settings: InterpreterSettings): settings.bind_module(load("res://tritium/bindings/eggs/cthulhu.gd")),
}

func evaluate(
        code: String,
        meta_data: Dictionary={a=1},
    ):

    var lexed = Lexer.tokenize(code)
    tokens.emit(lexed.tokens)
    var parsed = AST.parse(lexed)
    ast.emit(parsed)
    var _settings: InterpreterSettings = settings.duplicate(true)

    for k in get_meta_list():
        meta_data[k] = get_meta(k)

    if has_method("bind"):
        _settings.bind_module(self)

    _settings.bind_function("print", func(x="", y = "\n"): stdout.emit(str(x) + str(y)))
    _settings.bind_function("printerr", func(x="", y = "\n"): stderr.emit(str(x) + str(y)))
    _settings.bind_property("globals", func():
        var funcs: Array[String] = _settings.bound_functions.keys()
        var properties: Array[String] = _settings.bound_properties.keys()
        var variables: Array[String] = _settings.bound_variables.keys()

        var globals_dict: Dictionary = {}

        for _func in funcs:
            globals_dict[_func] = true
        for prop in properties:
            globals_dict[prop] = true
        for variable in variables:
            globals_dict[variable] = true
        for k in meta_data:
            globals_dict[k] = true

        var globals: Array[String]
        globals.assign(globals_dict.keys()  )
        globals.sort()
        return "\n".join(globals)
    )

    _settings.bind_function("store", set_meta)
    _settings.bind_function("load", get_meta)
    _settings.bind_function("storage", get_meta_list)

    meta.emit(meta_data)
    started.emit(code)

    if _settings.bound_variables.has("mech"):
        var mech = settings.bound_variables["mech"]
        for egg in easter_eggs:
            if egg.call(mech):
                print("Easter Egg Found: " + mech.name)
                easter_eggs[egg].call(_settings)

    var result = Interpreter.interpret(parsed, _settings, meta_data)

    if result.error:
        stderr.emit.call_deferred("Ran and errored: " + result.error + "\n")
    elif result.value != null:
        stdout.emit.call_deferred("Ran and returned: " + str(result.value) + "\n")
    else:
        stdout.emit("Ran without error.\n")
    complete.emit.call_deferred(result)
    return result

func execute_file(path: String, meta_data:={}):
    path = "user://tritium/%s.txt" % path
    if FileAccess.file_exists(path):
        var tritium: Tritium = self.duplicate(true)
        for listener_group: Signal in [started, stdout, stderr]:
            for conn in listener_group.get_connections():
                tritium.connect(listener_group.get_name(), conn["callable"])
        return tritium.evaluate(FileAccess.get_file_as_string(path), meta_data)
    return TritiumData.InterpreterResult.new(null, "File does not exist")

func _to_string() -> String:
    return "Tritium"
