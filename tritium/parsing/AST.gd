class_name AST

class Parser:
    func function_call(func_name: TritiumData.Token) -> TritiumData.ParseResult:
        var res = TritiumData.ParseResult.new()
        var args = []

        if self.current_token.type != TritiumData.TokenType.PAREN or self.current_token.value != "(":
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '('"))
        self.advance()

        if self.current_token.type != TritiumData.TokenType.PAREN or self.current_token.value != ")":
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

        if self.current_token.type != TritiumData.TokenType.PAREN or self.current_token.value != ")":
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
        if not res.error and self.current_token.type != TritiumData.TokenType.EOF:
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

        return res.success(TritiumAST.StatementsNode.new(statements))

    func statement() -> TritiumData.ParseResult:
        var res = TritiumData.ParseResult.new()
        if self.current_token.type == TritiumData.TokenType.FN:
            var node = res.register(self.function_definition())
            if res.error:
                return res
            return res.success(node)
        elif self.current_token.type == TritiumData.TokenType.RETURN:
            var node = res.register(self.return_statement())
            if res.error:
                return res
            if self.current_token.type == TritiumData.TokenType.SEMICOLON:
                self.advance()
            return res.success(node)
        elif self.current_token.type == TritiumData.TokenType.IF:
            var node = res.register(self.if_statement())
            if res.error:
                return res
            return res.success(node)
        elif self.current_token.type == TritiumData.TokenType.IDENTIFIER:
            var identifier_token = self.current_token
            self.advance()

            if self.current_token.type == TritiumData.TokenType.ASSIGNMENT:
                self.advance()
                var expr = res.register(self.expression())
                if res.error:
                    return res
                if self.current_token.type == TritiumData.TokenType.SEMICOLON:
                    self.advance()
                return res.success(TritiumAST.AssignmentNode.new(identifier_token, expr))
            else:
                self.token_idx -= 1  # Rewind to reprocess as an expression
                self.current_token = self.tokens[self.token_idx]
                var node = res.register(self.expression())
                if res.error:
                    return res
                if self.current_token.type == TritiumData.TokenType.SEMICOLON:
                    self.advance()
                return res.success(node)
        else:
            var node = res.register(self.expression())
            if res.error:
                return res
            if self.current_token.type == TritiumData.TokenType.SEMICOLON:
                self.advance()
            return res.success(node)

    func if_statement() -> TritiumData.ParseResult:
        var res = TritiumData.ParseResult.new()

        if self.current_token.type != TritiumData.TokenType.IF:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected 'if'"))
        self.advance()

        if self.current_token.type != TritiumData.TokenType.PAREN:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '(' after 'if'"))
        self.advance()

        var condition = res.register(self.expression())  # Use expression to parse conditions
        if res.error:
            return res

        if self.current_token.type != TritiumData.TokenType.PAREN:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected ')' after condition"))
        self.advance()  # Advance after ')'

        # Expect '{' to start 'if' body
        if self.current_token.type != TritiumData.TokenType.CURLY_OPEN:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '{' to start 'if' body"))
        self.advance()  # Advance after '{'

        # Parse 'if' body
        var body = res.register(self.statements())
        if res.error:
            return res

        # Expect '}' to end 'if' body
        if self.current_token.type != TritiumData.TokenType.CURLY_CLOSE:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '}' to end 'if' body"))
        self.advance()  # Advance after '}'


        # Optional 'elif' and 'else' block handling
        var elif_cases: Array[Dictionary] = []
        while self.current_token.type == TritiumData.TokenType.ELIF:
            self.advance()  # Advance after 'elif'

            # Expect '(' after 'elif'
            if self.current_token.type != TritiumData.TokenType.PAREN or self.current_token.value != "(":
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '(' after 'if'"))
            self.advance()  # Advance after '('

            # Parse the condition
            var elif_condition = res.register(self.expression())
            if res.error:
                return res

            # Expect ')' after condition
            if self.current_token.type != TritiumData.TokenType.PAREN or self.current_token.value != ")":
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected ')' after condition"))
            self.advance()  # Advance after ')'

            # Expect '{' to start 'if' body
            if self.current_token.type != TritiumData.TokenType.CURLY_OPEN:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '{' to start 'if' body"))
            self.advance()  # Advance after '{'

            # Parse 'elif' body
            var elif_body = res.register(self.statements())
            if res.error:
                return res

            # Expect '}' to end 'if' body
            if self.current_token.type != TritiumData.TokenType.CURLY_CLOSE:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '}' to end 'if' body"))
            self.advance()  # Advance after '}'


            elif_cases.append({
                "condition": elif_condition,
                "body": elif_body
            })

        var else_case = null
        if self.current_token.type == TritiumData.TokenType.ELSE:
            self.advance()  # Advance after 'else'

            # Expect '{' to start 'else' body
            if self.current_token.type != TritiumData.TokenType.CURLY_OPEN:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '{' to start 'else' body"))
            self.advance()  # Advance after '{'

            # Parse 'else' body
            else_case = res.register(self.statements())
            if res.error:
                return res

            # Expect '}' to end 'else' body
            if self.current_token.type != TritiumData.TokenType.CURLY_CLOSE:
                return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '}' to end 'else' body"))
            self.advance()  # Advance after '}'

        return res.success(TritiumAST.IfNode.new(condition, body, elif_cases, else_case))

    func function_definition() -> TritiumData.ParseResult:
        var res = TritiumData.ParseResult.new()
        if self.current_token.type != TritiumData.TokenType.FN:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected 'fn'"))
        self.advance()

        if self.current_token.type != TritiumData.TokenType.IDENTIFIER:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected function name"))
        var func_name = self.current_token
        self.advance()

        if self.current_token.type != TritiumData.TokenType.PAREN or self.current_token.value != "(":
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '('"))
        self.advance()

        var arg_names = []
        if self.current_token.type == TritiumData.TokenType.IDENTIFIER:
            arg_names.append(self.current_token)
            self.advance()
            while self.current_token.type == TritiumData.TokenType.COMMA:
                self.advance()
                if self.current_token.type != TritiumData.TokenType.IDENTIFIER:
                    return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected identifier"))
                arg_names.append(self.current_token)
                self.advance()

        if self.current_token.type != TritiumData.TokenType.PAREN or self.current_token.value != ")":
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected ')'"))
        self.advance()

        if self.current_token.type != TritiumData.TokenType.CURLY_OPEN:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '{'"))
        self.advance()

        var body = res.register(self.statements())
        if res.error:
            return res

        if self.current_token.type != TritiumData.TokenType.CURLY_CLOSE:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected '}'"))
        self.advance()

        return res.success(TritiumAST.FunctionDefNode.new(func_name, arg_names, body))

    func return_statement() -> TritiumData.ParseResult:
        var res = TritiumData.ParseResult.new()
        if self.current_token.type != TritiumData.TokenType.RETURN:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected 'return'"))
        self.advance()

        var expr = res.register(self.expression())
        if res.error:
            return res

        if self.current_token.type == TritiumData.TokenType.SEMICOLON:
            self.advance()

        return res.success(TritiumAST.ReturnNode.new(expr))

    func expression() -> TritiumData.ParseResult:
        var res = TritiumData.ParseResult.new()
        var left = res.register(self.comparison())
        if res.error:
            return res

        while self.current_token.type == TritiumData.TokenType.OPERATOR and self.current_token.value in ["and", "or", "==", "<=", ">=", "==", "!=", "<", ">"]:
            var op_token = self.current_token
            self.advance()
            var right = res.register(self.comparison())
            if res.error:
                return res

            left = TritiumAST.BinOpNode.new(left, op_token, right)

        return res.success(left)

    func comparison() -> TritiumData.ParseResult:
        # Handles comparison operators ('==', '!=', '>', '<', '>=', '<=')
        var res = TritiumData.ParseResult.new()
        var left = res.register(self.additive())
        if res.error:
            return res

        while self.current_token.type == TritiumData.TokenType.COMPARISON:
            var op_token = self.current_token
            self.advance()
            var right = res.register(self.additive())
            if res.error:
                return res

            left = TritiumAST.ComparisonNode.new(left, op_token, right)

        return res.success(left)

    func additive() -> TritiumData.ParseResult:
        # Handles addition and subtraction ('+', '-')
        var res = TritiumData.ParseResult.new()
        var left = res.register(self.multiplicative())
        if res.error:
            return res

        while self.current_token.type == TritiumData.TokenType.OPERATOR and self.current_token.value in ["+", "-"]:
            var op_token = self.current_token
            self.advance()
            var right = res.register(self.multiplicative())
            if res.error:
                return res

            left = TritiumAST.BinOpNode.new(left, op_token, right)

        return res.success(left)

    func multiplicative() -> TritiumData.ParseResult:
        # Handles multiplication and division ('*', '/')
        var res = TritiumData.ParseResult.new()
        var left = res.register(self.factor())
        if res.error:
            return res

        while self.current_token.type == TritiumData.TokenType.OPERATOR and self.current_token.value in ["*", "/"]:
            var op_token = self.current_token
            self.advance()
            var right = res.register(self.factor())
            if res.error:
                return res

            left = TritiumAST.BinOpNode.new(left, op_token, right)

        return res.success(left)

    func factor() -> TritiumData.ParseResult:
        # Handles literals, variables, parentheses, function calls
        var res = TritiumData.ParseResult.new()
        var token = self.current_token

        if token.type == TritiumData.TokenType.PAREN and token.value == "(":
            self.advance()
            var expr = res.register(self.expression())
            if res.error:
                return res
            if self.current_token.type != TritiumData.TokenType.PAREN or self.current_token.value != ")":
                return res.failure(TritiumAST.InvalidSyntaxError.new(token.line, "Expected ')'"))
            self.advance()
            return res.success(expr)
        elif token.type == TritiumData.TokenType.INT or token.type == TritiumData.TokenType.FLOAT:
            self.advance()
            return res.success(TritiumAST.NumberNode.new(token))
        elif token.type == TritiumData.TokenType.STRING:
            self.advance()
            return res.success(TritiumAST.StringNode.new(token))
        elif token.type == TritiumData.TokenType.IDENTIFIER:
            self.advance()
            var node: TritiumAST.ASTNode
            if self.current_token.type == TritiumData.TokenType.PAREN and self.current_token.value == "(":
                node = res.register(self.function_call(token))
            else:
                node = TritiumAST.VarAccessNode.new(token)

            # Handle attribute access if there's a DOT
            while self.current_token.type == TritiumData.TokenType.DOT:
                self.advance()
                node = res.register(self.attribute_access(node))
                if res.error:
                    return res

            return res.success(node)

        return res.failure(TritiumAST.InvalidSyntaxError.new(token.line, "Unexpected token '%s'" % token.value))


    func attribute_access(left: TritiumAST.ASTNode) -> TritiumData.ParseResult:
        var res = TritiumData.ParseResult.new()

        if self.current_token.type != TritiumData.TokenType.IDENTIFIER:
            return res.failure(TritiumAST.InvalidSyntaxError.new(self.current_token.line, "Expected identifier after '.'"))

        var attribute_name = self.current_token
        self.advance()

        # Check if the attribute is a function call
        if self.current_token.type == TritiumData.TokenType.PAREN and self.current_token.value == "(":
            var function_call_node = res.register(self.function_call(attribute_name))
            if res.error:
                return res
            return res.success(TritiumAST.AttributeAccessNode.new(left, function_call_node))

        # Otherwise, it's a simple attribute access
        return res.success(TritiumAST.AttributeAccessNode.new(left, TritiumAST.VarAccessNode.new(attribute_name)))


static func parse(lexed_result: TritiumData.LexerResult) -> TritiumData.ParseResult:
    if lexed_result.error:
        return TritiumData.ParseResult.new().failure(TritiumAST.InvalidSyntaxError.new(lexed_result.line, "Invalid Token Error"))
    var parser = Parser.new(lexed_result.tokens)
    return parser.parse()
