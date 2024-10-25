class_name AST

class Parser:
    func function_call(func_name: TritiumData.Token) -> TritiumData.ParseResult:
        var res = TritiumData.ParseResult.new()
        var args = []

        if not self.expect_token(TritiumData.TokenType.PAREN, "("):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '('"))
        self.advance()

        if not self.expect_token(TritiumData.TokenType.PAREN, ")"):
            var arg = res.register(self.expression())
            if res.error:
                return res
            args.append(arg)

            while self.current_token.type == TritiumData.TokenType.COMMA:
                self.advance()
                arg = res.register(self.expression())
                if res.error:
                    return res
                args.append(arg)

        if not self.expect_token(TritiumData.TokenType.PAREN, ")"):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected ')'"))
        self.advance()

        return res.success(TritiumAST.FunctionCallNode.new(func_name, args))

    func _to_string() -> String:
        return "Parser(current_token: %s, token_idx: %d)" % [self.current_token._to_string(), self.token_idx]

    var tokens: Array
    var token_idx: int
    var current_token: TritiumData.Token

    func _init(tokens: Array):
        self.tokens = tokens
        self.token_idx = -1
        self.advance()

    func advance() -> TritiumData.Token:
        self.token_idx += 1
        if self.token_idx < self.tokens.size():
            self.current_token = self.tokens[self.token_idx]
        return self.current_token

    func parse() -> TritiumData.ParseResult:
        var res = self.statements()
        if res.error or res.node == null:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid or empty AST"))
        if self.current_token.type != TritiumData.TokenType.EOF:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Unexpected token '%s'" % self.current_token.value))
        return res

    func statements() -> TritiumData.ParseResult:
        var res = TritiumData.ParseResult.new()
        var statements = []

        while self.current_token.type != TritiumData.TokenType.EOF and self.current_token.type != TritiumData.TokenType.CURLY_CLOSE:
            var statement = res.register(self.statement())
            if res.error:
                return res
            statements.append(statement)

        if statements.is_empty():
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected at least one statement"))

        return res.success(TritiumAST.StatementsNode.new(statements))

    func statement() -> TritiumData.ParseResult:
        var res = TritiumData.ParseResult.new()
        if self.current_token.type == TritiumData.TokenType.FN:
            var node = res.register(self.function_definition())
            if res.error or node == null:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid function definition"))
            return res.success(node)
        elif self.current_token.type == TritiumData.TokenType.RETURN:
            self.advance()
            if self.current_token.type == TritiumData.TokenType.SEMICOLON:
                self.consume_token(TritiumData.TokenType.SEMICOLON)
                return res.success(TritiumAST.ReturnNode.new(null))
            var node = res.register(self.expression())
            if res.error or node == null:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid return statement"))
            self.consume_token(TritiumData.TokenType.SEMICOLON)
            return res.success(TritiumAST.ReturnNode.new(node))
        elif self.current_token.type == TritiumData.TokenType.IF:
            var node = res.register(self.if_statement())
            if res.error or node == null:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid if statement"))
            return res.success(node)
        elif self.current_token.type == TritiumData.TokenType.FOR:
            var node = res.register(self.for_loop_statement())
            if res.error or node == null:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid for loop statement"))
            return res.success(node)
        elif self.current_token.type == TritiumData.TokenType.BREAK:
            self.advance()
            self.consume_token(TritiumData.TokenType.SEMICOLON)
            return res.success(TritiumAST.BreakNode.new())
        elif self.current_token.type == TritiumData.TokenType.CONTINUE:
            self.advance()
            self.consume_token(TritiumData.TokenType.SEMICOLON)
            return res.success(TritiumAST.ContinueNode.new())
        elif self.current_token.type == TritiumData.TokenType.IDENTIFIER:
            var identifier_token = self.current_token
            self.advance()

            if self.current_token.type == TritiumData.TokenType.DOT:
                # Attribute access detected, disallow assignment after attribute access
                self.rewind()
                var node = res.register(self.expression())
                if res.error or node == null:
                    return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid attribute access expression"))
                self.consume_token(TritiumData.TokenType.SEMICOLON)
                return res.success(node)

            if self.current_token.type == TritiumData.TokenType.ASSIGNMENT:
                self.advance()
                var expr = res.register(self.expression())
                if res.error or expr == null:
                    return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid assignment expression"))
                self.consume_token(TritiumData.TokenType.SEMICOLON)
                return res.success(TritiumAST.AssignmentNode.new(identifier_token, expr))
            else:
                self.rewind()
                var node = res.register(self.expression())
                if res.error or node == null:
                    return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid expression"))
                self.consume_token(TritiumData.TokenType.SEMICOLON)
                return res.success(node)
        else:
            var node = res.register(self.expression())
            if res.error or node == null:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid expression"))
            self.consume_token(TritiumData.TokenType.SEMICOLON)
            return res.success(node)

    func if_statement() -> TritiumData.ParseResult:
        var res = TritiumData.ParseResult.new()

        if not self.expect_token(TritiumData.TokenType.IF):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected 'if'"))
        self.advance()

        if not self.expect_token(TritiumData.TokenType.PAREN):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '(' after 'if'"))
        self.advance()

        var condition = res.register(self.expression())
        if res.error or condition == null:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid condition in 'if' statement"))

        if not self.expect_token(TritiumData.TokenType.PAREN):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected ')' after condition"))
        self.advance()

        if not self.expect_token(TritiumData.TokenType.CURLY_OPEN):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '{' to start 'if' body"))
        self.advance()

        var body = res.register(self.statements())
        if res.error or body == null:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid body in 'if' statement"))

        if not self.expect_token(TritiumData.TokenType.CURLY_CLOSE):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '}' to end 'if' body"))
        self.advance()

        var elif_cases: Array[Dictionary] = []
        while self.current_token.type == TritiumData.TokenType.ELIF:
            self.advance()

            if not self.expect_token(TritiumData.TokenType.PAREN, "("):
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '(' after 'elif'"))
            self.advance()

            var elif_condition = res.register(self.expression())
            if res.error or elif_condition == null:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid condition in 'elif' statement"))

            if not self.expect_token(TritiumData.TokenType.PAREN, ")"):
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected ')' after condition"))
            self.advance()

            if not self.expect_token(TritiumData.TokenType.CURLY_OPEN):
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '{' to start 'elif' body"))
            self.advance()

            var elif_body = res.register(self.statements())
            if res.error or elif_body == null:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid body in 'elif' statement"))

            if not self.expect_token(TritiumData.TokenType.CURLY_CLOSE):
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '}' to end 'elif' body"))
            self.advance()

            elif_cases.append({
                "condition": elif_condition,
                "body": elif_body
            })

        var else_case = null
        if self.current_token.type == TritiumData.TokenType.ELSE:
            self.advance()

            if not self.expect_token(TritiumData.TokenType.CURLY_OPEN):
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '{' to start 'else' body"))
            self.advance()

            else_case = res.register(self.statements())
            if res.error or else_case == null:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid body in 'else' statement"))

            if not self.expect_token(TritiumData.TokenType.CURLY_CLOSE):
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '}' to end 'else' body"))
            self.advance()

        return res.success(TritiumAST.IfNode.new(condition, body, elif_cases, else_case))

    func for_loop_statement() -> TritiumData.ParseResult:
        var res = TritiumData.ParseResult.new()

        if not self.expect_token(TritiumData.TokenType.FOR):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected 'for'"))
        self.advance()

        if not self.expect_token(TritiumData.TokenType.PAREN, "("):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '(' after 'for'"))
        self.advance()

        if not self.expect_token(TritiumData.TokenType.IDENTIFIER):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected identifier in 'for' loop"))
        var identifier = TritiumAST.VarAccessNode.new(self.current_token)
        self.advance()

        if not self.expect_token(TritiumData.TokenType.IN):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected 'in' after identifier in 'for' loop"))
        self.advance()

        var iterable = res.register(self.expression())
        if res.error or iterable == null:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid iterable in 'for' loop"))

        if not self.expect_token(TritiumData.TokenType.PAREN, ")"):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected ')' after iterable in 'for' loop"))
        self.advance()

        if not self.expect_token(TritiumData.TokenType.CURLY_OPEN):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '{' to start 'for' loop body"))
        self.advance()

        var body = res.register(self.statements())
        if res.error or body == null:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid body in 'for' loop"))

        if not self.expect_token(TritiumData.TokenType.CURLY_CLOSE):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '}' to end 'for' loop body"))
        self.advance()

        return res.success(TritiumAST.ForLoopNode.new(identifier, iterable, body))

    func function_definition() -> TritiumData.ParseResult:
        var res = TritiumData.ParseResult.new()
        if not self.expect_token(TritiumData.TokenType.FN):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected 'fn'"))
        self.advance()

        if not self.expect_token(TritiumData.TokenType.IDENTIFIER):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected function name"))
        var func_name = self.current_token
        self.advance()

        if not self.expect_token(TritiumData.TokenType.PAREN, "("):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '('"))
        self.advance()

        var arg_names = []
        if self.current_token.type == TritiumData.TokenType.IDENTIFIER:
            arg_names.append(self.current_token)
            self.advance()
            while self.current_token.type == TritiumData.TokenType.COMMA:
                self.advance()
                if not self.expect_token(TritiumData.TokenType.IDENTIFIER):
                    return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected identifier"))
                arg_names.append(self.current_token)
                self.advance()

        if not self.expect_token(TritiumData.TokenType.PAREN, ")"):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected ')'"))
        self.advance()

        if not self.expect_token(TritiumData.TokenType.CURLY_OPEN):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '{'"))
        self.advance()

        var body = res.register(self.statements())
        if res.error or body == null:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid function body"))

        if not self.expect_token(TritiumData.TokenType.CURLY_CLOSE):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '}'"))
        self.advance()

        return res.success(TritiumAST.FunctionDefNode.new(func_name, arg_names, body))

    func return_statement() -> TritiumData.ParseResult:
        var res = TritiumData.ParseResult.new()
        if not self.expect_token(TritiumData.TokenType.RETURN):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected 'return'"))
        self.advance()

        var expr = res.register(self.expression())
        if res.error or expr == null:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid return expression"))

        self.consume_token(TritiumData.TokenType.SEMICOLON)
        return res.success(TritiumAST.ReturnNode.new(expr))

    func data_structure() -> TritiumData.ParseResult:
        var res = TritiumData.ParseResult.new()
        var elements = []
        var data_type = ""

        if self.current_token.type == TritiumData.TokenType.SQUARE_OPEN:
            data_type = "Array"
            self.advance()
        elif self.current_token.type == TritiumData.TokenType.CURLY_OPEN:
            data_type = "Set"
            self.advance()
        elif self.current_token.type == TritiumData.TokenType.PAREN:
            data_type = "Tuple"
            self.advance()
        else:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '[' or '{' or '(' for data structure"))

        if self.current_token.type not in [TritiumData.TokenType.SQUARE_CLOSE, TritiumData.TokenType.CURLY_CLOSE, TritiumData.TokenType.PAREN]:
            var element = res.register(self.expression())
            if res.error or element == null:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid element in data structure"))
            elements.append(element)

            while self.current_token.type == TritiumData.TokenType.COMMA:
                self.advance()
                element = res.register(self.expression())
                if res.error or element == null:
                    return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid element in data structure"))
                elements.append(element)

        if not self.expect_token(self.get_closing_token(data_type)):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '%s'" % self.get_closing_token(data_type)))
        self.advance()

        return res.success(TritiumAST.DataStructureNode.new(data_type, elements))

    func expression() -> TritiumData.ParseResult:
        var res = TritiumData.ParseResult.new()
        var left = res.register(self.comparison())
        if res.error or left == null:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid comparison expression"))

        while self.current_token.type == TritiumData.TokenType.OPERATOR and self.current_token.value in ["and", "or", "==", "<=", ">=", "==", "!=", "<", ">"]:
            var op_token = self.current_token
            self.advance()
            var right = res.register(self.comparison())
            if res.error or right == null:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid comparison expression"))

            left = TritiumAST.BinOpNode.new(left, op_token, right)

        # Handle attribute access if there's a DOT
        while self.current_token.type == TritiumData.TokenType.DOT:
            self.advance()
            left = res.register(self.attribute_access(left))
            if res.error or left == null:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid attribute access"))

        return res.success(left)

    func comparison() -> TritiumData.ParseResult:
        # Handles comparison operators ('==', '!=', '>', '<', '>=', '<=')
        var res = TritiumData.ParseResult.new()
        var left = res.register(self.additive())
        if res.error or left == null:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid additive expression"))

        while self.current_token.type == TritiumData.TokenType.COMPARISON:
            var op_token = self.current_token
            self.advance()
            var right = res.register(self.additive())
            if res.error or right == null:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid additive expression"))

            left = TritiumAST.ComparisonNode.new(left, op_token, right)

        return res.success(left)

    func additive() -> TritiumData.ParseResult:
        # Handles addition and subtraction ('+', '-')
        var res = TritiumData.ParseResult.new()
        var left = res.register(self.multiplicative())
        if res.error or left == null:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid multiplicative expression"))

        while self.current_token.type == TritiumData.TokenType.OPERATOR and self.current_token.value in ["+", "-"]:
            var op_token = self.current_token
            self.advance()
            var right = res.register(self.multiplicative())
            if res.error or right == null:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid multiplicative expression"))

            left = TritiumAST.BinOpNode.new(left, op_token, right)

        return res.success(left)

    func multiplicative() -> TritiumData.ParseResult:
        # Handles multiplication and division ('*', '/')
        var res = TritiumData.ParseResult.new()
        var left = res.register(self.factor())
        if res.error or left == null:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid factor expression"))

        while self.current_token.type == TritiumData.TokenType.OPERATOR and self.current_token.value in ["*", "/"]:
            var op_token = self.current_token
            self.advance()
            var right = res.register(self.factor())
            if res.error or right == null:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid factor expression"))

            left = TritiumAST.BinOpNode.new(left, op_token, right)

        return res.success(left)

    func factor() -> TritiumData.ParseResult:
        var res = TritiumData.ParseResult.new()
        var token = self.current_token
        var node

        if token.type == TritiumData.TokenType.OPERATOR and token.value in ["+", "-"]:
            self.advance()
            var operand = res.register(self.factor())
            if res.error or operand == null:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid unary operation"))
            node = TritiumAST.UnaryOpNode.new(token, operand)
        elif token.type == TritiumData.TokenType.PAREN and token.value == "(":
            self.advance()
            var expr = res.register(self.expression())
            if res.error or expr == null:
                return res.failure(TritiumAST.InvalidSyntaxError.new(token.line, "Invalid expression in parentheses"))
            if not self.expect_token(TritiumData.TokenType.PAREN, ")"):
                return res.failure(TritiumAST.InvalidSyntaxError.new(token.line, "Expected ')'"))
            self.advance()
            node = expr
        elif token.type == TritiumData.TokenType.INT or token.type == TritiumData.TokenType.FLOAT:
            self.advance()
            node = TritiumAST.NumberNode.new(token)
        elif token.type == TritiumData.TokenType.STRING:
            self.advance()
            node = TritiumAST.StringNode.new(token)
        elif token.type == TritiumData.TokenType.IDENTIFIER:
            self.advance()
            if self.current_token.type == TritiumData.TokenType.PAREN and self.current_token.value == "(":
                node = res.register(self.function_call(token))
                if res.error or node == null:
                    return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid function call"))
            else:
                node = TritiumAST.VarAccessNode.new(token)

            while self.current_token.type == TritiumData.TokenType.DOT:
                self.advance()
                node = res.register(self.attribute_access(node))
                if res.error or node == null:
                    return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid attribute access"))

            return res.success(node)
        elif token.type in [TritiumData.TokenType.SQUARE_OPEN, TritiumData.TokenType.CURLY_OPEN, TritiumData.TokenType.PAREN]:
            node = res.register(self.data_structure())
            if res.error or node == null:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid data structure"))

        while self.current_token.type == TritiumData.TokenType.DOT:
            self.advance()
            node = res.register(self.attribute_access(node))
            if res.error or node == null:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid attribute access"))

        return res.success(node)


    func attribute_access(left: TritiumAST.ASTNode) -> TritiumData.ParseResult:
        var res = TritiumData.ParseResult.new()

        if not self.expect_token(TritiumData.TokenType.IDENTIFIER):
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected identifier after '.'"))

        var attribute_name = self.current_token
        self.advance()

        if self.current_token.type == TritiumData.TokenType.PAREN and self.current_token.value == "(":
            var function_call_node = res.register(self.function_call(attribute_name))
            if res.error or function_call_node == null:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Invalid function call in attribute access"))
            return res.success(TritiumAST.AttributeAccessNode.new(left, function_call_node))

        return res.success(TritiumAST.AttributeAccessNode.new(left, TritiumAST.VarAccessNode.new(attribute_name)))

    func expect_token(token_type: TritiumData.TokenType, value: String = "") -> bool:
        return self.current_token.type == token_type and (not value or self.current_token.value == value)

    func consume_token(token_type: TritiumData.TokenType):
        if self.current_token.type == token_type:
            self.advance()

    func rewind():
        self.token_idx -= 1
        self.current_token = self.tokens[self.token_idx]

    func get_closing_token(data_type: String) -> TritiumData.TokenType:
        match data_type:
            "Array":
                return TritiumData.TokenType.SQUARE_CLOSE
            "Set":
                return TritiumData.TokenType.CURLY_CLOSE
            "Tuple":
                return TritiumData.TokenType.PAREN
            _:
                return TritiumData.TokenType.INVALID

static func parse(lexed_result: TritiumData.LexerResult) -> TritiumData.ParseResult:
    if lexed_result.error:
        return TritiumData.ParseResult.new().failure(TritiumAST.InvalidSyntaxError.new(lexed_result.line, "Invalid Token Error"))
    var parser = Parser.new(lexed_result.tokens)
    var result = parser.parse()
    if result.error or result.node == null:
        return TritiumData.ParseResult.new().failure(TritiumAST.InvalidSyntaxError.new(lexed_result.line, "Invalid or empty AST"))
    return result
