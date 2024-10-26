class_name TritiumCodeEditor
extends CodeEdit

@export var tritium: Tritium = Tritium.new()
var mech_data: MechData = MechData.new()

var easter_eggs = {
    func(settings: InterpreterSettings): return uwu.uwucrew.has(settings.get_variable("mech").value.system.name): func(settings: InterpreterSettings): settings.bind_module(load("res://tritium/bindings/eggs/uwu.gd")),
    func(settings: InterpreterSettings): return godoblins.godoblins.has(settings.get_variable("mech").value.system.name): func(settings: InterpreterSettings): settings.bind_module(load("res://tritium/bindings/eggs/arr.gd")),
    func(settings: InterpreterSettings): return cthulhubots.cthulhucrew.has(settings.get_variable("mech").value.system.name): func(settings: InterpreterSettings): settings.bind_module(load("res://tritium/bindings/eggs/cthulhu.gd")),
}

func refresh(meta_data:={}, env := tritium, data := mech_data):
    for k in get_meta_list():
        meta_data[k] = get_meta(k)
    data.data_updated.connect(refresh, CONNECT_DEFERRED | CONNECT_ONE_SHOT)
    tritium.evaluate.call_deferred(self.text, meta_data, easter_eggs)

func _init() -> void:
    syntax_highlighter = load("res://tritium/editor/TritiumSyntaxHighlighting.tres")
    gutters_draw_line_numbers = true
    gutters_draw_fold_gutter = true

    text_changed.connect(refresh.call_deferred)
    set_text(mech_data._code)

    fold_all_lines()
    code_completion_enabled = true

func _ready() -> void:
    mech_data._bind(tritium.settings)
    refresh()
