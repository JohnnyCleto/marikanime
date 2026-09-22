extends CharacterBody2D


const VELOCIDADE_NORMAL := 200.0
const VELOCIDADE_CORRENDO := 320.0


func _physics_process(_delta):
	movimentar()
	move_and_slide()


func movimentar():
	var direcao := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	var velocidade_atual := VELOCIDADE_NORMAL

	if Input.is_action_pressed("run"):
		velocidade_atual = VELOCIDADE_CORRENDO

	velocity = direcao * velocidade_atual
