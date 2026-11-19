extends CanvasLayer
var world: MarikanimeWorld
var hud_label: Label
var dialogue_panel: PanelContainer
var dialogue_label: Label
var hint_label: Label
var hotbar_label: Label
var journal_panel: PanelContainer
var journal_label: Label

func _ready() -> void:
    world = get_parent() as MarikanimeWorld
    var root: Control = Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    root.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(root)
    hud_label = _label(root, Vector2(15, 12), Vector2(380, 120), 17)
    hint_label = _label(root, Vector2(320, 12), Vector2(500, 60), 15)
    hotbar_label = _label(root, Vector2(260, 570), Vector2(700, 50), 17)
    dialogue_panel = PanelContainer.new()
    dialogue_panel.position = Vector2(175, 450)
    dialogue_panel.custom_minimum_size = Vector2(800, 110)
    root.add_child(dialogue_panel)
    dialogue_label = Label.new()
    dialogue_label.add_theme_font_size_override("font_size", 19)
    dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    dialogue_panel.add_child(dialogue_label)
    journal_panel = PanelContainer.new()
    journal_panel.position = Vector2(330, 155)
    journal_panel.custom_minimum_size = Vector2(500, 330)
    root.add_child(journal_panel)
    journal_label = Label.new()
    journal_label.add_theme_font_size_override("font_size", 19)
    journal_panel.add_child(journal_label)

func _process(_delta: float) -> void:
    var gs: Node = GameState
    hud_label.text = "MARIKANIME  |  Dia %02d/30 — %s
HP: %d/100   Energia: %d/100
Moedas: %d   Poções: %d   EXP: %d
Madeira: %d   Pedra: %d   Afinidade: %d" % [gs.day, gs.PERIODS[gs.period], gs.hp, int(gs.energy), gs.money, gs.potions, gs.experience, gs.wood, gs.stones, gs.affinity]
    var nearest_name: String = ""
    var nearest_distance: float = 58.0
    for obj: Dictionary in world.interactables:
        var dist: float = world.player.global_position.distance_to(Vector2(obj["pos"]))
        if dist < nearest_distance:
            nearest_name = str(obj["name"])
            nearest_distance = dist
    hint_label.text = "E: " + nearest_name if nearest_name != "" else (world.event_text if world.event_timer > 0.0 else "WASD: andar | Shift: correr | E: interagir")
    var slots: Array[String] = []
    for i: int in range(gs.SLOTS.size()):
        var name: String = gs.SLOTS[i]
        var prefix: String = "[" if gs.selected_slot == i else " "
        var suffix: String = "]" if gs.selected_slot == i else " "
        slots.append("%s%d:%s%s" % [prefix, i + 1, name if name != "" else "-", suffix])
    hotbar_label.text = "  ".join(slots) + "
Clique esquerdo: atacar | Direito: magia | Q: poção | Espaço: esquiva | I: diário"
    dialogue_panel.visible = gs.dialogue_open
    if gs.dialogue_open and world.dialogue_index < world.current_dialogue.size():
        dialogue_label.text = world.current_dialogue[world.dialogue_index] + "

[E] Continuar"
    journal_panel.visible = gs.inventory_open
    var quest: String = "Conheça a praça e converse com a Tia Helena."
    match gs.quest_stage:
        1: quest = "Encontre o gato na praça."
        2: quest = "Volte e conte à Tia Helena sobre o gato."
        3: quest = "Missão concluída! Explore a masmorra."
    journal_label.text = "DIÁRIO DE FÉRIAS

Missão: " + quest + "

Gatos encontrados: %d
Ponte reparada: %s
EXP: %d

[I] Fechar" % [gs.cats_found, "Sim" if gs.bridge_repaired else "Não", gs.experience]

func _label(parent: Control, pos: Vector2, size: Vector2, font_size: int) -> Label:
    var label: Label = Label.new()
    label.position = pos
    label.size = size
    label.add_theme_font_size_override("font_size", font_size)
    label.add_theme_color_override("font_color", Color("fff9e7"))
    label.add_theme_color_override("font_shadow_color", Color("222038"))
    label.add_theme_constant_override("shadow_offset_x", 2)
    label.add_theme_constant_override("shadow_offset_y", 2)
    parent.add_child(label)
    return label
