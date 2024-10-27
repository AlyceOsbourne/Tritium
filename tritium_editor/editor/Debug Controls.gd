extends VBoxContainer

@export var editor: TritiumCodeEditor
@export var target: Resource

func _ready() -> void:
    if not target:
        return
    add_controls_for_properties(target, self)

func add_controls_for_properties(data: Object, parent: Control) -> void:
    var properties = get_properties(data)
    for property in properties:
        var vbox = VBoxContainer.new()

        var label = Label.new()
        label.text = property.name.replace("_", " ").capitalize()
        label.custom_minimum_size = Vector2(150, 0)  # Set fixed width for labels
        vbox.add_child(label)

        var control = create_control_for_property(property, data)

        vbox.add_child(control)

        parent.add_child(vbox)

func get_properties(data: Object) -> Array:
    return data.get_property_list().filter(
        func(x):
            return not (x["name"].contains(".gd") or ["script", "Built-in script", "RefCounted"].has(x["name"]))
    )

func create_control_for_property(property: Dictionary, data: Object) -> Control:
    match property.type:
        TYPE_INT:
            if property.hint == PROPERTY_HINT_ENUM:
                var options = (property.hint_string.split(",") as Array).map(func(option): return option.split(":")[0])
                var option_button = OptionButton.new()
                for option in options:
                    option_button.add_item(option)
                option_button.selected = data.get(property.name)
                option_button.item_selected.connect(func(index): data.set(property.name, index); editor.refresh.call_deferred())
                return option_button
            else:
                var slider = HSlider.new()
                var hints = property.hint_string.split(",")
                if hints.size() == 3:
                    slider.min_value = hints[0].to_float()
                    slider.max_value = hints[1].to_float()
                    slider.step = hints[2].to_float()
                else:
                    slider.min_value = 0
                    slider.max_value = 100
                    slider.step = 1
                slider.value = data.get(property.name)
                slider.drag_ended.connect(func(x): data.set(property.name, slider.value); editor.refresh.call_deferred())
                return slider
        TYPE_FLOAT:
            var slider = HSlider.new()
            var hints = property.hint_string.split(",")
            if hints.size() == 3:
                slider.min_value = hints[0].to_float()
                slider.max_value = hints[1].to_float()
                slider.step = hints[2].to_float()
            else:
                slider.min_value = 0
                slider.max_value = 100
                slider.step = 1
            slider.value = data.get(property.name)
            slider.drag_ended.connect(func(x): data.set(property.name, slider.value); editor.refresh.call_deferred())
            return slider
        TYPE_BOOL:
            var check_button = CheckBox.new()
            check_button.button_pressed = data.get(property.name)
            check_button.toggled.connect(func(pressed): data.set(property.name, pressed); editor.refresh.call_deferred())
            return check_button
        TYPE_STRING:
            var line_edit = LineEdit.new()
            #line_edit.expand_to_text_length = true
            line_edit.text = data.get(property.name)
            line_edit.text_changed.connect(func(new_text): data.set(property.name, new_text); editor.refresh.call_deferred())
            return line_edit
        TYPE_VECTOR2, TYPE_VECTOR2I:
            var vector2_container = VBoxContainer.new()

            var x_edit = SpinBox.new()
            x_edit.value = data.get(property.name).x

            x_edit.value_changed.connect(func(new_text):
                var current_value = data.get(property.name)
                current_value.x = new_text
                data.set(property.name, current_value)
                editor.refresh.call_deferred()
            )

            var y_edit = SpinBox.new()
            y_edit.value = data.get(property.name).y

            y_edit.value_changed.connect(func(new_text):
                var current_value = data.get(property.name)
                current_value.y = new_text
                data.set(property.name, current_value)
                editor.refresh.call_deferred()
            )

            var hbox = HBoxContainer.new()

            hbox.add_child(x_edit)
            hbox.add_child(y_edit)

            vector2_container.add_child(hbox)

            return vector2_container

    var default_label = Label.new()
    default_label.text = "Unsupported type"
    default_label.size_flags_horizontal = SIZE_SHRINK_CENTER
    return default_label
