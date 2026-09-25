extends Area2D

# Caminho da cena para onde este portal vai levar o jogador
@export_file("*.tscn") var proxima_cena: String = "res://scenes/dungeon/dungeon_floor_1.tscn"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") or body.name == "Player":
		mudar_de_area()

func mudar_de_area() -> void:
	if proxima_cena != "":
		print("Carregando nova área: ", proxima_cena)
		get_tree().change_scene_to_file(proxima_cena)
	else:
		print("ERRO: Nenhuma cena foi definida no portal!")