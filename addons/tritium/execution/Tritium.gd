extends Resource
class_name Tritium

signal started(code: String)
signal tokens(array: Array)
signal ast(ast: TritiumAST.ASTNode)
signal meta(data: Dictionary)
signal stdout(string: String)
signal stderr(string: String)
signal complete(result: TritiumData)

func evaluate(
        settings: InterpreterSettings,
        code: String,
        meta_data: Dictionary={},
        easter_eggs := {}
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
        globals.assign(globals_dict.keys())
        globals.sort()
        return "\n".join(globals)
    )

    for egg in easter_eggs:
        if egg.call(_settings):
            easter_eggs[egg].call(_settings)

    meta.emit(meta_data)

    started.emit(code)

    var result = Interpreter.interpret(parsed, _settings, meta_data)

    if result.error:
        stderr.emit.call_deferred("Ran and errored: " + result.error + "\n")
    elif result.value != null:
        stdout.emit.call_deferred("Ran and returned: " + str(result.value) + "\n")
    else:
        stdout.emit.call_deferred("Ran without error.\n")
    complete.emit.call_deferred(result)

    return result

func _to_string() -> String:
    return "Tritium"
