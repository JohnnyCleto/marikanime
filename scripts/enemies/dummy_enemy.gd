extends CharacterBody2D

@export var vida_maxima: int = 50
var vida_atual: int

@onready var polygon_2d: Polygon2D = $Polygon2D

func _ready() -> void:
	vida_atual = vida_maxima

func receber_dano(quantidade: int) -> void:
	vida_atual -= quantidade
	print("Inimigo atingido! HP: ", vida_atual, "/", vida_maxima)

	efeito_dano()

	if vida_atual <= 0:
		derrotar()

func efeito_dano() -> void:
	if polygon_2d == null:
		print("ERRO: O nó Polygon2D não foi encontrado em dummy_enemy!")
		return

	var cor_original: Color = polygon_2d.color
	polygon_2d.color = Color(1.0, 0.0, 0.0, 1.0) # Pisca vermelho
	
	await get_tree().create_timer(0.15).timeout
	
	polygon_2d.color = cor_original

func derrotar() -> void:
	print("Inimigo derrotado!")
	queue_free()
