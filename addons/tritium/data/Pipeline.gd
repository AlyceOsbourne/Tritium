class_name Pipeline

static func input(data: Variant) -> Variant:
    if data is Dictionary: return DictionaryType.new(data)
    if data is Array and (data as Array).is_read_only(): return Tuple.new(data)
    if data is Array: return ArrayType.new(data)
    return data

static func output(data: Variant) -> Variant:
    if data is DictionaryType: return data._dict
    if data is Tuple: return data.elements
    if data is ArrayType: return data._array
    return data
