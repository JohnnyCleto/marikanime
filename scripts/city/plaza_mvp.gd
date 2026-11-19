extends Node2D

# MVP independente: preserva a cena antiga de combate em scenes/test_area.tscn.
const PlayerScript = preload("res://scripts/player/city_player.gd")
const WIDTH: int = 960
const HEIGHT: int = 640
const PERIODS: Array[String] = ["Manhã", "Tarde", "Noite"]
const PERIOD_DURATION: float = 55.0

var player: CharacterBody2D
var npc_position: Vector2 = Vector2(610, 285)
var sign_position: Vector2 = Vector2(350, 210)
var bench_position: Vector2 = Vector2(700, 435)
var period_index: int = 0
var day: int = 1
var elapsed: float = 0.0
var dialog_open: bool = false
var dialog_index: int = 0
var dialog_lines: Array[String] = []
var dialog_title: String = ""
var hud: CanvasLayer
var period_label: Label
var prompt_label: Label
var dialog_panel: PanelContainer
var dialog_name: Label
var dialog_text: Label
var tint: ColorRect

func _ready() -> void:
    _setup_inputs()
    _create_world()
    _create_player()
    _create_ui()
    _refresh_ui()
    queue_redraw()

func _setup_inputs() -> void:
    var actions: Dictionary = {
        "move_left": [KEY_A, KEY_LEFT],
        "move_right": [KEY_D, KEY_RIGHT],
        "move_up": [KEY_W, KEY_UP],
        "move_down": [KEY_S, KEY_DOWN],
        "run": [KEY_SHIFT],
        "interact": [KEY_E]
    }
    for action_key in actions:
        var action_name: String = str(action_key)
        if not InputMap.has_action(action_name):
            InputMap.add_action(action_name)
        for key_value in actions[action_name]:
            var event: InputEventKey = InputEventKey.new()
            event.physical_keycode = int(key_value)
            InputMap.action_add_event(action_name, event)

func _create_wall(center: Vector2, dimensions: Vector2) -> void:
    var body: StaticBody2D = StaticBody2D.new()
    body.position = center
    body.collision_layer = 1
    body.collision_mask = 0
    var collision: CollisionShape2D = CollisionShape2D.new()
    var shape: RectangleShape2D = RectangleShape2D.new()
    shape.size = dimensions
    collision.shape = shape
    body.add_child(collision)
    add_child(body)

func _create_world() -> void:
    _create_wall(Vector2(WIDTH / 2.0, -12), Vector2(WIDTH + 48, 24))
    _create_wall(Vector2(WIDTH / 2.0, HEIGHT + 12), Vector2(WIDTH + 48, 24))
    _create_wall(Vector2(-12, HEIGHT / 2.0), Vector2(24, HEIGHT + 48))
    _create_wall(Vector2(WIDTH + 12, HEIGHT / 2.0), Vector2(24, HEIGHT + 48))
    _create_wall(Vector2(610, 300), Vector2(27, 29))
    _create_wall(Vector2(350, 218), Vector2(45, 25))
    _create_wall(Vector2(700, 450), Vector2(105, 24))

func _create_player() -> void:
    player = CharacterBody2D.new()
    player.name = "Jogador"
    player.position = Vector2(465, 360)
    player.collision_layer = 2
    player.collision_mask = 1
    player.set_script(PlayerScript)
    var collision: CollisionShape2D = CollisionShape2D.new()
    var shape: CircleShape2D = CircleShape2D.new()
    shape.radius = 11.0
    collision.shape = shape
    player.add_child(collision)
    add_child(player)
    var camera: Camera2D = Camera2D.new()
    camera.enabled = true
    camera.limit_left = 0
    camera.limit_top = 0
    camera.limit_right = WIDTH
    camera.limit_bottom = HEIGHT
    player.add_child(camera)
    camera.make_current()

func _make_label(parent: Node, pos: Vector2, content: String, size: int) -> Label:
    var label: Label = Label.new()
    label.position = pos
    label.text = content
    label.add_theme_font_size_override("font_size", size)
    label.add_theme_color_override("font_color", Color.WHITE)
    label.add_theme_color_override("font_shadow_color", Color.BLACK)
    label.add_theme_constant_override("shadow_offset_x", 2)
    label.add_theme_constant_override("shadow_offset_y", 2)
    label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    parent.add_child(label)
    return label

func _create_ui() -> void:
    hud = CanvasLayer.new()
    hud.layer = 5
    add_child(hud)
    tint = ColorRect.new()
    tint.position = Vector2.ZERO
    tint.size = Vector2(WIDTH, HEIGHT)
    tint.mouse_filter = Control.MOUSE_FILTER_IGNORE
    hud.add_child(tint)
    period_label = _make_label(hud, Vector2(20, 15), "", 21)
    _make_label(hud, Vector2(20, 46), "WASD / Setas: andar  |  Shift: correr  |  E: interagir", 15)
    prompt_label = _make_label(hud, Vector2(290, 570), "", 19)
    dialog_panel = PanelContainer.new()
    dialog_panel.position = Vector2(90, 448)
    dialog_panel.custom_minimum_size = Vector2(780, 155)
    hud.add_child(dialog_panel)
    var layout: VBoxContainer = VBoxContainer.new()
    layout.add_theme_constant_override("separation", 10)
    dialog_panel.add_child(layout)
    dialog_name = _make_label(layout, Vector2.ZERO, "", 20)
    dialog_text = _make_label(layout, Vector2.ZERO, "", 18)
    dialog_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    dialog_text.custom_minimum_size = Vector2(740, 65)
    _make_label(layout, Vector2.ZERO, "[E] Próxima fala / Fechar", 14)
    dialog_panel.visible = false

