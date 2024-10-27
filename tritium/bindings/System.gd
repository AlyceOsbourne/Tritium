const version: Vector3i = Vector3i(0, 0, 1)

static func bind(interpreter_settings: InterpreterSettings) -> void:
    interpreter_settings.bind_property("VERSION", str.bind(version))

    interpreter_settings.bind_variable("null", null)
    interpreter_settings.bind_function("str", str)
    interpreter_settings.bind_variable("true", true)
    interpreter_settings.bind_variable("false", false)
    interpreter_settings.bind_function("any", func(a: Array): return a.any(func(x): return bool(x)))
    interpreter_settings.bind_function("all", func(a: Array): return a.all(func(x): return bool(x)))
    interpreter_settings.bind_function(
        "import",
        func(x):
            var path = "res://tritium/bindings/" + x + ".gd"
            var module = load(path)
            if module:
                if module.has_method("bind"):
                    interpreter_settings.bind_module(module)
                if "Module" in module:
                    return module.Module.new(interpreter_settings)
            return null
    )

    interpreter_settings.bind_property(
        "modules",
        func():
            return "\n".join((DirAccess.get_files_at("res://tritium/bindings/") as Array).map(func(x): return x.replace(".gd", "")))
    )
    interpreter_settings.bind_variable("OK", OK)
    interpreter_settings.bind_function("OK", Result.SUCCESS)
    interpreter_settings.bind_variable("FAIL", FAILED)
    interpreter_settings.bind_function("FAIL", Result.FAIL)
    interpreter_settings.bind_function("Table", Table.new)
    interpreter_settings.bind_function("Database", Database.new)

    interpreter_settings.bind_variable("INT", TYPE_INT)
    interpreter_settings.bind_variable("FLOAT", TYPE_FLOAT)
    interpreter_settings.bind_variable("STRING", TYPE_STRING)
    interpreter_settings.bind_function("Dict", DictionaryType.new)
