extends Node2D
class_name MarikanimeWorld
const PlayerScene: PackedScene = preload("res://scenes/player/player.tscn")
const EnemyScene: PackedScene = preload("res://scenes/enemies/enemy.tscn")
const TILE: int = 32
const MAP_W: int = 38
const MAP_H: int = 24
var player: MarikanimePlayer
var hud: CanvasLayer
var obstacles: Array[Rect2] = []
var interactables: Array[Dictionary] = []
var loot: Array[Dictionary] = []
var enemies: Array[MarikanimeEnemy] = []
var projectiles: Array[Dictionary] = []
var event_text: String = ""
var event_timer: float = 0.0
var current_dialogue: Array[String] = []
var dialogue_index: int = 0
var after_dialogue: String = ""

func _ready() -> void:
    player = PlayerScene.instantiate() as MarikanimePlayer
    add_child(player)
    player.world = self
    hud = preload("res://scenes/ui/hud.tscn").instantiate() as CanvasLayer
    add_child(hud)
    travel("cidade", Vector2(415, 375))
    notify("Bem-vindo a Maricá! Converse com a Tia Helena (E)")

func travel(target: String, destination: Vector2) -> void:
    for enemy: MarikanimeEnemy in enemies:
        if is_instance_valid(enemy):
            enemy.queue_free()
    enemies.clear()
    GameState.current_map = target
    obstacles.clear()
    interactables.clear()
    loot.clear()
    projectiles.clear()
    _make_borders()
    if target == "cidade":
        _make_city()
    else:
        _make_dungeon()
    player.global_position = destination
    queue_redraw()

func _make_borders() -> void:
    for x: int in range(MAP_W):
        add_wall(Rect2(x * TILE, 0, TILE, TILE))
        add_wall(Rect2(x * TILE, (MAP_H - 1) * TILE, TILE, TILE))
    for y: int in range(1, MAP_H - 1):
        add_wall(Rect2(0, y * TILE, TILE, TILE))
        add_wall(Rect2((MAP_W - 1) * TILE, y * TILE, TILE, TILE))

func add_wall(rect: Rect2) -> void:
    obstacles.append(rect)
    var body: StaticBody2D = StaticBody2D.new()
    body.collision_layer = 1
    body.collision_mask = 0
    body.position = rect.get_center()
    var shape: CollisionShape2D = CollisionShape2D.new()
    var box: RectangleShape2D = RectangleShape2D.new()
    box.size = rect.size
    shape.shape = box
    body.add_child(shape)
    add_child(body)
    body.add_to_group("map_wall")

func _clear_walls() -> void:
    for body: Node in get_tree().get_nodes_in_group("map_wall"):
        body.queue_free()

func _make_city() -> void:
    add_wall(Rect2(95, 95, 260, 145))
    add_wall(Rect2(800, 90, 250, 145))
    add_wall(Rect2(105, 540, 210, 135))
    add_wall(Rect2(860, 525, 190, 150))
    add_wall(Rect2(535, 135, 90, 90))
    for pos: Vector2 in [Vector2(410, 150), Vector2(740, 180), Vector2(380, 570), Vector2(770, 590)]:
        interactables.append({"pos": pos, "name": "Árvore", "type": "tree"})
    interactables.append({"pos": Vector2(480, 360), "name": "Tia Helena", "type": "helena"})
    interactables.append({"pos": Vector2(620, 365), "name": "Placa da praça", "type": "sign"})
    interactables.append({"pos": Vector2(560, 460), "name": "Banco", "type": "bench"})
    interactables.append({"pos": Vector2(245, 270), "name": "Casa da tia", "type": "bed"})
    interactables.append({"pos": Vector2(915, 275), "name": "Loja", "type": "shop"})
    interactables.append({"pos": Vector2(1030, 430), "name": "Entrada da masmorra", "type": "dungeon"})
    interactables.append({"pos": Vector2(720, 455), "name": "Ponte antiga", "type": "bridge"})
    interactables.append({"pos": Vector2(450, 615), "name": "Gato da praça", "type": "cat"})
    interactables.append({"pos": Vector2(680, 610), "name": "Lucas", "type": "lucas"})

func _make_dungeon() -> void:
    for x: int in range(4, 15):
        if x != 9:
            add_wall(Rect2(x * TILE, 7 * TILE, TILE, TILE))
    for y: int in range(9, 19):
        if y != 14:
            add_wall(Rect2(23 * TILE, y * TILE, TILE, TILE))
    add_wall(Rect2(420, 450, 100, 70))
    interactables.append({"pos": Vector2(110, 120), "name": "Escada para a cidade", "type": "city"})
    interactables.append({"pos": Vector2(500, 310), "name": "Inscrição antiga", "type": "rune"})
    interactables.append({"pos": Vector2(800, 580), "name": "Baú", "type": "chest"})
    for pos: Vector2 in [Vector2(550, 180), Vector2(670, 330), Vector2(880, 380)]:
        var enemy: MarikanimeEnemy = EnemyScene.instantiate() as MarikanimeEnemy
        add_child(enemy)
        enemy.global_position = pos
        enemy.player = player
        enemy.world = self
        enemies.append(enemy)

