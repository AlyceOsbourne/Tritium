class_name Result

var value: Variant
var error: Variant = null

func _eq(x):
    if x is int:
        if x == OK and error == null:
            return true
        elif x == FAILED and error != null:
            return true
    elif x is Result:
        return x == self
    return false

func _eqr(x):
    if x is int:
        if x == OK and error == null:
            return true
        elif x == FAILED and error != null:
            return true
    elif x is Result:
        return x == self
    return false

func _init(value=null, error=null) -> void:
    self.value = value
    self.error = error

static func SUCCESS(v=null):
    return Result.new(v)

static func FAIL(v=""):
    return Result.new(null, v)

func _to_string() -> String:
    return "Result(%s)" % str(error if error else value if value else "")