func _process(delta: float) -> void:
    if not dialog_open:
        elapsed += delta
        if elapsed >= PERIOD_DURATION:
            elapsed -= PERIOD_DURATION
            _advance_period()
    _refresh_ui()
    queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("interact") and not event.is_echo():
        if dialog_open:
            _next_dialog()
        else:
            _interact()
        get_viewport().set_input_as_handled()

func _advance_period() -> void:
    period_index += 1
    if period_index >= PERIODS.size():
        period_index = 0
        day = mini(day + 1, 30)
    _refresh_ui()

func _nearest_target() -> String:
    if not is_instance_valid(player):
        return ""
    if player.global_position.distance_to(npc_position) <= 70.0:
        return "npc"
    if player.global_position.distance_to(sign_position) <= 65.0:
        return "sign"
    if player.global_position.distance_to(bench_position) <= 78.0:
        return "bench"
    return ""

func _interact() -> void:
    match _nearest_target():
        "npc":
            _open_dialog("Tia Helena", [
                "Que bom que você chegou! Bem-vindo a Maricá.",
                "A praça fica diferente em cada período do dia. Aproveite para passear!",
                "Quando estiver pronto, podemos conhecer os outros moradores."
            ])
        "sign":
            _open_dialog("Placa da praça", ["Praça de Maricá — um lugar para caminhar, descansar e encontrar pessoas."])
        "bench":
            _open_dialog("Banco da praça", ["Um banco à sombra. Parece um bom lugar para observar o movimento da cidade."])

func _open_dialog(title: String, lines: Array[String]) -> void:
    dialog_title = title
    dialog_lines = lines
    dialog_index = 0
    dialog_open = true
    player.set("can_move", false)
    dialog_panel.visible = true
    _show_dialog_line()

func _show_dialog_line() -> void:
    dialog_name.text = dialog_title
    dialog_text.text = dialog_lines[dialog_index]

func _next_dialog() -> void:
    dialog_index += 1
    if dialog_index >= dialog_lines.size():
        dialog_open = false
        dialog_panel.visible = false
        player.set("can_move", true)
    else:
        _show_dialog_line()

func _refresh_ui() -> void:
    period_label.text = "Dia %02d / 30  •  %s" % [day, PERIODS[period_index]]
    if dialog_open:
        prompt_label.text = ""
    else:
        var target: String = _nearest_target()
        prompt_label.text = {"npc": "[E] Conversar com Tia Helena", "sign": "[E] Examinar placa", "bench": "[E] Examinar banco"}.get(target, "")
    match period_index:
        0: tint.color = Color(1.0, 0.84, 0.45, 0.06)
        1: tint.color = Color(1.0, 0.52, 0.22, 0.17)
        2: tint.color = Color(0.04, 0.06, 0.24, 0.55)

func _draw() -> void:
    draw_rect(Rect2(0, 0, WIDTH, HEIGHT), Color("62a76b"))
    draw_rect(Rect2(65, 125, 830, 405), Color("d8c99a"))
    draw_rect(Rect2(90, 145, 780, 365), Color("e8d8ad"))
    draw_rect(Rect2(425, 125, 110, 405), Color("c5b994"))
    draw_rect(Rect2(65, 280, 830, 75), Color("c5b994"))
    for i in range(6):
        var x: float = 112.0 + float(i) * 145.0
        draw_circle(Vector2(x, 112), 28, Color("347c4c"))
        draw_circle(Vector2(x, 535), 28, Color("347c4c"))
        draw_circle(Vector2(x - 7, 103), 18, Color("45965b"))
    draw_rect(Rect2(320, 190, 60, 50), Color("886544"))
    draw_rect(Rect2(335, 170, 30, 27), Color("f2e0aa"))
    draw_rect(Rect2(645, 425, 110, 30), Color("87563c"))
    draw_rect(Rect2(650, 420, 100, 12), Color("b47a50"))
    draw_circle(npc_position + Vector2(0, 12), 14, Color(0, 0, 0, 0.2))
    draw_rect(Rect2(npc_position + Vector2(-12, -4), Vector2(24, 28)), Color("ba6b9a"))
    draw_circle(npc_position + Vector2(0, -15), 13, Color("e9b98b"))
    draw_arc(npc_position + Vector2(0, -18), 13, PI, TAU, 12, Color("555064"), 5.0)
    draw_string(ThemeDB.fallback_font, npc_position + Vector2(-38, -41), "Tia Helena", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("303044"))
    draw_string(ThemeDB.fallback_font, Vector2(360, 85), "PRAÇA DE MARICÁ", HORIZONTAL_ALIGNMENT_LEFT, -1, 25, Color("f8f5d8"))
