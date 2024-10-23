const version: Vector3i = Vector3i(0, 0, 1)

static func bind(interpreter_settings: InterpreterSettings) -> void:


    interpreter_settings.bind_property("VERSION", str.bind(version))

    interpreter_settings.bind_variable("null", null)
    interpreter_settings.bind_function("str", str)
    interpreter_settings.bind_variable("true", true)
    interpreter_settings.bind_variable("false", false)
    interpreter_settings.bind_function("list", func(): return Array())
    interpreter_settings.bind_function("dict", func(): return Dictionary())

    interpreter_settings.bind_function(
        "import",
        func(x):
            var path = "res://tritium/bindings/" + x + ".gd"
            if FileAccess.file_exists(path):
                interpreter_settings.bind_module(load(path)
    ))

    interpreter_settings.bind_property(
        "modules",
        func():
            return "\n".join((DirAccess.get_files_at("res://tritium/bindings/") as Array).map(func(x): return x.replace(".gd", "")))
    )
