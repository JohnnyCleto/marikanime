extends CharacterBody2D
class_name MarikanimeActor

var color_fill: Color = Color.WHITE
var body_size := 24.0
var hp := 30.0
var max_hp := 30.0
var damage := 8.0
var speed := 72.0
var vision := 200.0
var cooldown := 0.0
var knockback := Vector2.ZERO
var flash := 0.0
var invincible := 0.0
var is_player := false
var aim := Vector2.RIGHT
var attack_flash := 0.0
var attack_center := Vector2.ZERO
var attack_radius := 22.0
var dodge_time := 0.0
var dodge_cooldown := 0.0
var last_move := Vector2.DOWN
var owner_game: Node2D

func _ready() -> void:
    add_to_group("players" if is_player else "enemies")
    var shape := RectangleShape2D.new()
    shape.size = Vector2(body_size, body_size)
    var collision := CollisionShape2D.new()
    collision.shape = shape
    add_child(collision)
    collision_layer = 2 if is_player else 4
    collision_mask = 1 | (4 if is_player else 2)
    queue_redraw()

func _physics_process(delta: float) -> void:
    if owner_game.finished:
        return
    cooldown = maxf(0.0, cooldown - delta)
    flash = maxf(0.0, flash - delta)
    invincible = maxf(0.0, invincible - delta)
    attack_flash = maxf(0.0, attack_flash - delta)
    dodge_cooldown = maxf(0.0, dodge_cooldown - delta)
    if is_player:
        get_node("WeaponPivot").rotation = (get_global_mouse_position() - global_position).angle()
        _player_step(delta)
    else:
        _enemy_step(delta)
    move_and_slide()
    queue_redraw()

func _player_step(delta: float) -> void:
    aim = (get_global_mouse_position() - global_position).normalized()
    if aim.length_squared() < 0.01:
        aim = Vector2.RIGHT
    var movement := Input.get_vector("move_left", "move_right", "move_up", "move_down")
    if movement.length_squared() > 0.01:
        last_move = movement
    if dodge_time > 0.0:
        dodge_time -= delta
        velocity = last_move * 420.0 + knockback
    else:
        var move_speed := 240.0 if Input.is_action_pressed("run") and owner_game.energy > 0 else 150.0
        if owner_game.energy <= 0:
            move_speed *= 0.6
        velocity = movement * move_speed + knockback
        if Input.is_action_just_pressed("dodge") and dodge_cooldown <= 0.0 and owner_game.energy >= 5:
            dodge_time = 10.0 / 60.0
            dodge_cooldown = 30.0 / 60.0
            invincible = maxf(invincible, 14.0 / 60.0)
            owner_game.energy -= 5
            velocity = last_move * 420.0
        if Input.is_action_pressed("attack") and cooldown <= 0:
            owner_game.use_selected_item(self)
        if Input.is_action_just_pressed("potion"):
            owner_game.use_potion()
    knockback = knockback.move_toward(Vector2.ZERO, 600.0 * delta)

func _enemy_step(delta: float) -> void:
    var player := owner_game.player as MarikanimeActor
    if not is_instance_valid(player):
        velocity = Vector2.ZERO
        return
    var distance := global_position.distance_to(player.global_position)
    var direction := global_position.direction_to(player.global_position)
    velocity = (direction * speed if distance < vision else Vector2.ZERO) + knockback
    knockback = knockback.move_toward(Vector2.ZERO, 600.0 * delta)
    if distance <= 25.0 and cooldown <= 0:
        player.take_damage(damage, direction)
        cooldown = 45.0 / 60.0

func take_damage(amount: float, direction: Vector2) -> void:
    if is_player and invincible > 0:
        return
    hp -= amount
    knockback = direction.normalized() * (240.0 if is_player else 300.0)
    flash = 0.1
    if is_player:
        invincible = 40.0 / 60.0
        owner_game.hp = maxf(0.0, hp)
        if hp <= 0:
            owner_game.faint()
    elif hp <= 0:
        owner_game.drop_loot(global_position)
        queue_free()

func _draw() -> void:
    var fill := color_fill
    if flash > 0:
        fill = Color.WHITE
    if is_player and invincible > 0 and int(invincible * 12) % 2 == 0:
        fill.a = 0.45
    draw_rect(Rect2(Vector2(-12, -12), Vector2(24, 24)), fill)
    if is_player:
        draw_line(Vector2.ZERO, aim * 22.0, Color.WHITE, 2.0)
        if attack_flash > 0:
            draw_arc(attack_center - global_position, attack_radius, 0, TAU, 32, Color.WHITE, 1.5)
    else:
        draw_rect(Rect2(-12, -22, 24, 4), Color.BLACK)
        draw_rect(Rect2(-12, -22, 24 * maxf(0, hp / max_hp), 4), Color.LIME_GREEN)
