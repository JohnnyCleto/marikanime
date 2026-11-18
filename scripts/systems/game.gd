extends Node2D

const PlayerScene = preload("res://scenes/player/player.tscn")
const EnemyScene = preload("res://scenes/enemies/enemy.tscn")
const TILE := 32
const WIDTH := 1280
const HEIGHT := 704
const DAY_NAMES := ["Manhã", "Tarde", "Noite", "Madrugada"]
const ITEMS := ["espada", "cajado", "pocao", "", "", "", "", "", ""]
const CITY_PATH := "res://resources/city_map.txt"
const DUNGEON_PATH := "res://resources/dungeon_map.txt"

var day := 1
var block := 0
var hp := 100.0
var max_hp := 100.0
var energy := 100.0
var max_energy := 100.0
var money := 0
var resources := 0
var potions := 2
var bonus_damage := 0
var selected := 0
var map_name := "city"
var player: MarikanimeActor
var world: Node2D
var ui: CanvasLayer
var message := ""
var message_time := 0.0
var finished := false
var projectiles: Array[Dictionary] = []
var pickups: Array[Vector2] = []
var interactables: Array[Dictionary] = []
var labels: Dictionary = {}
var overlay: ColorRect
var hotbar: HBoxContainer
var hover_label: Label
var font_size := 16

func _ready() -> void:
	_setup_inputs()
	_build_ui()
	load_map("city")
	show_message("Bem-vindo a Maricá! Explore, prepare-se e entre na masmorra.")

func _setup_inputs() -> void:
	var bindings := {
		"move_left": [KEY_A, KEY_LEFT], "move_right": [KEY_D, KEY_RIGHT], "move_up": [KEY_W, KEY_UP], "move_down": [KEY_S, KEY_DOWN],
		"run": [KEY_SHIFT], "dodge": [KEY_SPACE], "potion": [KEY_Q], "interact": [KEY_E],
		"restart": [KEY_R], "pause_game": [KEY_ESCAPE], "inventory": [KEY_I], "journal": [KEY_J], "map": [KEY_M]
	}
	for action in bindings:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		for key in bindings[action]:
			var event := InputEventKey.new()
			event.physical_keycode = key
			InputMap.action_add_event(action, event)
	if not InputMap.has_action("attack"):
		InputMap.add_action("attack")
	var mouse := InputEventMouseButton.new()
	mouse.button_index = MOUSE_BUTTON_LEFT
	InputMap.action_add_event("attack", mouse)
	if not InputMap.has_action("secondary_attack"):
		InputMap.add_action("secondary_attack")
	var right_mouse := InputEventMouseButton.new()
	right_mouse.button_index = MOUSE_BUTTON_RIGHT
	InputMap.action_add_event("secondary_attack", right_mouse)

func _build_ui() -> void:
	ui = CanvasLayer.new()
	ui.layer = 5
	add_child(ui)
	overlay = ColorRect.new()
	overlay.position = Vector2.ZERO
	overlay.size = Vector2(WIDTH, HEIGHT)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(overlay)
	for key in ["hp", "energy", "stats", "day", "period", "message", "end"]:
		var label := Label.new()
		label.add_theme_font_size_override("font_size", 17 if key != "end" else 30)
		label.add_theme_color_override("font_color", Color.WHITE)
		label.add_theme_color_override("font_shadow_color", Color.BLACK)
		label.add_theme_constant_override("shadow_offset_x", 2)
		label.add_theme_constant_override("shadow_offset_y", 2)
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		ui.add_child(label)
		labels[key] = label
	labels["hp"].position = Vector2(16, 12)
	labels["energy"].position = Vector2(16, 39)
	labels["stats"].position = Vector2(16, 70)
	labels["day"].position = Vector2(1080, 12)
	labels["period"].position = Vector2(1080, 39)
	labels["message"].position = Vector2(300, 580)
	labels["end"].position = Vector2(260, 310)
	hover_label = Label.new()
	hover_label.add_theme_font_size_override("font_size", 16)
	hover_label.add_theme_color_override("font_color", Color.WHITE)
	hover_label.add_theme_color_override("font_shadow_color", Color.BLACK)
	hover_label.add_theme_constant_override("shadow_offset_x", 2)
	hover_label.add_theme_constant_override("shadow_offset_y", 2)
	ui.add_child(hover_label)
	hotbar = HBoxContainer.new()
	hotbar.position = Vector2((WIDTH - 9 * 47) / 2.0, 650)
	hotbar.add_theme_constant_override("separation", 3)
	ui.add_child(hotbar)
	for i in range(9):
		var label := Label.new()
		label.custom_minimum_size = Vector2(44, 43)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 13)
		hotbar.add_child(label)
	_update_ui()

