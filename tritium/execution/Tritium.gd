extends Resource
class_name Tritium

@export var settings: InterpreterSettings = InterpreterSettings.new()

signal started
signal tokens(array: Array)
signal ast(ast: TritiumData.ASTNode)
signal meta(data: Dictionary)
signal stdout(string: String)
signal stderr(string: String)
signal complete(result: TritiumData)

func evaluate(
        code: String,
        meta_data={},
    ):

    var lexed = Lexer.tokenize(code)
    tokens.emit(lexed)
    var parsed = AST.parse(lexed)
    ast.emit(parsed)
    var _settings: InterpreterSettings = settings.duplicate(true)

    for k in get_meta_list():
        meta_data[k] = get_meta(k)

    if has_method("bind"):
        _settings.bind_module(self)

    _settings.bind_function("print", func(x="", y = "\n"): stdout.emit(str(x) + y))
    _settings.bind_function("printerr", func(x="", y = "\n"): stderr.emit(str(x) + y))
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

    settings.bind_function("store", set_meta)
    settings.bind_function("load", get_meta)
    settings.bind_function("storage", get_meta_list)

    meta.emit(meta_data)

    started.emit()

    var result = Interpreter.interpret(parsed, _settings, meta_data)

    if result.error:
        stderr.emit("Ran and errored: " + result.error)
    elif result.value != null:
        stdout.emit("Ran and returned: " + str(result.value))
    else:
        stdout.emit("Ran without error.")
    complete.emit(result)
    return result
