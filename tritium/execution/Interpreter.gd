class_name Interpreter extends Resource

var settings: InterpreterSettings

var global_scope = {}
var functions = {}

var visitors = {
    (func(node): return node is TritiumAST.FunctionCallNode): visit_function_call,
    (func(node): return node is TritiumAST.BinOpNode): visit_bin_or_comparison,
    (func(node): return node is TritiumAST.AssignmentNode): visit_assignment,
    (func(node): return node is TritiumAST.StatementsNode): visit_statements,
    (func(node): return node is TritiumAST.FunctionDefNode): visit_function_def,
    (func(node): return node is TritiumAST.ReturnNode): visit_return,
    (func(node): return node is TritiumAST.VarAccessNode): visit_var_access,
    (func(node): return node is TritiumAST.NumberNode): visit_number,
    (func(node): return node is TritiumAST.ComparisonNode): visit_bin_or_comparison,
    (func(node): return node is TritiumAST.IfNode): visit_if,
    (func(node): return node is TritiumAST.StringNode): visit_string,
    (func(node): return node is TritiumAST.AttributeAccessNode): visit_attribute_access,
    (func(node): return node is TritiumAST.UnaryOpNode): visit_unary_op,
    (func(node): return node is TritiumAST.DataStructureNode): visit_data_structure,
    (func(node): return node is TritiumAST.ForLoopNode): visit_for_loop,
    (func(node): return node is TritiumAST.BreakNode): visit_break,
    (func(node): return node is TritiumAST.ContinueNode): visit_continue
}

var ops = {
    "+": func(a, b):
        if (typeof(a) in [TYPE_INT, TYPE_FLOAT]) and (typeof(b) in [TYPE_INT, TYPE_FLOAT]) or typeof(a) == typeof(b):
            return success(a + b)
        else:
            return error("Type Error: Both operands must be numbers"),

    "-": func(a, b):
        if (typeof(a) in [TYPE_INT, TYPE_FLOAT]) and (typeof(b) in [TYPE_INT, TYPE_FLOAT]) or typeof(a) == typeof(b):
            return success(a - b)
        else:
            return error("Type Error: Both operands must be numbers"),

    "*": func(a, b):
        if (typeof(a) in [TYPE_INT, TYPE_FLOAT]) and (typeof(b) in [TYPE_INT, TYPE_FLOAT]) or typeof(a) == typeof(b):
            return success(a * b)
        else:
            return error("Type Error: Both operands must be numbers"),

    "/": func(a, b):
        if (typeof(a) in [TYPE_INT, TYPE_FLOAT]) and (typeof(b) in [TYPE_INT, TYPE_FLOAT]) or typeof(a) == typeof(b):
            if b == 0:
                return error("Division By Zero")
            return success(a / b)
        else:
            return error("Type Error: Both operands must be numbers"),

    "==": func(a, b):return success(a == b),

    "!=": func(a, b): return success(a != b),

    "<": func(a, b):
        if (typeof(a) in [TYPE_INT, TYPE_FLOAT]) and (typeof(b) in [TYPE_INT, TYPE_FLOAT]) or typeof(a) == typeof(b):
            return success(a < b)
        else:
            return error("Type Error: Both operands must be numbers"),

    "<=": func(a, b):
        if (typeof(a) in [TYPE_INT, TYPE_FLOAT]) and (typeof(b) in [TYPE_INT, TYPE_FLOAT]) or typeof(a) == typeof(b):
            return success(a <= b)
        else:
            return error("Type Error: Both operands must be numbers"),

    ">": func(a, b):
        if (typeof(a) in [TYPE_INT, TYPE_FLOAT]) and (typeof(b) in [TYPE_INT, TYPE_FLOAT]) or typeof(a) == typeof(b):
            return success(a > b)
        else:
            return error("Type Error: Both operands must be numbers"),

    ">=": func(a, b):
        if (typeof(a) in [TYPE_INT, TYPE_FLOAT]) and (typeof(b) in [TYPE_INT, TYPE_FLOAT]) or typeof(a) == typeof(b):
            return success(a >= b)
        else:
            return error("Type Error: Both operands must be numbers")
}

var unary_ops = {
    "-": func(a):
        if typeof(a) in [TYPE_INT, TYPE_FLOAT]:
            return success(-a)
        else:
            return error("Type Error: Operand must be a number")
}

func visit(node: TritiumAST.ASTNode) -> TritiumData.InterpreterResult:
    for rule in visitors:
        if rule.call(node):
            return visitors[rule].call(node)
    return error("Unsupported TritiumData node type: %s" % node)

func _init(settings: InterpreterSettings = InterpreterSettings.new()):
    self.settings = settings

func visit_function_call(node: TritiumAST.FunctionCallNode) -> TritiumData.InterpreterResult:
    var func_name = node.func_name.value

    if settings.bound_functions.has(func_name):
        return call_bound_function(func_name, node.args)

    if not functions.has(func_name):
        return error("Undefined function: %s" % func_name)

    var function_def = functions[func_name]
    if function_def.arg_names.size() != node.args.size():
        return error("Function call argument mismatch for %s" % func_name)

    var local_scope = {}
    for i in range(node.args.size()):
        var arg_result = visit(node.args[i])
        if arg_result.is_error():
            return arg_result
        local_scope[function_def.arg_names[i].value] = arg_result.value

    return execute_function(function_def, local_scope)

