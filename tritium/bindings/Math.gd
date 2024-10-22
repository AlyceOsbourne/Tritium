static func bind(interpreter_settings: InterpreterSettings):
    interpreter_settings.bind_function("lerp", func(a, b, t): return lerp(a, b, t))
    interpreter_settings.bind_function("clamp", func(value, min_val, max_val): return clamp(value, min_val, max_val))

    interpreter_settings.bind_function("deg2rad", func(deg): return deg_to_rad(deg))
    interpreter_settings.bind_function("rad2deg", func(rad): return rad_to_deg(rad))
    interpreter_settings.bind_function("abs", func(value): return abs(value))
    interpreter_settings.bind_function("sign", func(value): return sign(value))

    interpreter_settings.bind_function("min", func(a, b): return min(a, b))
    interpreter_settings.bind_function("max", func(a, b): return max(a, b))

    interpreter_settings.bind_function("distance", func(a, b): return a.distance_to(b))
    interpreter_settings.bind_function("angle", func(a, b): return a.angle_to(b))

    interpreter_settings.bind_function("randf", func(): return randf())
    interpreter_settings.bind_function("randi", func(): return randi())
    interpreter_settings.bind_function("randi_range", func(min, max): return randi_range(min, max))
    interpreter_settings.bind_function("randf_range", func(min, max): return randf_range(min, max))

    interpreter_settings.bind_function("Vec2", func(x=0, y=0): return Vector2(x, y))
    interpreter_settings.bind_function("Vec3", func(x=0, y=0, z=0): return Vector3(x, y, z))

    interpreter_settings.bind_variable("UP", Vector2.UP)
    interpreter_settings.bind_variable("DOWN", Vector2.DOWN)
    interpreter_settings.bind_variable("LEFT", Vector2.LEFT)
    interpreter_settings.bind_variable("RIGHT", Vector2.RIGHT)
    interpreter_settings.bind_variable("ZERO_VEC2", Vector2.ZERO)
    interpreter_settings.bind_variable("ONE_VEC2", Vector2.ONE)

    interpreter_settings.bind_function("Rect", func(x=0, y=0, w=0, h=0): return Rect2(x, y, w, h))

    interpreter_settings.bind_variable("PI", PI)
    interpreter_settings.bind_variable("TAU", TAU)
    interpreter_settings.bind_variable("INF", INF)

    # Additional math functions
    interpreter_settings.bind_function("pow", func(base, exp): return pow(base, exp))
    interpreter_settings.bind_function("sqrt", func(value): return sqrt(value))
    interpreter_settings.bind_function("floor", func(value): return floor(value))
    interpreter_settings.bind_function("ceil", func(value): return ceil(value))
    interpreter_settings.bind_function("round", func(value): return round(value))
    interpreter_settings.bind_function("fract", func(value): return value - floor(value))

    interpreter_settings.bind_function("sin", func(angle): return sin(angle))
    interpreter_settings.bind_function("cos", func(angle): return cos(angle))
    interpreter_settings.bind_function("tan", func(angle): return tan(angle))
    interpreter_settings.bind_function("asin", func(value): return asin(value))
    interpreter_settings.bind_function("acos", func(value): return acos(value))
    interpreter_settings.bind_function("atan", func(value): return atan(value))
    interpreter_settings.bind_function("atan2", func(y, x): return atan2(y, x))

    interpreter_settings.bind_function("log", func(value): return log(value))

    interpreter_settings.bind_function("exp", func(value): return exp(value))

    interpreter_settings.bind_function("smoothstep", func(edge0, edge1, x): return smoothstep(edge0, edge1, x))
    interpreter_settings.bind_function("inverse_lerp", func(a, b, value): return inverse_lerp(a, b, value))

    interpreter_settings.bind_function("polar2cartesian", func(radius, angle): return Vector2(cos(angle) * radius, sin(angle) * radius))
    interpreter_settings.bind_function("cartesian2polar", func(vec): return Vector2(vec.length(), atan2(vec.y, vec.x)))

    interpreter_settings.bind_function("vec2_length", func(vec): return vec.length())
    interpreter_settings.bind_function("vec3_length", func(vec): return vec.length())
    interpreter_settings.bind_function("vec2_normalized", func(vec): return vec.normalized())
    interpreter_settings.bind_function("vec3_normalized", func(vec): return vec.normalized())

    interpreter_settings.bind_function("dot", func(a, b): return a.dot(b))
    interpreter_settings.bind_function("cross", func(a, b): return a.cross(b))

    interpreter_settings.bind_function("rect_area", func(rect): return rect.size.x * rect.size.y)
    interpreter_settings.bind_function("rect_perimeter", func(rect): return 2 * (rect.size.x + rect.size.y))

    interpreter_settings.bind_function("lerp_angle", func(a, b, t): return lerp_angle(a, b, t))
    interpreter_settings.bind_function("move_toward", func(current, target, delta): return move_toward(current, target, delta))
