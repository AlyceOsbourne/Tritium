extends RefCounted

class_name HashSet

const LOAD_FACTOR: float = 0.75
const INITIAL_CAPACITY: int = 16

var _capacity: int
var _size: int
var _buckets: Array

func _init(elements: Array = []):
    _capacity = INITIAL_CAPACITY
    _size = 0
    _buckets = []
    for i in range(_capacity):
        _buckets.append(null)
    for e in elements:
        add(e)

func _hash(item: Variant) -> int:
    return int(hash(item) % _capacity)

func _resize():
    var old_buckets = _buckets
    _capacity *= 2
    _buckets = []
    for i in range(_capacity):
        _buckets.append(null)
    _size = 0

    for bucket in old_buckets:
        if bucket != null:
            add(bucket)

func add(item: Variant) -> bool:
    if contains(item):
        return false

    if float(_size) / float(_capacity) >= LOAD_FACTOR:
        _resize()

    var index = _hash(item)
    while _buckets[index] != null:
        index = (index + 1) % _capacity
    _buckets[index] = item
    _size += 1
    return true

func remove(item: Variant) -> bool:
    var index = _hash(item)
    var initial_index = index

    while _buckets[index] != null:
        if _buckets[index] == item:
            _buckets[index] = null
            _size -= 1
            index = (index + 1) % _capacity
            while _buckets[index] != null:
                var rehash_item = _buckets[index]
                _buckets[index] = null
                _size -= 1
                add(rehash_item)
                index = (index + 1) % _capacity
            return true
        index = (index + 1) % _capacity
        if index == initial_index:
            break
    return false

func contains(item: Variant) -> bool:
    var index = _hash(item)
    var initial_index = index

    while _buckets[index] != null:
        if _buckets[index] == item:
            return true
        index = (index + 1) % _capacity
        if index == initial_index:
            break
    return false

func size() -> int:
    return _size

func clear() -> void:
    _buckets.clear()
    for i in range(_capacity):
        _buckets.append(null)
    _size = 0

func to_array() -> Array:
    var result = []
    for bucket in _buckets:
        if bucket != null:
            result.append(bucket)
    return result

func _to_string() -> String:
    var items = to_array()
    var items_str = []
    for item in items:
        items_str.append(str(item))
    return "{" + ", ".join(items_str) + "}"

func intersection(other: HashSet) -> HashSet:
    var result = HashSet.new()
    for item in to_array():
        if other.contains(item):
            result.add(item)
    return result

func union(other: HashSet) -> HashSet:
    var result = HashSet.new()
    for item in to_array():
        result.add(item)
    for item in other.to_array():
        result.add(item)
    return result

func difference(other: HashSet) -> HashSet:
    var result = HashSet.new()
    for item in to_array():
        if not other.contains(item):
            result.add(item)
    return result

func is_disjoint(other: HashSet) -> bool:
    for item in to_array():
        if other.contains(item):
            return false
    return true
