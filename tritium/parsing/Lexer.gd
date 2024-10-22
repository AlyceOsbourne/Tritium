class_name Lexer

enum TokenType {
    INT, FLOAT, OPERATOR, PAREN, IDENTIFIER, ASSIGNMENT, RETURN, SEMICOLON,
    FN, COMMA, CURLY_OPEN, CURLY_CLOSE, COMMENT, EOF, COMPARISON, IF, ELIF, ELSE, STRING
}

#
#x = 10;
#y = 20;
#
#fn mult(a, b){
    #return a * b;
#}
#
#fn main(){
    #print("Entered main")

    #if x < y {
        #return mult(x, y);
    #}
    #return y
#}


static func tokenize(code: String) -> Array:
    var tokens = []
    var current = 0
    var line = 1
    var is_function_definition = false

    while current < code.length():
        var char = code[current]

        if is_string(char):
            var result = handle_string(code, current, line)
            current = result[0]
            line  = result[1]
            var token = result[2]
            tokens.append(token)
            continue

        if is_number(char):
            var result = handle_number(code, current, line)
            current = result[0]
            var token = result[1]
            tokens.append(token)
            continue

        if is_whitespace(char):
            var result = handle_whitespace(char, current, line)
            current = result[0]
            line = result[1]
            continue

        if is_comment(char):
            var result = handle_comment(code, current, line)
            current = result[0]
            line = result[1]
            continue

        if is_operator(char):
            tokens.append(TritiumData.Token.new(TritiumData.TokenType.OPERATOR, char, line))
            current += 1
            continue

        if is_comparison_operator(code, current):
            var result = handle_comparison_operator(code, current, line)
            current = result[0]
            var token = result[1]
            tokens.append(token)
            continue

        if is_paren(char):
            tokens.append(TritiumData.Token.new(TritiumData.TokenType.PAREN, char, line))
            current += 1
            continue

        if is_curly_brace(char):
            if char == "{":
                is_function_definition = false
            tokens.append(TritiumData.Token.new(TritiumData.TokenType.CURLY_OPEN if char == "{" else TritiumData.TokenType.CURLY_CLOSE, char, line))
            current += 1
            continue

        if is_assignment(char):
            tokens.append(TritiumData.Token.new(TritiumData.TokenType.ASSIGNMENT, char, line))
            current += 1
            continue

        if is_semicolon(char):
            tokens.append(TritiumData.Token.new(TritiumData.TokenType.SEMICOLON, char, line))
            current += 1
            continue

        if is_comma(char):
            tokens.append(TritiumData.Token.new(TritiumData.TokenType.COMMA, char, line))
            current += 1
            continue

        if is_if_else_keyword(code, current):
            var result = handle_if_else_keyword(code, current, line)
            current = result[0]
            var token = result[1]
            tokens.append(token)
            continue

        if is_identifier_start(char):
            var result = handle_identifier_or_keyword(code, current, line, is_function_definition)
            current = result[0]
            var token = result[1]
            tokens.append(token)
            continue
        current += 1

    tokens.append(TritiumData.Token.new(TritiumData.TokenType.EOF, "", line))
    return tokens

static func is_whitespace(char: String) -> bool:
    return char == " " or char == "\t" or char == "\n"

static func handle_whitespace(char: String, current: int, line: int) -> Array:
    if char == "\n":
        line += 1
    return [current + 1, line]

static func is_comment(char: String) -> bool:
    return char == "#"

static func handle_comment(code: String, current: int, line: int) -> Array:
    while current < code.length() and code[current] != "\n":
        current += 1
    if current < code.length() and code[current] == "\n":
        line += 1
    return [current + 1, line]

static func is_number(char: String) -> bool:
    return char.is_valid_int() or char == "."

static func handle_number(code: String, current: int, line: int) -> Array:
    var num = ""
    var dot_seen = false

    while current < code.length() and (code[current].is_valid_int() or code[current] == "."):
        if code[current] == ".":
            if dot_seen:
                break
            dot_seen = true
        num += code[current]
        current += 1

    var token_type = TritiumData.TokenType.FLOAT if dot_seen else TritiumData.TokenType.INT
    return [current, TritiumData.Token.new(token_type, num, line)]

static func is_operator(char: String) -> bool:
    return char in ["+", "-", "*", "/"]

static func is_comparison_operator(code: String, current: int) -> bool:
    if current >= code.length():
        return false

    if current + 1 < code.length():
        var sub = code.substr(current, 2)
        if sub in ["==", "!=", "<=", ">="]:
            return true

    var single_char = code[current]
    return single_char in ["<", ">"]

static func handle_comparison_operator(code: String, current: int, line: int) -> Array:
    if current + 1 < code.length():
        var sub = code.substr(current, 2)
        if sub in ["==", "!=", "<=", ">="]:
            return [current + 2, TritiumData.Token.new(TritiumData.TokenType.COMPARISON, sub, line)]

    var single_char = code[current]
    return [current + 1, TritiumData.Token.new(TritiumData.TokenType.COMPARISON, single_char, line)]

static func is_paren(char: String) -> bool:
    return char in ["(", ")"]

static func is_curly_brace(char: String) -> bool:
    return char in ["{", "}"]

static func is_assignment(char: String) -> bool:
    return char == "="

static func is_semicolon(char: String) -> bool:
    return char == ";"

static func is_comma(char: String) -> bool:
    return char == ","

static func is_string(char: String) -> bool:
    return char == "'" or char == '"'

static func is_identifier_start(char: String) -> bool:
    return char.is_valid_ascii_identifier() or char == "_"

static func handle_identifier_or_keyword(code: String, current: int, line: int, is_function_definition: bool) -> Array:
    var identifier = ""
    while current < code.length() and (code[current].is_valid_ascii_identifier() or code[current].is_valid_int() or code[current] == "_"):
        identifier += code[current]
        current += 1

    if identifier == "fn":
        is_function_definition = true
        return [current, TritiumData.Token.new(TritiumData.TokenType.FN, identifier, line)]
    elif identifier == "return":
        return [current, TritiumData.Token.new(TritiumData.TokenType.RETURN, identifier, line)]
    else:
        return [current, TritiumData.Token.new(TritiumData.TokenType.IDENTIFIER, identifier, line)]

static func is_if_else_keyword(code: String, current: int) -> bool:
    if current >= code.length():
        return false

    var keywords = ["if", "elif", "else"]
    for keyword in keywords:
        if current + keyword.length() <= code.length():
            if code.substr(current, keyword.length()) == keyword and not code[current + keyword.length()].is_valid_ascii_identifier():
                return true
    return false

static func handle_if_else_keyword(code: String, current: int, line: int) -> Array:
    var keywords = {
        "if": TritiumData.TokenType.IF,
        "elif": TritiumData.TokenType.ELIF,
        "else": TritiumData.TokenType.ELSE
    }
    for keyword in keywords.keys():
        if code.substr(current, keyword.length()) == keyword:
            return [current + keyword.length(), TritiumData.Token.new(keywords[keyword], keyword, line)]
    return [current, null]

static func handle_string(code: String, current: int, line: int) -> Array:
    var string_delimiter = code[current]
    var string_content = ""
    current += 1
    while current < code.length():
        var char = code[current]
        if char == "\\" and current + 1 < code.length():
            string_content += code[current] + code[current + 1]
            current += 2
            continue
        if char == string_delimiter:
            current += 1
            return [current, line, TritiumData.Token.new(TritiumData.TokenType.STRING, string_content, line)]
        string_content += char
        current += 1
    return [current, line, TritiumData.Token.new(TritiumData.TokenType.STRING, string_content, line)]
