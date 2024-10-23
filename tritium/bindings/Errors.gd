enum ExceptionTypes {
    GenericException,
    AssertionError,
    ValueError,
    NotImplementedError,
    RuntimeError,
    AttributeError,
    ImportError,
    IOError,
    ZeroDivisionError,
}

static func raise(message: String = "An unknown error has occurred", exception_type := ExceptionTypes.GenericException):
    var type = ExceptionTypes.find_key(exception_type)
    if not type:
        type = ExceptionTypes.find_key(ExceptionTypes.GenericException)
    return TritiumData.InterpreterResult.new(null, "%s: %s" % [type, str(message)])

static func bind(interpreter_settings: InterpreterSettings):
    interpreter_settings.bind_function("assert", func(expression: bool, message: String):
        if not expression:
            return raise(message, ExceptionTypes.AssertionError)
    )

    interpreter_settings.bind_function("except", raise)
    interpreter_settings.bind_variable("OK", OK)
    interpreter_settings.bind_variable("FAIL", FAILED)
    interpreter_settings.bind_variable("ExceptionType", ExceptionTypes)
