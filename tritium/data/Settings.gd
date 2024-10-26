class_name InterpreterSettings
extends Resource

@export_storage var bound_functions: Dictionary[String, Callable] = {}
@export_storage var bound_variables: Dictionary[String, Variant] = {}
@export_storage var bound_properties: Dictionary[String, Callable] = {}

@export var bound_modules: Array[GDScript] = [
    load("res://tritium/bindings/System.gd"),
    load("res://tritium/bindings/Errors.gd"),
    load("res://tritium/bindings/eggs/highlights.gd")
]:
    set(v):
        bound_modules = v
        for mod in v:
            if not mod:
                continue
            bind_module(mod)

func bind_function(function_name: String, callable: Callable):
    bound_functions[function_name] = callable

func call_function(function_name: String, args: Array[Variant]) -> TritiumData.InterpreterResult:
    if bound_functions.has(function_name):
        var v = bound_functions[function_name].callv(args)
        if not v is TritiumData.InterpreterResult:
            v = TritiumData.InterpreterResult.new(v)
        return v
    return Interpreter.error("Undefined bound function: %s" % function_name)

func bind_variable(variable_name: String, variable: Variant):
    bound_variables[variable_name] = variable

func get_variable(variable_name: String):
    if bound_variables.has(variable_name):
        var v = bound_variables[variable_name]
        return Interpreter.success(v)
    return Interpreter.error("Undefined variable: %s" % variable_name)

func bind_property(property_name: String, callable: Callable):
    bound_properties[property_name] = callable

func get_property(property_name: String):
    if bound_properties.has(property_name):
        return TritiumData.InterpreterResult.new(bound_properties.get(property_name).call())
    return Interpreter.error("Undefined property: %s" % property_name)

func bind_module(script: Object):
    if script.has_method("bind"):
        script.bind(self)
