class_name TritiumData

enum TokenType {
    INT, FLOAT, OPERATOR, PAREN, IDENTIFIER, ASSIGNMENT, RETURN, SEMICOLON, DOT,
    FN, COMMA, CURLY_OPEN, CURLY_CLOSE, COMMENT, EOF, COMPARISON, IF, ELIF, ELSE, STRING
}

class Token:
    var type: TokenType
    var value: String
    var line: int

    func _init(type: TokenType, value: String, line: int) -> void:
        self.type = type
        self.value = value
        self.line = line

    func _to_string() -> String:
        return "Line %d: %s: %s" % [self.line, TokenType.find_key(self.type), str(self.value)]


class LexerResult:
    var tokens: Array[TritiumData.Token]
    var error: String
    var line: int

    func _init(tokens: Array[TritiumData.Token], error: String, line: int) -> void:
        self.tokens = tokens
        self.error = error
        self.line = line

class ParseResult:
    func _to_string() -> String:
        return "ParseResult(node=%s, error=%s, advance_count=%d)" % [
            str(self.node) if self.node else "None",
            str(self.error) if self.error else "None",
            self.advance_count
        ]

    func to_dict() -> Dictionary:
        return {
            "node": self.node.to_dict() if self.node else null,
            "error": self.error.to_dict() if self.error else null,
            "advance_count": self.advance_count
        }

    var error: TritiumAST.InvalidSyntaxError
    var node: TritiumAST.ASTNode = null
    var advance_count = 0

    func register(res: ParseResult) -> TritiumAST.ASTNode:
        self.advance_count += res.advance_count
        if res.error:
            self.error = res.error
        return res.node

    func success(node: TritiumAST.ASTNode) -> ParseResult:
        self.node = node
        return self

    func failure(error: TritiumAST.InvalidSyntaxError) -> ParseResult:
        if not self.error or self.advance_count == 0:
            self.error = error
        return self

class InterpreterResult:
    var value: Variant
    var error: String = ""

    func _init(value: Variant = null, error: String = ""):
        self.value = value
        self.error = error

    func is_error() -> bool:
        return error != ""

    func _to_string() -> String:
        return "InterpreterResult(%s: %s)" % [
            "value" if not error else "error",
            str(value) if not error else str(error)
        ]
