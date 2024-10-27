class Module extends DataSource:

    var name = "Bob"

    func reportable() -> PackedStringArray:
        return ["name"]

    func _to_string():
        return name