func call_bound_function(func_name: String, args: Array) -> TritiumData.InterpreterResult:
    var evaluated_args = []
    for arg in args:
        var arg_result = visit(arg)
        if arg_result.is_error():
            return arg_result
        evaluated_args.append(arg_result.value)
    return settings.call_function(func_name, evaluated_args)

func visit_bin_or_comparison(node: TritiumAST.ASTNode) -> TritiumData.InterpreterResult:
    var left_result = visit(node.left)
    if left_result.is_error():
        return left_result
    var right_result = visit(node.right)
    if right_result.is_error():
        return right_result

    return apply_operator(node.op_token.value, left_result.value, right_result.value)

func apply_operator(operator: String, left: Variant, right: Variant) -> TritiumData.InterpreterResult:
    return ops.get(operator, func(__, ___): return error("Unsupported operator: %s" % operator)).call(left, right)

func visit_unary_op(node: TritiumAST.UnaryOpNode) -> TritiumData.InterpreterResult:
    var operand_result = visit(node.operand)
    if operand_result.is_error():
        return operand_result

    return apply_unary_operator(node.op_token.value, operand_result.value)

func apply_unary_operator(operator: String, operand: Variant) -> TritiumData.InterpreterResult:
    return unary_ops.get(operator, func(__): return error("Unsupported unary operator: %s" % operator)).call(operand)

func visit_assignment(node: TritiumAST.AssignmentNode) -> TritiumData.InterpreterResult:
    var value_result = visit(node.expr)
    if value_result.is_error():
        return value_result
    global_scope[node.var_name.value] = value_result.value
    return value_result

func visit_statements(node: TritiumAST.StatementsNode) -> TritiumData.InterpreterResult:
    for statement in node.statements:
        var result = visit(statement)
        if statement is TritiumAST.IfNode:
            if result.value != null:
                return result
        if result.is_error() or statement is TritiumAST.ReturnNode:
            return result
    return success(null)

func visit_function_def(node: TritiumAST.FunctionDefNode) -> TritiumData.InterpreterResult:
    functions[node.func_name.value] = node
    return success(null)

func visit_return(node: TritiumAST.ReturnNode) -> TritiumData.InterpreterResult:
    return visit(node.expr)

func visit_var_access(node: TritiumAST.VarAccessNode) -> TritiumData.InterpreterResult:
    return get_variable_value(node.var_name.value)

func get_variable_value(var_name: String) -> TritiumData.InterpreterResult:
    if settings.bound_properties.has(var_name):
        return settings.get_property(var_name)
    if settings.bound_variables.has(var_name):
        return settings.get_variable(var_name)
    if global_scope.has(var_name):
        return success(global_scope[var_name])
    return error("Undefined variable: %s" % var_name)

func visit_number(node: TritiumAST.NumberNode) -> TritiumData.InterpreterResult:
    return success(float(node.token.value) if node.token.type == TritiumData.TokenType.FLOAT else int(node.token.value))

func visit_string(node: TritiumAST.StringNode) -> TritiumData.InterpreterResult:
    return success(node.token.value)

func visit_data_structure(node: TritiumAST.DataStructureNode) -> TritiumData.InterpreterResult:
    var arr = []
    for element: TritiumAST.ASTNode in node.elements:
        var result = visit(element)
        if result.error:
            return result
        arr.append(result.value)
    if node.data_type == "Set":
        return success(HashSet.new(arr))
    if node.data_type == "Tuple":
        return success(Tuple.new(arr))
    return success(arr)

func visit_if(node: TritiumAST.IfNode) -> TritiumData.InterpreterResult:
    var condition_result = visit(node.condition)
    if condition_result.is_error():
        return condition_result

    if condition_result.value:
        return visit(node.body)

    for elif_case in node.elif_cases:
        var elif_condition_result = visit(elif_case["condition"])
        if elif_condition_result.is_error():
            return elif_condition_result
        if elif_condition_result.value:
            return visit(elif_case["body"])

    if node.else_case:
        return visit(node.else_case)

    return success(null)

func visit_for_loop(node: TritiumAST.ForLoopNode) -> TritiumData.InterpreterResult:
    var iterable_result = visit(node.iterable)
    if iterable_result.is_error():
        return iterable_result

    var iterable = iterable_result.value
    if typeof(iterable) != TYPE_ARRAY:
        return error("For loop iterable must be an array")

    for element in iterable:
        var local_scope = global_scope.duplicate()
        local_scope[node.identifier.var_name.value] = element

        var result = execute_block_with_scope(node.body, local_scope)
        if result.is_error():
            return result
        if result.value == "break":
            break
        if result.value == "continue":
            continue

    return success(null)

func visit_break(node: TritiumAST.BreakNode) -> TritiumData.InterpreterResult:
    return success("break")

func visit_continue(node: TritiumAST.ContinueNode) -> TritiumData.InterpreterResult:
    return success("continue")

