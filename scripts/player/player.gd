extends CharacterBody2D

@export var velocidade_normal: float = 200.0
@export var velocidade_correndo: float = 320.0
@export var dano_ataque: int = 10
@export var tempo_recarga_ataque: float = 0.35

@onready var weapon_pivot: Node2D = $WeaponPivot
@onready var hitbox: Area2D = $WeaponPivot/Hitbox
@onready var hitbox_collision: CollisionShape2D = $WeaponPivot/Hitbox/CollisionShape2D
@onready var sword_sprite: Polygon2D = $WeaponPivot/Hitbox/SwordSprite

var pode_atacar: bool = true

func _ready() -> void:
	hitbox_collision.disabled = true
	sword_sprite.visible = false
	# Conecta o sinal de colisão da Hitbox para detetar o inimigo no momento do impacto
	hitbox.body_entered.connect(_on_hitbox_body_entered)

func _physics_process(_delta: float) -> void:
	processar_movimento()
	orientar_arma()
	processar_ataque()
	move_and_slide()

func processar_movimento() -> void:
	var direcao := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var velocidade_atual := velocidade_correndo if Input.is_action_pressed("run") else velocidade_normal
	velocity = direcao * velocidade_atual

func orientar_arma() -> void:
	var direcao_mouse := get_global_mouse_position() - global_position
	weapon_pivot.rotation = direcao_mouse.angle()

func processar_ataque() -> void:
	if Input.is_action_just_pressed("attack") and pode_atacar:
		atacar()

func atacar() -> void:
	pode_atacar = false
	sword_sprite.visible = true
	hitbox_collision.disabled = false # Ativa a colisor do ataque

	# Tempo de duração do golpe
	await get_tree().create_timer(0.15).timeout
	hitbox_collision.disabled = true
	sword_sprite.visible = false

	# Tempo de recarga entre ataques (Cooldown)
	await get_tree().create_timer(tempo_recarga_ataque).timeout
	pode_atacar = true

# Função disparada automaticamente pela Godot quando um corpo entra na Hitbox
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body != self and body.has_method("receber_dano"):
		body.receber_dano(dano_ataque)