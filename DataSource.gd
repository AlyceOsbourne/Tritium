class_name DataSource
extends Resource

func get_report() -> Dictionary:
    var reported = {}
    for key in self.call("reportable"):
        var value = self[key]
        if value is DataSource:
            value = value.report()
        reported[key] = value
    return reported

func get_reportable() -> PackedStringArray:
    return []
