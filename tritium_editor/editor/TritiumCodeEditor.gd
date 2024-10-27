class_name TritiumCodeEditor
extends CodeEdit

@export var tritium := Tritium.new()
@export var tritium_settings := InterpreterSettings.new()
# var mech_data: MechData = MechData.new()

#var easter_eggs = {
    #func(settings: InterpreterSettings): return uwu.uwucrew.has(settings.get_variable("mech").value.system.name): func(settings: InterpreterSettings): settings.bind_module(load("res://bindings/eggs/uwu.gd")),
    #func(settings: InterpreterSettings): return godoblins.godoblins.has(settings.get_variable("mech").value.system.name): func(settings: InterpreterSettings): settings.bind_module(load("res://bindings/eggs/arr.gd")),
    #func(settings: InterpreterSettings): return cthulhubots.cthulhucrew.has(settings.get_variable("mech").value.system.name): func(settings: InterpreterSettings): settings.bind_module(load("res://bindings/eggs/cthulhu.gd")),
#}

func refresh(meta_data:={}, env := tritium):
    for k in get_meta_list():
        meta_data[k] = get_meta(k)
    tritium.evaluate.call_deferred(self.tritium_settings, self.text, meta_data)

func _init() -> void:
    syntax_highlighter = load("res://tritium_editor/editor/TritiumSyntaxHighlighting.tres")
    gutters_draw_line_numbers = true
    gutters_draw_fold_gutter = true

    text_changed.connect(refresh.call_deferred)

    fold_all_lines()
    code_completion_enabled = true

func _ready() -> void:
    self.text = tritium_settings.code
    refresh()
