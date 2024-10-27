class_name DictionaryType
extends RefCounted

var _dict: Dictionary = {}

func _init(initial_values: Dictionary = {}):
    _dict = initial_values.duplicate()

func size() -> int:
    return _dict.size()

func clear():
    _dict.clear()
    return self

func has(key) -> bool:
    return _dict.has(key)

func fetch(key, default_value = null):
    return _dict.get(key, default_value)

func assign(key, value):
    _dict[key] = value
    return self

func keys() -> Array:
    return _dict.keys()

func values() -> Array:
    return _dict.values()

func erase(key):
    if _dict.has(key):
        _dict.erase(key)
    return self

func duplicate() -> Dictionary:
    return _dict.duplicate()

func merge(other_dict: Dictionary, overwrite: bool = false):
    _dict.merge(other_dict, overwrite)
    return self

func pop(key):
    if _dict.has(key):
        var value = _dict[key]
        _dict.erase(key)
        return value
    return null

func _to_string() -> String:
    return str(_dict)

func is_empty() -> bool:
    return _dict.size() == 0
