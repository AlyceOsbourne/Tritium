static func bind(interpreter_settings: InterpreterSettings):
    interpreter_settings.bind_function("get", func(x, y): return x[y] if y and y in x else null)
    interpreter_settings.bind_function("set", func(x, y, z): x[y] = z)
