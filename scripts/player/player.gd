extends CharacterBody2D
class_name MarikanimePlayer

@export var walk_speed: float = 165.0
@export var run_speed: float = 255.0
@export var body_color: Color = Color("567fc8")
var facing: Vector2 = Vector2.DOWN
var attack_cooldown: float = 0.0
var attack_flash: float = 0.0
var dodge_time: float = 0.0
var dodge_cooldown: float = 0.0
var invulnerability: float = 0.0
var world: Node2D

func _ready() -> void:
	collision_layer = 2
	collision_mask = 1 | 4
	var shape: CollisionShape2D = CollisionShape2D.new()
	var rectangle: RectangleShape2D = RectangleShape2D.new()
	rectangle.size = Vector2(19, 22)
	shape.shape = rectangle
	add_child(shape)
	var camera: Camera2D = Camera2D.new()
	camera.enabled = true
	camera.zoom = Vector2(1.45, 1.45)
	add_child(camera)
	queue_redraw()

func _physics_process(delta: float) -> void:
	attack_cooldown = maxf(0.0, attack_cooldown - delta)
	attack_flash = maxf(0.0, attack_flash - delta)
	dodge_cooldown = maxf(0.0, dodge_cooldown - delta)
	invulnerability = maxf(0.0, invulnerability - delta)
	if GameState.dialogue_open or GameState.inventory_open or GameState.day > 30:
		velocity = Vector2.ZERO
		queue_redraw()
		return
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_dir.length_squared() > 0.01:
		facing = input_dir.normalized()
	if dodge_time > 0.0:
		dodge_time -= delta
		velocity = facing * 390.0
	else:
		var running: bool = Input.is_action_pressed("run") and GameState.energy > 1.0
		velocity = input_dir * (run_speed if running else walk_speed)
		if running and input_dir.length_squared() > 0.01:
			GameState.energy = maxf(0.0, GameState.energy - 10.0 * delta)
		else:
			GameState.energy = minf(100.0, GameState.energy + 7.0 * delta)
	move_and_slide()
	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if GameState.dialogue_open or GameState.inventory_open or GameState.day > 30:
		return
	if event.is_action_pressed("dodge") and dodge_cooldown <= 0.0 and GameState.energy >= 12.0:
		dodge_time = 0.18
		dodge_cooldown = 0.65
		invulnerability = 0.25
		GameState.energy -= 12.0
	if event.is_action_pressed("attack"):
		attack(false)
	if event.is_action_pressed("secondary"):
		attack(true)

func attack(secondary: bool) -> void:
	if attack_cooldown > 0.0 or world == null:
		return
	var aim: Vector2 = (get_global_mouse_position() - global_position).normalized()
	if aim.length_squared() < 0.01:
		aim = facing
	facing = aim
	var slot: String = GameState.SLOTS[GameState.selected_slot]
	if secondary or slot == "cajado":
		if GameState.energy < 9.0:
			world.notify("Energia insuficiente")
			return
		GameState.energy -= 9.0
		attack_cooldown = 0.5
		world.spawn_projectile(global_position + aim * 20.0, aim)
	elif slot == "espada":
		attack_cooldown = 0.3
		attack_flash = 0.18
		world.melee_attack(global_position + aim * 29.0, 36.0, 12)
	elif slot == "pocao":
		if GameState.heal():
			world.notify("Poção utilizada: +40 HP")
		else:
			world.notify("Não é possível usar poção")
	else:
		world.notify("Selecione espada, cajado ou poção")

func receive_damage(amount: int) -> void:
	if invulnerability > 0.0:
		return
	GameState.hp = maxi(0, GameState.hp - amount)
	invulnerability = 0.8
	if GameState.hp <= 0:
		GameState.hp = 50
		world.travel("cidade", Vector2(420, 380))
		world.notify("Você desmaiou e acordou na cidade")
	queue_redraw()

func _draw() -> void:
	# Silhueta provisória única: substituir apenas esta representação por sprites no futuro.
	var tint: Color = Color.WHITE if invulnerability <= 0.0 else Color("ffaaa2")
	draw_rect(Rect2(-10, -10, 20, 24), body_color * tint)
	draw_rect(Rect2(-8, -21, 16, 14), Color("e9b48a") * tint)
	draw_rect(Rect2(-9, -23, 18, 6), Color("303447"))
	draw_rect(Rect2(-8, 14, 6, 7), Color("27324d"))
	draw_rect(Rect2(2, 14, 6, 7), Color("27324d"))
	draw_circle(facing * 15.0, 3.0, Color("f9e7a2"))
	if attack_flash > 0.0:
		draw_arc(facing * 24.0, 28.0, facing.angle() - 0.8, facing.angle() + 0.8, 18, Color("fff0a2"), 5.0)