func _process(delta: float) -> void:
    GameState.tick(delta)
    event_timer = maxf(0.0, event_timer - delta)
    for index: int in range(projectiles.size() - 1, -1, -1):
        var shot: Dictionary = projectiles[index]
        shot["pos"] = Vector2(shot["pos"]) + Vector2(shot["dir"]) * 330.0 * delta
        shot["life"] = float(shot["life"]) - delta
        var remove: bool = float(shot["life"]) <= 0.0
        for enemy: MarikanimeEnemy in enemies:
            if is_instance_valid(enemy) and enemy.global_position.distance_to(Vector2(shot["pos"])) < 20.0:
                enemy.take_damage(8)
                remove = true
                break
        if remove:
            projectiles.remove_at(index)
        else:
            projectiles[index] = shot
    queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("interact"):
        if GameState.dialogue_open:
            next_dialogue()
        elif not GameState.inventory_open:
            interact()
        get_viewport().set_input_as_handled()
    elif event.is_action_pressed("inventory"):
        GameState.inventory_open = not GameState.inventory_open
        get_viewport().set_input_as_handled()
    elif event.is_action_pressed("quick_item") and not GameState.dialogue_open:
        if GameState.heal():
            notify("Você recuperou 40 HP")
        else:
            notify("Não é possível usar uma poção")
    elif event is InputEventKey and event.pressed and not event.echo:
        var key_event: InputEventKey = event as InputEventKey
        if key_event.keycode >= KEY_1 and key_event.keycode <= KEY_9:
            GameState.selected_slot = int(key_event.keycode - KEY_1)
            get_viewport().set_input_as_handled()

func interact() -> void:
    var nearest: Dictionary = {}
    var best: float = 57.0
    for obj: Dictionary in interactables:
        var distance: float = player.global_position.distance_to(Vector2(obj["pos"]))
        if distance < best:
            nearest = obj
            best = distance
    if not nearest.is_empty():
        use_object(str(nearest["type"]))
        return
    for index: int in range(loot.size() - 1, -1, -1):
        if player.global_position.distance_to(Vector2(loot[index]["pos"])) < 50.0:
            GameState.add_loot(str(loot[index]["kind"]))
            notify("Recurso coletado: " + str(loot[index]["kind"]))
            loot.remove_at(index)
            return
    notify("Nada para interagir por perto")

func use_object(kind: String) -> void:
    match kind:
        "helena":
            if int(GameState.flags.get("talked_today", -1)) == GameState.day:
                dialogue(["Tia Helena: Já conversamos hoje. Aproveite a cidade!"])
            else:
                GameState.flags["talked_today"] = GameState.day
                GameState.affinity += 1
                if GameState.quest_stage == 0:
                    GameState.quest_stage = 1
                    dialogue(["Tia Helena: Bom dia! Bem-vindo às férias em Maricá.", "Tia Helena: Explore a praça, encontre o gato e volte para me contar.", "Nova missão: O gato da praça."])
                elif GameState.quest_stage == 2:
                    GameState.quest_stage = 3
                    GameState.money += 50
                    dialogue(["Tia Helena: Você encontrou o gatinho! Obrigada.", "Recompensa: 50 moedas. Que tal conhecer o evento geek?"])
                else:
                    dialogue(["Tia Helena: As férias são feitas de pequenas descobertas.", "Tia Helena: A praça muda bastante quando anoitece."])
        "cat":
            if not bool(GameState.flags.get("cat_found", false)):
                GameState.flags["cat_found"] = true
                GameState.cats_found += 1
                if GameState.quest_stage == 1:
                    GameState.quest_stage = 2
                dialogue(["Miau! O gato se aproxima e aceita um carinho.", "Registro no diário: Gato da praça encontrado."])
            else:
                dialogue(["O gato ronrona tranquilamente."])
        "lucas":
            dialogue(["Lucas: Estamos preparando o Maricá Geek Summer Fest!", "Lucas: Dizem que há uma passagem estranha perto do evento."])
        "sign": dialogue(["Praça de Maricá — um lugar para descansar e observar o verão."])
        "bench": dialogue(["Você senta por alguns instantes e observa o movimento da praça."])
        "tree":
            GameState.add_loot("madeira")
            dialogue(["Você recolheu um galho caído. +1 madeira."])
        "bed":
            GameState.sleep()
            dialogue(["Você descansou na casa da Tia Helena.", "Um novo dia começa!"])
        "shop":
            if GameState.money >= 30:
                GameState.money -= 30
                GameState.potions += 1
                dialogue(["Loja: Você comprou uma poção por 30 moedas."])
            else:
                dialogue(["Loja: Uma poção custa 30 moedas."])
        "dungeon":
            if GameState.quest_stage < 3:
                dialogue(["A passagem está escura. Talvez seja melhor conhecer a cidade primeiro.", "Dica: encontre o gato e converse com a Tia Helena."])
            else:
                _clear_walls()
                travel("masmorra", Vector2(120, 160))
                notify("Masmorra: use o mouse para atacar")
        "city":
            _clear_walls()
            travel("cidade", Vector2(970, 430))
            notify("Você retornou à cidade")
        "bridge":
            if GameState.bridge_repaired:
                dialogue(["A ponte está firme. Um novo caminho poderá ser explorado futuramente."])
            elif GameState.wood >= 2 and GameState.stones >= 1:
                GameState.wood -= 2
                GameState.stones -= 1
                GameState.bridge_repaired = true
                dialogue(["Você consertou a ponte usando 2 madeiras e 1 pedra."])
            else:
                dialogue(["Uma ponte antiga precisa de reparos.", "Materiais: 2 madeiras e 1 pedra."])
        "rune": dialogue(["Uma inscrição antiga menciona o Guardião do Selo."])
        "chest":
            if not bool(GameState.flags.get("chest_open", false)):
                GameState.flags["chest_open"] = true
                GameState.stones += 1
                GameState.money += 60
                dialogue(["Você abriu o baú: +1 pedra e +60 moedas!"])
            else:
                dialogue(["O baú está vazio."])

