class_name TritiumAST

class ASTNode:
    func to_dict():
        return {}

class UnaryOpNode extends ASTNode:
    func _init(op_token, operand):
        self.op_token = op_token
        self.operand = operand

    func _to_string() -> String:
        return "%s%s" % [self.op_token.value, self.operand._to_string()]

    func to_dict() -> Dictionary:
        return {
            "type": "UnaryOpNode",
            "op": self.op_token.value,
            "operand": self.operand.to_dict()
        }

    var op_token: TritiumData.Token
    var operand: ASTNode

class BinOpNode extends ASTNode:
    func _to_string() -> String:
        return "%s %s %s" % [self.left._to_string(), self.op_token.value, self.right._to_string()]

    func to_dict() -> Dictionary:
        return {
            "type": "BinOpNode",
            "left": self.left.to_dict(),
            "op": self.op_token.value,
            "right": self.right.to_dict()
        }

    var left: ASTNode
    var op_token: TritiumData.Token
    var right: ASTNode

    func _init(left: ASTNode, op_token: TritiumData.Token, right: ASTNode):
        self.left = left
        self.op_token = op_token
        self.right = right

class AssignmentNode extends ASTNode:
    func _to_string() -> String:
        return "%s = %s" % [self.var_name.value, self.expr._to_string()]

    func to_dict() -> Dictionary:
        return {
            "type": "AssignmentNode",
            "var_name": self.var_name.value,
            "expr": self.expr.to_dict()
        }

    var var_name: TritiumData.Token
    var expr: ASTNode

    func _init(var_name: TritiumData.Token, expr: ASTNode):
        self.var_name = var_name
        self.expr = expr

class StatementsNode extends ASTNode:
    func _to_string() -> String:
        return "Statements([%s])" % [", ".join(self.statements.map(str))]

    func to_dict() -> Dictionary:
        return {
            "type": "StatementsNode",
            "statements": self.statements.map(func(x): return x.to_dict())
        }

    var statements: Array

    func _init(statements: Array):
        self.statements = statements

class FunctionCallNode extends ASTNode:
    func _to_string() -> String:
        return "%s(%s)" % [self.func_name.value, ", ".join(self.args.map(str))]

    func to_dict() -> Dictionary:
        return {
            "type": "FunctionCallNode",
            "func_name": self.func_name.value,
            "args": self.args.map(func(x): return x.to_dict())
        }

    var func_name: TritiumData.Token
    var args: Array

    func _init(func_name: TritiumData.Token, args: Array):
        self.func_name = func_name
        self.args = args

class FunctionDefNode extends ASTNode:
    func _to_string() -> String:
        return "%s(%s)" % [self.func_name.value, ", ".join(self.arg_names.map(str))]

    func to_dict() -> Dictionary:
        return {
            "type": "FunctionDefNode",
            "func_name": self.func_name.value,
            "arg_names": self.arg_names,
            "body": self.body.to_dict()
        }

    var func_name: TritiumData.Token
    var arg_names: Array
    var body: StatementsNode

    func _init(func_name: TritiumData.Token, arg_names: Array, body: StatementsNode):
        self.func_name = func_name
        self.arg_names = arg_names
        self.body = body

class ReturnNode extends ASTNode:
    func _to_string() -> String:
        return "return %s" % [self.expr._to_string()]

    func to_dict() -> Dictionary:
        return {
            "type": "ReturnNode",
            "expr": self.expr.to_dict() if self.expr else ASTNode.new()
        }

    var expr: ASTNode

    func _init(expr: ASTNode):
        self.expr = expr

class VarAccessNode extends ASTNode:
    func _to_string() -> String:
        return self.var_name.value

    func to_dict() -> Dictionary:
        return {
            "type": "VarAccessNode",
            "var_name": self.var_name.value
        }

    var var_name: TritiumData.Token

    func _init(var_name: TritiumData.Token):
        self.var_name = var_name

class NumberNode extends ASTNode:
    func _to_string() -> String:
        return self.token.value

    func to_dict() -> Dictionary:
        return {
            "type": "NumberNode",
            "value": self.token.value
        }

    var token: TritiumData.Token

    func _init(token: TritiumData.Token):
        self.token = token

class StringNode extends ASTNode:
    func _to_string() -> String:
        return "\"%s\"" % [self.token.value]

    func to_dict() -> Dictionary:
        return {
            "type": "StringNode",
            "value": self.token.value
        }

    var token: TritiumData.Token

    func _init(token: TritiumData.Token):
        self.token = token

