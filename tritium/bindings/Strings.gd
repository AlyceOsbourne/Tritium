static func bind(interpreter_settings: InterpreterSettings):
    interpreter_settings.bind_function("to_upper", func(s): return s.to_upper())
    interpreter_settings.bind_function("to_lower", func(s): return s.to_lower())
    interpreter_settings.bind_function("capitalize", func(s): return s.capitalize())
    interpreter_settings.bind_function("title", func(s): return s.title())
    interpreter_settings.bind_function("strip", func(s): return s.strip())
    interpreter_settings.bind_function("lstrip", func(s): return s.lstrip())
    interpreter_settings.bind_function("rstrip", func(s): return s.rstrip())

    interpreter_settings.bind_function("replace", func(s, old, new): return s.replace(old, new))
    interpreter_settings.bind_function("split", func(s, delimiter=" "): return s.split(delimiter))
    interpreter_settings.bind_function("join", func(delimiter, iterable): return delimiter.join(iterable))
    interpreter_settings.bind_function("startswith", func(s, prefix): return s.begins_with(prefix))
    interpreter_settings.bind_function("endswith", func(s, suffix): return s.ends_with(suffix))

    interpreter_settings.bind_function("find", func(s, sub): return s.find(sub))
    interpreter_settings.bind_function("rfind", func(s, sub): return s.rfind(sub))
    interpreter_settings.bind_function("count", func(s, sub): return s.count(sub))
    interpreter_settings.bind_function("contains", func(s, sub): return s.find(sub) != -1)

    interpreter_settings.bind_function("substring", func(s, start, length=-1): return s.substr(start, length))
    interpreter_settings.bind_function("reverse", func(s): return s.reverse())
    interpreter_settings.bind_function("repeat", func(s, times): return s * times)

    interpreter_settings.bind_function("is_digit", func(s): return s.is_digit())
    interpreter_settings.bind_function("is_alpha", func(s): return s.is_alpha())
    interpreter_settings.bind_function("is_alnum", func(s): return s.is_alnum())
    interpreter_settings.bind_function("is_space", func(s): return s.is_space())

    interpreter_settings.bind_function("replace_vars", func(s, dict):
        for key in dict.keys():
            s = s.replace("{" + key + "}", str(dict[key]))
        return s
    )

    interpreter_settings.bind_function("splitlines", func(s): return s.split_lines())
    interpreter_settings.bind_function("joinlines", func(lines): return "\n".join(lines))

    interpreter_settings.bind_function("pad_left", func(s, length, char=" "): return s.pad_left(length, char))
    interpreter_settings.bind_function("pad_right", func(s, length, char=" "): return s.pad_right(length, char))

    interpreter_settings.bind_function("remove_whitespace", func(s): return s.strip().replace(" ", ""))
    interpreter_settings.bind_function("truncate", func(s, length, suffix="..."):
        return s if len(s) <= length else s.substr(0, length - len(suffix)) + suffix
    )
    interpreter_settings.bind_function("swapcase", func(s): return s.swapcase())
