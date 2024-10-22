class_name TritiumCodeEditor
extends CodeEdit

@export var tritium: Tritium

func refresh(meta_data:={}):
    for k in get_meta_list():
        meta_data[k] = get_meta(k)
    return tritium.evaluate(self.text, meta_data)

func _init() -> void:
    syntax_highlighter = load("res://tritium/editor/TritiumSyntaxHighlighting.tres")
    gutters_draw_line_numbers = true
    gutters_draw_fold_gutter = true

    text_changed.connect(refresh)
    set_text("""# Mecha boot script

fn main(){
    print("Tritium V" + str(VERSION))
    print()

    print("Available Modules:")
    print(modules)
    print()

    print("Available Globals:")
    print(globals)
    print()

    print("Available Metadata:")
    print(meta_data)
    print()

    systems_check()

    return OK;
}

fn systems_check() {
    print("Running checks for: " + mech_name)
    assert(mech_health > 0, "Mech is destroyed.")
    print("Mech Health: " + str(mech_health))
    assert(mech_power > 0, "Mech is out of power.")
    print("Mech Power: " + str(mech_power))

    print("Mech Current Location: " + str(mech_position))

    print("All Systems Nominal. Can proceed with mission.")
    print()
}""")

func _ready() -> void:
    refresh.call_deferred()
