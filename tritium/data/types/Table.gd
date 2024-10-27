class_name Table

var b_plus_tree
var columns
var next_id = 1  # To manage unique ID generation

class QueryResult:
    var value: Variant
    var error: String

    func _init(value=null, error=""):
        self.value = value
        self.error = error

    func is_success() -> bool:
        return error == ""

    func _to_string() -> String:
        return "Value: %s, Error: %s" % [str(self.value), self.error]

class BPlusTreeNode:
    var is_leaf: bool
    var keys: Array
    var children: Array
    var data: Array

    func _init(is_leaf=false):
        self.is_leaf = is_leaf
        self.keys = []
        self.children = []
        self.data = []

    func _to_string() -> String:
        return "Leaf: %s, Keys: %s, Data: %s, Children: %s" % [str(self.is_leaf), str(self.keys), str(self.data), str(self.children)]

class BPlusTree:
    var root: BPlusTreeNode
    var max_keys: int

    func _init(order=4):
        root = BPlusTreeNode.new(true)
        max_keys = order - 1

    func insert(key, value) -> QueryResult:
        if key == null or value == null:
            return QueryResult.new(null, "Key or value cannot be null")

        var current_node = root
        var parent = null

        # Traverse to the appropriate leaf node
        while not current_node.is_leaf:
            parent = current_node
            var index = 0
            while index < current_node.keys.size() and key > current_node.keys[index]:
                index += 1
            current_node = current_node.children[index]

        # Insert the key in the correct position within the leaf node
        var index = 0
        while index < current_node.keys.size() and key > current_node.keys[index]:
            index += 1
        current_node.keys.insert(index, key)
        current_node.data.insert(index, value)

        # Split the leaf node if it exceeds max_keys
        if current_node.keys.size() > max_keys:
            _split_node(current_node, parent)

        return QueryResult.new(value)

    func _split_node(node, parent):
        var middle_index = node.keys.size() / 2
        var new_node = BPlusTreeNode.new(node.is_leaf)
        new_node.keys = node.keys.slice(middle_index)
        new_node.data = node.data.slice(middle_index) if node.is_leaf else []
        new_node.children = node.children.slice(middle_index) if not node.is_leaf else []
        node.keys = node.keys.slice(0, middle_index)
        node.data = node.data.slice(0, middle_index) if node.is_leaf else []
        node.children = node.children.slice(0, middle_index) if not node.is_leaf else []

        if node.is_leaf:
            new_node.children.append(node.children[-1])  # Maintain the linked list for leaf nodes
            node.children[-1] = new_node
        else:
            # Update parent pointers
            new_node.children = node.children.slice(middle_index + 1)

        if parent == null:
            # If splitting the root, create a new root
            root = BPlusTreeNode.new(false)
            root.keys.append(new_node.keys[0])
            root.children.append(node)
            root.children.append(new_node)
        else:
            # Insert the middle key in the parent node
            var insert_index = 0
            while insert_index < parent.keys.size() and node.keys[0] > parent.keys[insert_index]:
                insert_index += 1
            parent.keys.insert(insert_index, new_node.keys[0])
            parent.children.insert(insert_index + 1, new_node)

        # Split the parent if it exceeds max_keys
        if parent and parent.keys.size() > max_keys:
            _split_node(parent, null)

    func search(key) -> QueryResult:
        if key == null:
            return QueryResult.new(null, "Key cannot be null")

        var current_node = root
        # Traverse to the appropriate leaf node
        while not current_node.is_leaf:
            var index = 0
            while index < current_node.keys.size() and key > current_node.keys[index]:
                index += 1
            current_node = current_node.children[index]

        # Search for the key in the leaf node
        for i in range(current_node.keys.size()):
            if current_node.keys[i] == key and current_node.data.size() > i:
                return QueryResult.new(current_node.data[i])
        return QueryResult.new(null, "Key not found")

    func delete(key) -> QueryResult:
        if key == null:
            return QueryResult.new(null, "Key cannot be null")

        var current_node = root
        var parent = null
        var parent_index = -1

        # Traverse to the appropriate leaf node
        while not current_node.is_leaf:
            parent = current_node
            var index = 0
            while index < current_node.keys.size() and key > current_node.keys[index]:
                index += 1
            parent_index = index
            current_node = current_node.children[index]

        # Find the key in the leaf node
        var key_index = -1
        for i in range(current_node.keys.size()):
            if current_node.keys[i] == key:
                key_index = i
                break

        if key_index == -1:
            return QueryResult.new(null, "Key not found for deletion")

        # Remove the key and data from the leaf node
        current_node.keys.erase(key_index)
        current_node.data.erase(key_index)

        # Handle underflow if needed
        if current_node.keys.size() < max_keys / 2 and parent != null:
            _handle_underflow(current_node, parent, parent_index)

        return QueryResult.new(null)

    func _handle_underflow(node, parent, parent_index):
        # Handle underflow by either merging with a sibling or redistributing keys

        # Find left and right siblings if available
        var left_sibling = parent.children[parent_index - 1] if parent_index > 0 else null
        var right_sibling = parent.children[parent_index + 1] if parent_index < parent.children.size() - 1 else null

        if left_sibling != null and left_sibling.keys.size() > max_keys / 2:
            # Redistribute from the left sibling
            node.keys.insert(0, left_sibling.keys.pop_back())
            if node.is_leaf:
                node.data.insert(0, left_sibling.data.pop_back())
            else:
                node.children.insert(0, left_sibling.children.pop_back())

            # Update parent key
            parent.keys[parent_index - 1] = node.keys[0]
        elif right_sibling != null and right_sibling.keys.size() > max_keys / 2:
            # Redistribute from the right sibling
            node.keys.append(right_sibling.keys.pop_front())
            if node.is_leaf:
                node.data.append(right_sibling.data.pop_front())
            else:
                node.children.append(right_sibling.children.pop_front())

            # Update parent key
            parent.keys[parent_index] = right_sibling.keys[0]
        else:
            # Merge with a sibling
            if left_sibling != null:
                # Merge with left sibling
                left_sibling.keys.append_array(node.keys)
                if node.is_leaf:
                    left_sibling.data.append_array(node.data)
                    left_sibling.children[-1] = node.children[-1]
                else:
                    left_sibling.children.append_array(node.children)

                # Remove node from parent
                parent.keys.erase(parent_index - 1)
                parent.children.erase(parent_index)
            elif right_sibling != null:
                # Merge with right sibling
                node.keys.append_array(right_sibling.keys)
                if node.is_leaf:
                    node.data.append_array(right_sibling.data)
                    node.children[-1] = right_sibling.children[-1]
                else:
                    node.children.append_array(right_sibling.children)

                # Remove right sibling from parent
                parent.keys.erase(parent_index)
                parent.children.erase(parent_index + 1)

            # If the parent is now underflowed, handle it recursively
            if parent != root and parent.keys.size() < max_keys / 2:
                _handle_underflow(parent, _find_parent(root, parent), _find_parent_index(root, parent))

    func _find_parent(current, target):
        # Helper function to find the parent of a given node
        if current == null or current.is_leaf:
            return null

        for child in current.children:
            if child == target:
                return current
            var parent = _find_parent(child, target)
            if parent != null:
                return parent

        return null

    func _find_parent_index(current, target):
        # Helper function to find the index of a given child node in its parent
        for i in range(current.children.size()):
            if current.children[i] == target:
                return i
        return -1

    func _to_string() -> String:
        return "Root: %s" % root._to_string()

