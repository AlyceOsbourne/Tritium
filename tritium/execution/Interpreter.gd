class_name Interpreter extends Resource

var global_scope = {}
var functions = {}

var settings: InterpreterSettings

static func error(error_msg: String) -> TritiumData.InterpreterResult:
    return TritiumData.InterpreterResult.new(null, error_msg)

static func success(value: Variant) -> TritiumData.InterpreterResult:
    return TritiumData.InterpreterResult.new(value)

static func interpret(parse_result: TritiumData.ParseResult, settings: InterpreterSettings, global_vars={}) -> TritiumData.InterpreterResult:
    if parse_result.error:
        return Interpreter.error("Parsing error: %s" % parse_result.error)
    return new(settings)._interpret(parse_result.node, global_vars)

func _init(settings: InterpreterSettings = InterpreterSettings.new()):
    self.settings = settings

func visit(node: TritiumData.ASTNode) -> TritiumData.InterpreterResult:
    if node is TritiumData.FunctionCallNode:
        return visit_function_call(node)
    elif node is TritiumData.BinOpNode:
        return visit_bin_op(node)
    elif node is TritiumData.AssignmentNode:
        return visit_assignment(node)
    elif node is TritiumData.StatementsNode:
        return visit_statements(node)
    elif node is TritiumData.FunctionDefNode:
        return visit_function_def(node)
    elif node is TritiumData.ReturnNode:
        return visit_return(node)
    elif node is TritiumData.VarAccessNode:
        return visit_var_access(node)
    elif node is TritiumData.NumberNode:
        return visit_number(node)
    elif node is TritiumData.ComparisonNode:
        return visit_comparison(node)
    elif node is TritiumData.IfNode:
        return visit_if(node)
    elif node is TritiumData.StringNode:
        return visit_string(node)
    else:
        return Interpreter.error("Unsupported TritiumData node type: %s" % node)

func visit_function_call(node: TritiumData.FunctionCallNode) -> TritiumData.InterpreterResult:
    var func_name = node.func_name.value

    if settings.bound_functions.has(func_name):
        var args = []
        for arg in node.args:
            var arg_result = visit(arg)
            if arg_result.is_error():
                return arg_result
            args.append(arg_result.value)
        return settings.call_function(func_name, args)

    if not functions.has(func_name):
        return Interpreter.error("Undefined function: %s" % func_name)

    var function_def = functions[func_name]
    if function_def.arg_names.size() != node.args.size():
        return Interpreter.error("Function call argument mismatch for %s" % func_name)

    var local_scope = {}
    for i in range(node.args.size()):
        var arg_result = visit(node.args[i])
        if arg_result.is_error():
            return arg_result
        local_scope[function_def.arg_names[i].value] = arg_result.value

    return execute_function(function_def, local_scope)

func visit_bin_op(node: TritiumData.BinOpNode) -> TritiumData.InterpreterResult:
    var left_result = visit(node.left)
    if left_result.is_error():
        return left_result
    var right_result = visit(node.right)
    if right_result.is_error():
        return right_result

    var left = left_result.value
    var right = right_result.value

    if node.op_token.value == "+":
        return Interpreter.success(left + right)
    elif node.op_token.value == "-":
        return Interpreter.success(left - right)
    elif node.op_token.value == "*":
        return Interpreter.success(left * right)
    elif node.op_token.value == "/":
        if right == 0:
            return Interpreter.error("Division by zero")
        return Interpreter.success(left / right)
    else:
        return Interpreter.error("Unsupported binary operator: %s" % node.op_token.value)

func visit_assignment(node: TritiumData.AssignmentNode) -> TritiumData.InterpreterResult:
    var value_result = visit(node.expr)
    if value_result.is_error():
        return value_result
    global_scope[node.var_name.value] = value_result.value
    return value_result

func visit_statements(node: TritiumData.StatementsNode) -> TritiumData.InterpreterResult:
    for statement in node.statements:
        var result = visit(statement)
        if statement is TritiumData.IfNode:
            if result.value != null:
                return result
        if result.is_error() or statement is TritiumData.ReturnNode:
            return result
    return success(null)

func visit_function_def(node: TritiumData.FunctionDefNode) -> TritiumData.InterpreterResult:
    functions[node.func_name.value] = node
    return Interpreter.success(null)

func visit_return(node: TritiumData.ReturnNode) -> TritiumData.InterpreterResult:
    return visit(node.expr)

func visit_var_access(node: TritiumData.VarAccessNode) -> TritiumData.InterpreterResult:
    if settings.bound_properties.has(node.var_name.value):
        return settings.get_property(node.var_name.value)
    if settings.bound_variables.has(node.var_name.value):
        return settings.get_variable(node.var_name.value)
    if global_scope.has(node.var_name.value):
        return Interpreter.success(global_scope[node.var_name.value])
    return Interpreter.error("Undefined variable: %s" % node.var_name.value)

func visit_number(node: TritiumData.NumberNode) -> TritiumData.InterpreterResult:
    return Interpreter.success(float(node.token.value) if node.token.type == TritiumData.TokenType.FLOAT else int(node.token.value))

func visit_string(node: TritiumData.StringNode) -> TritiumData.InterpreterResult:
    return Interpreter.success(node.token.value)

func visit_comparison(node: TritiumData.ComparisonNode) -> TritiumData.InterpreterResult:
    var left_result = visit(node.left)
    if left_result.is_error():
        return left_result
    var right_result = visit(node.right)
    if right_result.is_error():
        return right_result

    var left = left_result.value
    var right = right_result.value

    if node.comparison_token.value == "==":
        return Interpreter.success(left == right)
    elif node.comparison_token.value == "!=":
        return Interpreter.success(left != right)
    elif node.comparison_token.value == "<":
        return Interpreter.success(left < right)
    elif node.comparison_token.value == "<=":
        return Interpreter.success(left <= right)
    elif node.comparison_token.value == ">":
        return Interpreter.success(left > right)
    elif node.comparison_token.value == ">=":
        return Interpreter.success(left >= right)
    else:
        return Interpreter.error("Unsupported comparison operator: %s" % node.comparison_token.value)

func visit_if(node: TritiumData.IfNode) -> TritiumData.InterpreterResult:
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

    return Interpreter.success(null)

func execute_function(function_def: TritiumData.FunctionDefNode, local_scope: Dictionary) -> TritiumData.InterpreterResult:
    var old_global_scope = global_scope
    global_scope = global_scope.duplicate()
    global_scope.merge(local_scope)
    var result = visit(function_def.body)
    global_scope = old_global_scope

    return result

func _interpret(ast: TritiumData.ASTNode, main_args={}) -> TritiumData.InterpreterResult:

    var result = visit(ast)
    if result.is_error():
        return result

    var main_func = functions.get("main", null)
    if main_func == null:
        return Interpreter.error("No 'main' function defined")
    return execute_function(main_func, main_args)

func _to_string() -> String:
    return "NodeVisitor(global_scope: %s, functions: %s)" % [str(global_scope), str(functions)]