func dialogue(lines: Array[String]) -> void:
    current_dialogue = lines
    dialogue_index = 0
    GameState.dialogue_open = true

func next_dialogue() -> void:
    dialogue_index += 1
    if dialogue_index >= current_dialogue.size():
        current_dialogue.clear()
        GameState.dialogue_open = false

func notify(message: String) -> void:
    event_text = message
    event_timer = 3.5

func melee_attack(center: Vector2, radius: float, damage: int) -> void:
    for enemy: MarikanimeEnemy in enemies:
        if is_instance_valid(enemy) and enemy.global_position.distance_to(center) < radius:
            enemy.take_damage(damage)

func spawn_projectile(start: Vector2, direction: Vector2) -> void:
    projectiles.append({"pos": start, "dir": direction, "life": 1.5})

func drop_loot(pos: Vector2) -> void:
    loot.append({"pos": pos, "kind": "moeda"})
    if loot.size() % 2 == 0:
        loot.append({"pos": pos + Vector2(16, 0), "kind": "pedra"})

func _draw() -> void:
    var city: bool = GameState.current_map == "cidade"
    draw_rect(Rect2(0, 0, MAP_W * TILE, MAP_H * TILE), Color("8ac58c") if city else Color("363247"))
    for x: int in range(1, MAP_W - 1):
        for y: int in range(1, MAP_H - 1):
            var tile_rect: Rect2 = Rect2(x * TILE, y * TILE, TILE, TILE)
            var color: Color = Color("93ce91") if (x + y) % 2 == 0 else Color("8ac58c")
            if not city:
                color = Color("413b53") if (x + y) % 2 == 0 else Color("393448")
            elif x in range(11, 27) and y in range(8, 18):
                color = Color("d7bf8e") if (x + y) % 2 == 0 else Color("d0b483")
            draw_rect(tile_rect, color)
    for rect: Rect2 in obstacles:
        draw_rect(rect, Color("a87955") if city else Color("64576c"))
        draw_rect(rect.grow(-3), Color("e1b887") if city else Color("786982"))
    for obj: Dictionary in interactables:
        var pos: Vector2 = Vector2(obj["pos"])
        var kind: String = str(obj["type"])
        var tint: Color = Color("e6d36b")
        match kind:
            "helena": tint = Color("e18f82")
            "lucas": tint = Color("7db9d9")
            "tree": tint = Color("40834e")
            "cat": tint = Color("e8ad68")
            "dungeon", "city": tint = Color("9975bb")
            "bridge": tint = Color("a16e46")
        draw_circle(pos, 13.0 if kind != "tree" else 21.0, tint)
        draw_string(ThemeDB.fallback_font, pos + Vector2(-35, -23), str(obj["name"]), HORIZONTAL_ALIGNMENT_CENTER, 70, 12, Color("18232e"))
    for drop: Dictionary in loot:
        draw_circle(Vector2(drop["pos"]), 7.0, Color("ffe06d"))
    for shot: Dictionary in projectiles:
        draw_circle(Vector2(shot["pos"]), 6.0, Color("a6d4ff"))
    if city:
        var overlay: Color = Color.TRANSPARENT
        match GameState.period:
            1: overlay = Color(0.95, 0.58, 0.2, 0.09)
            2: overlay = Color(0.12, 0.15, 0.42, 0.38)
            3: overlay = Color(0.07, 0.09, 0.28, 0.53)
        draw_rect(Rect2(0, 0, MAP_W * TILE, MAP_H * TILE), overlay)
