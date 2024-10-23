class_name MechData
extends Resource

enum AmmoType {
    NONE,
    BULLETS,
    SHELLS,
    ENERGY
}

signal data_updated



func _set(property: StringName, value: Variant) -> bool:
    data_updated.emit.call_deferred.call_deferred()
    return false

@export var name: String = ""
@export var power: float:
    set(v):
        power = clamp(v, 0, 1)
        data_updated.emit()
@export var integrity: float:
    set(v):
        integrity = clamp(v, 0, 1)
        data_updated.emit()
@export var ammo: Dictionary[AmmoType, int] = {}
@export var temperature: float:
    set(v):
        temperature = clamp(v, 0, 150)
        data_updated.emit()

@export var home_position: Vector2i = Vector2i.ZERO
@export var mech_position: Vector2i = Vector2i.ZERO
@export var mech_target: Vector2i = Vector2i.ZERO

func move_to(position: Vector2i):
    mech_target = position

func _to_string() -> String:
    var display: String = ""
    display += "MECH STATUS \n"
    display += "Power Level: %.2f\n" % power
    display += "Integrity: %.2f\n" % integrity
    display += "Ammo Status:\n"
    for ammo_type in AmmoType.keys():
        display += "  %s: %d\n" % [ammo_type, ammo.get(AmmoType[ammo_type], 0)]
    display += "Temperature: %.2f°C\n" % temperature
    return display

func _bind(settings: InterpreterSettings):
    settings.bind_variable("mech", self)
    settings.bind_variable("AmmoType", AmmoType)

class _Arm:
    pass

class _Leg:
    pass

class _Head:
    pass

class _Torso:
    pass
