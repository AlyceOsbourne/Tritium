class_name InterpreterSettings
extends Resource

@export_dir var bindings_folder: String = "res://bindings/"

@export_storage var bound_functions: Dictionary[String, Callable] = {}
@export_storage var bound_variables: Dictionary[String, Variant] = {}
@export_storage var bound_properties: Dictionary[String, Callable] = {}
@export var bound_modules: Array[GDScript] = [
    load("res://addons/tritium/builtins/System.gd"),
]:
    set(v):
        bound_modules = v
        for mod in v.filter(is_instance_valid):
            bind_module(mod)

@export_multiline var code: String = "fn main() {}"

func bind_function(function_name: String, callable: Callable):
    bound_functions[function_name] = callable

func call_function(function_name: String, args: Array[Variant], obj = null) -> TritiumData.InterpreterResult:
    var args_input = args.map(Pipeline.output)
    var return_output

    if obj != null and obj.has_method(function_name):
        return_output = obj.callv(function_name, args)

    elif obj == null and bound_functions.has(function_name):
        return_output = bound_functions[function_name].callv(args_input)

    else:
        return Interpreter.error("Undefined bound function: %s" % function_name)

    return_output = Pipeline.input(return_output)


    if not return_output is TritiumData.InterpreterResult:
        return_output = TritiumData.InterpreterResult.new(return_output)

    print("func %s(%s) -> %s" % [function_name, ",".join(args), return_output])

    return return_output

func bind_variable(variable_name: String, variable: Variant):
    bound_variables[variable_name] = Pipeline.input(variable)

func get_variable(variable_name: String):
    if bound_variables.has(variable_name):
        var v = Pipeline.output(bound_variables[variable_name])
        return Interpreter.success(v)
    return Interpreter.error("Undefined variable: %s" % variable_name)

func bind_property(property_name: String, callable: Callable):
    bound_properties[property_name] = callable

func get_property(property_name: String):
    if bound_properties.has(property_name):
        return TritiumData.InterpreterResult.new(Pipeline.input(bound_properties.get(property_name).call()))
    return Interpreter.error("Undefined property: %s" % property_name)

func bind_module(script: Object):
    if script.has_method("bind"):
        script.bind(self)
