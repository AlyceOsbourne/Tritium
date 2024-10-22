extends Node2D

const GRID_SIZE = 64

@export_multiline var mech_code: String
@export var camera: ShapeCast2D
@export var thinker: RichTextLabel
@export var tritium: Tritium

func _ready() -> void:
    tritium.complete.connect(handle_result)
    tritium.settings.bind_module(self)
    tritium.started.connect(thinker.clear)
    tritium.stdout.connect(thinker.append_text)
    tritium.stderr.connect(thinker.append_text)
    tick.call_deferred()

func move(direction: Vector2):
    var rotated_direction = direction.rotated(rotation + deg_to_rad(45))
    await get_tree().create_tween().tween_property(self, "position", self.position + (rotated_direction * GRID_SIZE), 1).finished

func turn(direction: Vector2):
    var rot = direction.angle_to(Vector2.UP)
    print(rad_to_deg(rot))
    rotation += rot

func bind(settings: InterpreterSettings):
    settings.bind_function("move", move)
    settings.bind_function("turn", turn)
    settings.bind_function("camera",
        func():
            var seen = camera.get_collision_count()
            var log = []
            for k in seen:
                log.append(camera.get_collider(k).get_meta("camera_details", {}))
            return log
    )

func handle_result(result):
    if result.error:
        print(result.error)
    else:
        print(result.value)
    await get_tree().create_timer(1).timeout
    tick.call_deferred()

func tick():
    var meta = {}
    tritium.evaluate(mech_code, meta)