class ComparisonNode extends ASTNode:
    func _to_string() -> String:
        return "%s %s %s" % [self.left._to_string(), self.op_token.value, self.right._to_string()]

    func to_dict() -> Dictionary:
        return {
            "type": "ComparisonNode",
            "left": self.left.to_dict(),
            "op_token": self.op_token.value,
            "right": self.right.to_dict()
        }

    var left: ASTNode
    var op_token: TritiumData.Token
    var right: ASTNode

    func _init(left: ASTNode, comparison_token: TritiumData.Token, right: ASTNode):
        self.left = left
        self.op_token = comparison_token
        self.right = right

class IfNode extends ASTNode:
    func _to_string() -> String:
        var result = "if %s: %s" % [self.condition._to_string(), self.body._to_string()]
        if self.elif_cases.size() > 0:
            for elif_case in self.elif_cases:
                result += "\nelif %s: %s" % [elif_case["condition"]._to_string(), elif_case["body"]._to_string()]
        if self.else_case:
            result += "\nelse: %s" % [self.else_case._to_string()]
        return result

    func to_dict() -> Dictionary:
        var result = {
            "type": "IfNode",
            "condition": self.condition.to_dict(),
            "body": self.body.to_dict(),
            "elif_cases": [],
            "else_case": null
        }
        for elif_case in self.elif_cases:
            result["elif_cases"].append({
                "condition": elif_case["condition"].to_dict(),
                "body": elif_case["body"].to_dict()
            })
        if self.else_case:
            result["else_case"] = self.else_case.to_dict()
        return result

    var condition: ASTNode
    var body: StatementsNode
    var elif_cases: Array[Dictionary] = []
    var else_case: StatementsNode = null

    func _init(condition: ASTNode, body: StatementsNode, elif_cases: Array[Dictionary] = [], else_case: StatementsNode = null):
        self.condition = condition
        self.body = body
        self.elif_cases = elif_cases
        self.else_case = else_case

class BreakNode extends ASTNode:
    func _to_string() -> String:
        return "break"

    func to_dict() -> Dictionary:
        return {
            "type": "BreakNode"
        }

    func _init():
        pass

class ContinueNode extends ASTNode:
    func _to_string() -> String:
        return "continue"

    func to_dict() -> Dictionary:
        return {
            "type": "ContinueNode"
        }

    func _init():
        pass

class ForLoopNode extends ASTNode:
    func _to_string() -> String:
        return "for %s in %s:\n  %s" % [self.identifier._to_string(), self.iterable._to_string(), self.body._to_string()]

    func to_dict() -> Dictionary:
        return {
            "type": "ForLoopNode",
            "identifier": self.identifier.to_dict(),
            "iterable": self.iterable.to_dict(),
            "body": self.body.to_dict()
        }

    var identifier: VarAccessNode
    var iterable: ASTNode
    var body: StatementsNode

    func _init(identifier: VarAccessNode, iterable: ASTNode, body: StatementsNode):
        self.identifier = identifier
        self.iterable = iterable
        self.body = body

class AttributeAccessNode extends ASTNode:
    func _to_string() -> String:
        return "%s %s %s" % [self.left._to_string(), ".", self.right._to_string()]

    func to_dict() -> Dictionary:
        return {
            "type": "AttributeAccess",
            "left": self.left.to_dict(),
            "right": self.right.to_dict()
        }

    var left: ASTNode
    var right: ASTNode

    func _init(left: ASTNode, right: ASTNode):
        self.left = left
        self.right = right

class InvalidSyntaxError extends ASTNode:
    func _to_string() -> String:
        return "SyntaxError: %s" % [self.error]

    func to_dict() -> Dictionary:
        return {
            "type": "InvalidSyntaxError",
            "line": self.line,
            "message": self.error
        }

    var line: int
    var error: String

    func _init(line: int, error: String):
        self.line = line
        self.error = error

class DataStructureNode extends ASTNode:
    func _to_string() -> String:
        return "%s(%s)" % [self.data_type, ", ".join(self.elements.map(str))]

    func to_dict() -> Dictionary:
        return {
            "type": "DataStructureNode",
            "data_type": self.data_type,
            "elements": self.elements.map(func(x): return x.to_dict())
        }

    var data_type: String # "Array", "Dict", "Set", or "Tuple"
    var elements: Array

    func _init(data_type: String, elements: Array):
        self.data_type = data_type
        self.elements = elements

class Pair extends ASTNode:
    var left: ASTNode
    var right: ASTNode

    func _init(left: ASTNode, right: ASTNode):
        self.left = left
        self.right = right

    func _to_string() -> String:
        return "(%s: %s)" % [self.left._to_string(), self.right._to_string()]

    func to_dict() -> Dictionary:
        return {
            "left": self.left.to_dict(),
            "right": self.right.to_dict()
        }
