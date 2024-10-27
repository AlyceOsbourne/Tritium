class_name ArrayType
extends RefCounted

var _array: Array = []

func _init(initial_values: Array = []):
    _array = initial_values.duplicate()

func size() -> int:
    return _array.size()

func append(value):
    _array.append(value)
    return self

func clear():
    _array.clear()
    return self

func has(value) -> bool:
    return _array.has(value)

func get_at(idx: int):
    return _array[idx]

func set_at(idx: int, value):
    _array[idx] = value
    return self

func remove_at(idx: int):
    _array.remove_at(idx)
    return self

func find(value) -> int:
    return _array.find(value)

func insert(idx: int, value):
    _array.insert(idx, value)
    return self

func slice(begin: int, end: int, step: int = 1) -> Array:
    return _array.slice(begin, end, step)

func pop():
    return _array.pop_back()

func duplicate() -> Array:
    return _array.duplicate()

func reverse():
    _array.reverse()

func sort():
    _array.sort()
    return self

func _to_string() -> String:
    return str(_array)
