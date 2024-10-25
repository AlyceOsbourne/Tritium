class_name OpCodes

static func bit_width(value: int) -> int:
    assert(value > 0, "Size must be positive and non-zero")
    return int(ceil(log(value) / log(2)))

static func encode(type: int, values: Array, linked_mapping: Dictionary, type_enum: Dictionary, operand_enum: Dictionary) -> int:
    assert(linked_mapping.has(type), "Invalid type")
    assert(values.size() == linked_mapping[type].size(), "Invalid number of values")

    var type_bits = bit_width(type_enum.size())
    var encoded = type
    var bit_offset = type_bits

    for i in range(values.size()):
        var max_value = linked_mapping[type][i].size() - 1
        var value = values[i]
        assert(value >= 0 and value <= max_value, "Value out of range")

        var num_bits = bit_width(max_value + 1)
        encoded |= (value & ((1 << num_bits) - 1)) << bit_offset
        bit_offset += num_bits

    return encoded

static func decode(value: int, linked_mapping: Dictionary, type_enum: Dictionary, operand_enum: Dictionary) -> Array:
    var type_bits = bit_width(type_enum.size())
    var type = value & ((1 << type_bits) - 1)
    var link = linked_mapping[type]

    var bit_offset = type_bits
    var decoded_values = []

    for i in range(link.size()):
        var max_value = link[i].size() - 1
        var num_bits = bit_width(max_value + 1)
        var extracted_value = (value >> bit_offset) & ((1 << num_bits) - 1)
        decoded_values.append(link[i].find_key(extracted_value))
        bit_offset += num_bits

    return [type_enum.find_key(type)] + decoded_values

enum Operations {
    STATEMENT,
    KEYWORD
}

enum Statements {
    EXPR
}

enum Keyword {

}

enum Expr {
    EXPR,
    NUMBER,
    BINOP
}

enum Number {
    INT, FLOAT
}

enum BinOp {
    ADD, SUB, MULT, DIV
}

static var linked = {
    Operations: {
        Operations.STATEMENT: [Expression],
        Operations.KEYWORD: [Keyword]
    },
    Statements: {
        Statements.EXPR: [Expr]
    },
    Expr: {
        Expr.EXPR: [Expr],
        Expr.NUMBER: [Number],
        Expr.BINOP: [BinOp]
    },
    BinOp: {
        BinOp.ADD: [Expr, Expr],
        BinOp.SUB: [Expr, Expr],
        BinOp.MULT: [Expr, Expr],
        BinOp.DIV: [Expr, Expr]
    },
    Number: {
        Number.INT: [],
        Number.FLOAT: []
    }
}
