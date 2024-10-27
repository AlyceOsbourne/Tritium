class_name Database

var tables: Dictionary

func _init():
    tables = {}

func create_table(table_name: String) -> Table.QueryResult:
    if table_name in tables:
        return Table.QueryResult.new(null, "Table already exists!")
    var table = Table.new()
    tables[table_name] = table
    return Table.QueryResult.new(table)

func delete_table(table_name: String) -> Table.QueryResult:
    if not table_name in tables:
        return Table.QueryResult.new(null, "Table does not exist!")
    tables.erase(table_name)
    return Table.QueryResult.new(null)

func create_column(table_name: String, column_name: String, resource_type: Variant.Type) -> Table.QueryResult:
    if not table_name in tables:
        return Table.QueryResult.new(null, "Table does not exist!")
    return tables[table_name].create_column(column_name, resource_type)

func insert_row(table_name: String, row_data: Dictionary) -> Table.QueryResult:
    if not table_name in tables:
        return Table.QueryResult.new(null, "Table does not exist!")
    return tables[table_name].insert_row(row_data)

func find_row(table_name: String, row_id: int) -> Table.QueryResult:
    if not table_name in tables:
        return Table.QueryResult.new(null, "Table does not exist!")
    return tables[table_name].find_row_by_id(row_id)

func delete_row(table_name: String, row_id: int) -> Table.QueryResult:
    if not table_name in tables:
        return Table.QueryResult.new(null, "Table does not exist!")
    return tables[table_name].delete_row(row_id)

func _to_string() -> String:
    var db_str = "Database Tables:\n"
    for table_name in tables.keys():
        db_str += "Table: %s\n%s\n" % [table_name, tables[table_name]._to_string()]
    return db_str
