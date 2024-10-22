class_name ArrayUtils

static func bind(interpreter_settings: InterpreterSettings):
    interpreter_settings.bind_function("append", func(array, value):
        array.append(value)
        return array
    )

    interpreter_settings.bind_function("extend", func(array, iterable):
        array.extend(iterable)
        return array
    )

    interpreter_settings.bind_function("insert", func(array, index, value):
        array.insert(index, value)
        return array
    )

    interpreter_settings.bind_function("remove", func(array, value):
        array.erase(value)
        return array
    )

    interpreter_settings.bind_function("pop", func(array, index=-1):
        return array.pop(index)
    )

    interpreter_settings.bind_function("index", func(array, value):
        return array.find(value)
    )

    interpreter_settings.bind_function("count", func(array, value):
        var count = 0
        for element in array:
            if element == value:
                count += 1
        return count
    )

    interpreter_settings.bind_function("reverse", func(array):
        array.reverse()
        return array
    )

    interpreter_settings.bind_function("sort", func(array, key=null, reverse=false):
        array.sort()
        if reverse:
            array.reverse()
        return array
    )

    interpreter_settings.bind_function("clear", func(array):
        array.clear()
        return array
    )

    interpreter_settings.bind_function("copy", func(array):
        return array.duplicate()
    )

    interpreter_settings.bind_function("contains", func(array, value):
        return value in array
    )

    interpreter_settings.bind_function("flatten", func(array):
        var result = []
        for element in array:
            if typeof(element) == TYPE_ARRAY:
                result.extend(element)
            else:
                result.append(element)
        return result
    )

    interpreter_settings.bind_function("unique", func(array):
        var result = []
        for element in array:
            if element not in result:
                result.append(element)
        return result
    )

    interpreter_settings.bind_function("fill", func(array, value):
        for i in range(array.size()):
            array[i] = value
        return array
    )

    interpreter_settings.bind_function("slice", func(array, start, end=-1):
        return array.slice(start, end)
    )

    interpreter_settings.bind_function("join", func(array, delimiter=","):
        return delimiter.join(array.map(str))
    )