func load_map(which: String) -> void:
	map_name = which
	if is_instance_valid(world):
		world.queue_free()
		remove_child(world)
	world = Node2D.new()
	world.name = "Cidade" if which == "city" else "Masmorra"
	add_child(world)
	move_child(world, 0)
	pickups.clear()
	projectiles.clear()
	interactables.clear()
	var source := CITY_PATH if which == "city" else DUNGEON_PATH
	var rows := FileAccess.get_file_as_string(source).strip_edges().split("\n")
	for y in range(rows.size()):
		var line: String = rows[y]
		for x in range(line.length()):
			var tile := line.substr(x, 1)
			var pos := Vector2(x * TILE + 16, y * TILE + 16)
			if tile == "#":
				_make_wall(pos)
			elif tile == "P":
				_make_player(pos)
			elif tile == "E":
				_make_enemy(pos)
			elif tile in ["M", "S", "C", "L", "T"]:
				interactables.append({"type": tile, "position": pos})
	_update_ui()
	queue_redraw()

func _make_wall(pos: Vector2) -> void:
	var wall := StaticBody2D.new()
	wall.position = pos
	wall.collision_layer = 1
	wall.collision_mask = 0
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(32, 32)
	collision.shape = shape
	wall.add_child(collision)
	world.add_child(wall)

func _make_player(pos: Vector2) -> void:
	player = PlayerScene.instantiate()
	player.name = "Jogador"
	player.position = pos
	player.is_player = true
	player.color_fill = Color("42dbe7")
	player.hp = hp
	player.max_hp = max_hp
	player.owner_game = self
	world.add_child(player)
	player.get_node("Camera2D").make_current()

func _make_enemy(pos: Vector2) -> void:
	var enemy := EnemyScene.instantiate()
	enemy.name = "Criatura"
	enemy.position = pos
	enemy.color_fill = Color("e4525a")
	enemy.owner_game = self
	world.add_child(enemy)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart") and finished:
		get_tree().reload_current_scene()
		return
	if finished:
		_update_ui()
		return
	message_time = maxf(0, message_time - delta)
	for i in range(9):
		if Input.is_key_pressed(KEY_1 + i):
			selected = i
	if Input.is_action_just_pressed("interact"):
		interact()
	_update_projectiles(delta)
	_collect_pickups()
	_update_ui()
	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and not finished:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			selected = (selected + 1) % 9
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			selected = (selected + 8) % 9

func _physics_process(_delta: float) -> void:
	if not finished and is_instance_valid(player):
		hp = player.hp
		if Input.is_action_just_pressed("secondary_attack") and player.cooldown <= 0.0:
			cast_secondary()

func cast_secondary() -> void:
	if energy < 12.0:
		show_message("Energia insuficiente para habilidade.")
		return
	energy -= 12.0
	player.cooldown = 0.5
	projectiles.append({"position": player.global_position, "direction": player.aim, "damage": 10 + bonus_damage, "life": 1.2})
	show_message("Habilidade secundária utilizada (-12 energia).")

func use_selected_item(actor: MarikanimeActor) -> void:
	var item: String = ITEMS[selected]
	if item == "espada":
		actor.cooldown = 24.0 / 60.0
		actor.attack_center = actor.global_position + actor.aim * 28.0
		actor.attack_radius = 22.0
		actor.attack_flash = 0.1
		actor.get_node("WeaponPivot/Hitbox").monitoring = true
		for enemy in get_tree().get_nodes_in_group("enemies"):
			if is_instance_valid(enemy) and enemy.global_position.distance_to(actor.attack_center) <= 34.0:
				enemy.take_damage(12 + bonus_damage, actor.aim)
	elif item == "cajado":
		actor.cooldown = 36.0 / 60.0
		projectiles.append({"position": actor.global_position, "direction": actor.aim, "damage": 8 + bonus_damage, "life": 1.0})
	elif item == "pocao":
		actor.cooldown = 20.0 / 60.0
		use_potion()

func use_potion() -> void:
	if potions > 0 and hp < max_hp and is_instance_valid(player):
		potions -= 1
		hp = minf(max_hp, hp + 40.0)
		player.hp = hp
		show_message("Poção utilizada: +40 HP.")

func _update_projectiles(delta: float) -> void:
	for i in range(projectiles.size() - 1, -1, -1):
		var shot: Dictionary = projectiles[i]
		shot["life"] -= delta
		var start: Vector2 = shot["position"]
		var end: Vector2 = start + shot["direction"] * 360.0 * delta
		var query := PhysicsRayQueryParameters2D.create(start, end, 1 | 4)
		var hit := get_world_2d().direct_space_state.intersect_ray(query)
		if not hit.is_empty():
			var target = hit.get("collider")
			if target is MarikanimeActor and not target.is_player:
				target.take_damage(shot["damage"], shot["direction"])
			projectiles.remove_at(i)
		elif shot["life"] <= 0:
			projectiles.remove_at(i)
		else:
			shot["position"] = end
			projectiles[i] = shot

func drop_loot(pos: Vector2) -> void:
	pickups.append(pos)

func _collect_pickups() -> void:
	if not is_instance_valid(player):
		return
	for i in range(pickups.size() - 1, -1, -1):
		if player.global_position.distance_to(pickups[i]) < 23:
			pickups.remove_at(i)
			money += 5
			resources += 1
			show_message("Coletou R$ 5 e 1 recurso.")

