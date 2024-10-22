extends RichTextLabel

@export var editor: TritiumCodeEditor

func _ready() -> void:
    editor.tritium.started.connect(_on_code_edit_started)
    editor.tritium.stdout.connect(_on_code_edit_stdout.call_deferred)
    editor.tritium.stderr.connect(_on_code_edit_strerr.call_deferred)

func _on_code_edit_strerr(string: String) -> void:
    append_text("[color=RED]%s[/color]" % string)
    if string.contains("eggs/cthulhu"):
        push_font(load("res://tritium/editor/Dignity of Labour.otf"), 24)

func _on_code_edit_stdout(string: String) -> void:
    append_text(str(string))
    if string.contains("eggs/cthulhu"):
        push_font(load("res://tritium/editor/Dignity of Labour.otf"), 24)

func _on_code_edit_started() -> void:
    clear()