func visit_attribute_access(node: TritiumAST.AttributeAccessNode) -> TritiumData.InterpreterResult:
    var left_result = visit(node.left)
    if left_result.is_error():
        return left_result

    if node.right is TritiumAST.FunctionCallNode:
        if typeof(left_result.value) == TYPE_OBJECT:
            if left_result.value.has_method(node.right.func_name.value):
                var evaluated_args = []
                for arg in node.right.args:
                    var arg_result = visit(arg)
                    if arg_result.is_error():
                        return arg_result
                    evaluated_args.append(arg_result.value)
                var func_: Callable = left_result.value[node.right.func_name.value]
                var fn_def = func_.get_object().get_script().get_script_method_list().filter(func(x): return x["name"] == func_.get_method())
                if fn_def.size() != 0:
                    fn_def = fn_def[0]
                    if fn_def.has("default_args"):
                        func_ = func_.bindv(fn_def["default_args"])
                if func_.get_argument_count() > evaluated_args.size():
                    return error("Insufficient number of args passed for: %s, expected %s, got %s" % [node.right.func_name.value, func_.get_argument_count(), evaluated_args.size()])
                return success(left_result.value.callv(node.right.func_name.value, evaluated_args))
        return visit_function_call(node.right)

    return get_attribute_value(left_result.value, node.right.var_name.value)

func get_attribute_value(left_value: Variant, attribute_name: String) -> TritiumData.InterpreterResult:
    match typeof(left_value):
        TYPE_OBJECT:
            if attribute_name in left_value and not attribute_name.begins_with("_"):
                return success(left_value.get(attribute_name))
        TYPE_DICTIONARY:
            if attribute_name in left_value:
                return success(left_value[attribute_name])
        TYPE_ARRAY:
            if attribute_name == "size":
                return success(left_value.size())
        TYPE_VECTOR2, TYPE_VECTOR2I:
            match attribute_name:
                "x": return success(left_value.x)
                "y": return success(left_value.y)
        TYPE_VECTOR3, TYPE_VECTOR3I:
            match attribute_name:
                "x": return success(left_value.x)
                "y": return success(left_value.y)
                "z": return success(left_value.z)
        TYPE_RECT2, TYPE_RECT2I:
            match attribute_name:
                "position": return success(left_value.position)
                "size": return success(left_value.size)
        TYPE_TRANSFORM2D:
            match attribute_name:
                "x": return success(left_value.x)
                "y": return success(left_value.y)
                "origin": return success(left_value.origin)
        TYPE_COLOR:
            match attribute_name:
                "r": return success(left_value.r)
                "g": return success(left_value.g)
                "b": return success(left_value.b)
                "a": return success(left_value.a)
        TYPE_QUATERNION:
            match attribute_name:
                "x": return success(left_value.x)
                "y": return success(left_value.y)
                "z": return success(left_value.z)
                "w": return success(left_value.w)
        TYPE_TRANSFORM2D:
            match attribute_name:
                "basis": return success(left_value.basis)
                "origin": return success(left_value.origin)
        TYPE_AABB:
            match attribute_name:
                "position": return success(left_value.position)
                "size": return success(left_value.size)
        TYPE_PLANE:
            match attribute_name:
                "normal": return success(left_value.normal)
                "d": return success(left_value.d)
        TYPE_RID:
            if attribute_name == "id":
                return success(left_value.get_id())
        _:
            return error("Unsupported attribute access for type: %s" % type_string(typeof(left_value)))

    return error("Undefined attribute: %s" % attribute_name)

func execute_function(function_def: TritiumAST.FunctionDefNode, local_scope: Dictionary) -> TritiumData.InterpreterResult:
    var old_global_scope = global_scope
    global_scope = global_scope.duplicate()
    global_scope.merge(local_scope)
    var result = visit(function_def.body)
    global_scope = old_global_scope

    return result

func execute_block_with_scope(body: TritiumAST.StatementsNode, local_scope: Dictionary) -> TritiumData.InterpreterResult:
    var old_global_scope = global_scope
    global_scope = local_scope
    var result = visit(body)
    global_scope = old_global_scope
    return result

func _interpret(ast: TritiumAST.ASTNode, main_args={}) -> TritiumData.InterpreterResult:
    var result = visit(ast)
    if result.is_error():
        return result

    var main_func = functions.get("main", null)
    if main_func == null:
        return error("No 'main' function defined")

    return execute_function(main_func, main_args)

func _to_string() -> String:
    return "NodeVisitor(global_scope: %s, functions: %s)" % [str(global_scope), str(functions)]

static func error(error_msg: String) -> TritiumData.InterpreterResult:
    return TritiumData.InterpreterResult.new(null, error_msg)

static func success(value: Variant) -> TritiumData.InterpreterResult:
    return TritiumData.InterpreterResult.new(value)

static func interpret(parse_result: TritiumData.ParseResult, settings: InterpreterSettings, global_vars={}) -> TritiumData.InterpreterResult:
    if parse_result.error:
        return error("Parsing error: %s" % parse_result.error)
    return new(settings)._interpret(parse_result.node, global_vars)