func interact() -> void:
	if not is_instance_valid(player):
		return
	for entry in interactables:
		if player.global_position.distance_to(entry["position"]) >= 40:
			continue
		match entry["type"]:
			"M":
				advance_blocks(1)
				if not finished:
					load_map("dungeon")
			"S":
				load_map("city")
			"C":
				sleep_day()
			"L":
				if money >= 15:
					money -= 15
					potions += 1
					show_message("Comprou 1 poção por R$ 15.")
				else:
					show_message("Dinheiro insuficiente (R$ 15).")
			"T":
				advance_blocks(1)
				if not finished:
					bonus_damage += 2
					show_message("Treinou! Bônus de dano: +%d." % bonus_damage)
		return

func advance_blocks(amount: int) -> void:
	for n in range(amount):
		block += 1
		energy = maxf(0, energy - 15)
		if block > 3:
			sleep_day()
			show_message("Você apagou de cansaço!")
			break

func sleep_day() -> void:
	var late := block >= 3
	day += 1
	block = 0
	energy = 60 if late else max_energy
	hp = max_hp
	if is_instance_valid(player):
		player.hp = hp
	if day > 30:
		finished = true
		show_message("As férias terminaram!")
	else:
		show_message("Dia %d começou. Energia: %d." % [day, int(energy)])

func faint() -> void:
	money = int(floor(money * 0.5))
	hp = max_hp * 0.5
	advance_blocks(2)
	if not finished:
		load_map("city")
		player.hp = hp
		show_message("Desmaiou: perdeu metade do dinheiro e 2 blocos.")

func show_message(value: String) -> void:
	message = value
	message_time = 4.0

func _update_ui() -> void:
	if labels.is_empty():
		return
	labels["hp"].text = "❤️ HP %d / %d" % [int(ceil(hp)), int(max_hp)]
	labels["energy"].text = "⚡ Energia %d / %d" % [int(ceil(energy)), int(max_energy)]
	labels["stats"].text = "R$ %d   Recursos: %d   Poções: %d   Dano +%d" % [money, resources, potions, bonus_damage]
	labels["day"].text = "Dia %02d / 30" % mini(day, 30)
	labels["period"].text = DAY_NAMES[clampi(block, 0, 3)]
	labels["message"].text = message if message_time > 0 else ""
	labels["end"].text = "FIM DAS FÉRIAS — pressione R para reiniciar" if finished else ""
	var nearby := ""
	if is_instance_valid(player):
		for entry in interactables:
			if player.global_position.distance_to(entry["position"]) < 40:
				nearby = {"M":"[E] Descer à masmorra (1 bloco)", "S":"[E] Voltar à cidade", "C":"[E] Dormir (próximo dia)", "L":"[E] Comprar poção (R$ 15)", "T":"[E] Treinar (+2 dano, 1 bloco)"}.get(entry["type"], "")
				break
	hover_label.text = nearby
	hover_label.position = player.global_position + Vector2(-90, -49) if is_instance_valid(player) else Vector2.ZERO
	for i in range(9):
		var label := hotbar.get_child(i) as Label
		var name: String = str({
	"espada": "Esp",
	"cajado": "Caj",
	"pocao": "Poç x%d" % potions
}.get(ITEMS[i], ""))
		label.text = "%d\n%s" % [i + 1, name]
		label.add_theme_color_override("font_color", Color.YELLOW if selected == i else Color.WHITE)
		label.add_theme_color_override("font_shadow_color", Color.BLACK)
	overlay.color = Color(0.04, 0.04, 0.23, [0.0, 0.1, 0.45, 0.6][clampi(block, 0, 3)]) if map_name == "city" else Color.TRANSPARENT
	if finished:
		overlay.color = Color(0, 0, 0, 0.78)

func _draw() -> void:
	draw_rect(Rect2(0, 0, WIDTH, HEIGHT), Color("387c4d") if map_name == "city" else Color("221b37"))
	var source := CITY_PATH if map_name == "city" else DUNGEON_PATH
	var rows := FileAccess.get_file_as_string(source).strip_edges().split("\n")
	for y in range(rows.size()):
		var line: String = rows[y]
		for x in range(line.length()):
			var pos := Vector2(x * TILE, y * TILE)
			var tile := line.substr(x, 1)
			if tile == "#":
				draw_rect(Rect2(pos, Vector2(TILE, TILE)), Color("49535d") if map_name == "city" else Color("51426e"))
				draw_rect(Rect2(pos + Vector2(2, 2), Vector2(28, 28)), Color("68717c") if map_name == "city" else Color("65517d"), false, 1)
			elif (x + y) % 2 == 0:
				draw_rect(Rect2(pos, Vector2(TILE, TILE)), Color(1, 1, 1, 0.025))
	for entry in interactables:
		var colors := {"M":Color("9a4cdb"), "S":Color("ee9638"), "C":Color("4b89e0"), "L":Color("edcf4a"), "T":Color("48c46a")}
		draw_rect(Rect2(entry["position"] - Vector2(12, 12), Vector2(24, 24)), colors[entry["type"]])
	for pos in pickups:
		draw_circle(pos, 6, Color.GOLD)
	for shot in projectiles:
		draw_circle(shot["position"], 5, Color("d7edff"))