func _init():
    b_plus_tree = BPlusTree.new(4)
    columns = {}

func create_column(name: String, resource_type: Variant.Type) -> QueryResult:
    # Create a new column with a specified resource type
    if name in columns:
        return QueryResult.new(null, "Column already exists!")
    columns[name] = []
    return QueryResult.new(null)

func insert_row(row_data: Dictionary) -> QueryResult:
    if not row_data:
        return QueryResult.new(null, "Row data cannot be empty")

    # Generate a unique ID for the new row
    var id = next_id
    next_id += 1

    # Insert a row into the table using the ID
    var search_result = b_plus_tree.search(id)
    if search_result.is_success() and search_result.value != null:
        return QueryResult.new(null, "Row with this ID already exists!")

    # Insert ID into the BPlusTree for indexing
    var row_index = 0 if columns.size() == 0 else len(columns.values()[0])
    var insert_result = b_plus_tree.insert(id, row_index)
    if not insert_result.is_success():
        return insert_result

    # Insert data into the respective columns
    for column_name in row_data.keys():
        if not column_name in columns:
            return QueryResult.new(null, "Column does not exist: %s" % column_name)
        columns[column_name].append(row_data[column_name])

    return QueryResult.new(id)

func find_row_by_id(id: int) -> QueryResult:
    if id == null:
        return QueryResult.new(null, "ID cannot be null")

    # Use the B+Tree to find the row by ID
    var search_result = b_plus_tree.search(id)
    if not search_result.is_success() or search_result.value == null:
        return QueryResult.new(null, "Row with this ID does not exist")

    var index = search_result.value
    var row_data = {}
    for column_name in columns.keys():
        row_data[column_name] = columns[column_name][index]

    return QueryResult.new(row_data)

func delete_row(id: int) -> QueryResult:
    if id == null:
        return QueryResult.new(null, "ID cannot be null")

    # Delete a row from the table using the ID
    var search_result = b_plus_tree.search(id)
    if not search_result.is_success() or search_result.value == null:
        return QueryResult.new(null, "Row with this ID does not exist!")

    var index = search_result.value

    # Remove data from the respective columns
    for column_name in columns.keys():
        columns[column_name].erase(index)

    # Delete the key from the BPlusTree
    var delete_result = b_plus_tree.delete(id)
    if not delete_result.is_success():
        return delete_result

    return QueryResult.new(null)

func _to_string() -> String:
    var header = "| ID | " + " | ".join(columns.keys()) + " |\n"
    var separator = "|----" + "|----".repeat(columns.size()) + "|\n"
    var rows = ""
    for id in b_plus_tree.root.keys:
        var row_data = find_row_by_id(id).value
        var row = "| %s | %s |\n" % [str(id), " | ".join(row_data.values())]
        rows += row
    return header + separator + rows

static func _static_init() -> void:
    var table = Table.new()
    assert(table.create_column("health", TYPE_INT).is_success())
    assert(table.create_column("ammo", TYPE_INT).is_success())
    var insert_result = table.insert_row({"health": 100, "ammo": 50})
    assert(insert_result.is_success())
    print("Inserted row with ID: %s" % insert_result.value)
    var row_result = table.find_row_by_id(insert_result.value)
    assert(row_result.is_success())
    assert(row_result.value == {"health": 100, "ammo": 50})
    print(row_result.value)  # Output: {"health": 100, "ammo": 50}
    assert(table.delete_row(insert_result.value).is_success())
    var deleted_row_result = table.find_row_by_id(insert_result.value)
    assert(!deleted_row_result.is_success())
    print(deleted_row_result.error)  # Output: "Row with this ID does not exist"
