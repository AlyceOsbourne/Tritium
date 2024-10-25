class_name TritiumCodeEditor
extends CodeEdit

@export var tritium: Tritium = Tritium.new()
var mech_data: MechData = MechData.new()

func refresh(meta_data:={}):
    for k in get_meta_list():
        meta_data[k] = get_meta(k)
    return tritium.evaluate(self.text, meta_data)

func _init() -> void:
    syntax_highlighter = load("res://tritium/editor/TritiumSyntaxHighlighting.tres")
    gutters_draw_line_numbers = true
    gutters_draw_fold_gutter = true

    text_changed.connect(refresh)
    set_text(mech_data._code)

    fold_all_lines()
    code_completion_enabled = true

func _ready() -> void:
    mech_data._bind(tritium.settings)
    mech_data.data_updated.connect(refresh)
    refresh.call_deferred()
