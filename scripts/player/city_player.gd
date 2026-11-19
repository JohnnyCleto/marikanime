extends CharacterBody2D

@export var walk_speed: float = 165.0
@export var run_speed: float = 260.0
var can_move: bool = true
var facing: Vector2 = Vector2.DOWN

func _physics_process(_delta: float) -> void:
    if not can_move:
        velocity = Vector2.ZERO
        return
    var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    if direction.length_squared() > 0.0:
        facing = direction
    velocity = direction * (run_speed if Input.is_action_pressed("run") else walk_speed)
    move_and_slide()
    queue_redraw()

func _draw() -> void:
    draw_circle(Vector2(0, 10), 12, Color(0.0, 0.0, 0.0, 0.22))
    draw_rect(Rect2(-10, -7, 20, 25), Color("377fd2"))
    draw_circle(Vector2(0, -13), 11, Color("f1bc8f"))
    draw_arc(Vector2(0, -16), 11, PI, TAU, 12, Color("34334d"), 5.0)
    draw_circle(facing.normalized() * 5.0 + Vector2(0, -12), 2.2, Color("262436"))
