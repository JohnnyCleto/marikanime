extends CharacterBody2D
class_name MarikanimeEnemy
var player: MarikanimePlayer
var world: Node2D
var health: int = 28
var hit_timer: float = 0.0
var attack_timer: float = 0.0

func _ready() -> void:
    collision_layer = 4
    collision_mask = 1 | 2
    var collider: CollisionShape2D = CollisionShape2D.new()
    var rect: RectangleShape2D = RectangleShape2D.new()
    rect.size = Vector2(22, 22)
    collider.shape = rect
    add_child(collider)

func _physics_process(delta: float) -> void:
    if player == null or GameState.dialogue_open or GameState.inventory_open:
        return
    hit_timer = maxf(0.0, hit_timer - delta)
    attack_timer = maxf(0.0, attack_timer - delta)
    var distance: float = global_position.distance_to(player.global_position)
    velocity = global_position.direction_to(player.global_position) * 78.0 if distance < 210.0 and distance > 27.0 else Vector2.ZERO
    move_and_slide()
    if distance < 30.0 and attack_timer <= 0.0:
        player.receive_damage(8)
        attack_timer = 1.2
    queue_redraw()

func take_damage(amount: int) -> void:
    health -= amount
    hit_timer = 0.18
    if health <= 0:
        world.drop_loot(global_position)
        GameState.gain_xp(15)
        queue_free()
    else:
        queue_redraw()

func _draw() -> void:
    draw_circle(Vector2.ZERO, 13.0, Color("ffb6ad") if hit_timer > 0.0 else Color("9065ba"))
    draw_circle(Vector2(-5, -3), 2.5, Color.WHITE)
    draw_circle(Vector2(5, -3), 2.5, Color.WHITE)
