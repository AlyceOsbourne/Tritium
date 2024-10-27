class_name Tuple
extends RefCounted

var elements: Array
var hash: int

func _init(elements = []):
    self.elements = elements
    self.elements.make_read_only()
    hash = _calculate_hash()

func get_element(idx):
    if idx < elements.size():
        return elements[idx]
    return null

func _to_string() -> String:
    return "(%s)" % ",".join(elements.map(str))

func _calculate_hash() -> int:
    var h = 0
    for element in elements:
        h = (31 * h + hash(element))
    return h

func size():
    return elements.size()
