extends Node3D

@export var mass: float = 1.0
@export var velocity: Vector3 = Vector3.ZERO
@export var sun: NodePath
@export var G: float = 1.0  # constante gravitacional

var sun_ref: Node3D

func _ready():
	# Encontra o Sol
	sun_ref = get_node(sun)

	# Define posição inicial (raio da órbita)
	#global_position = Vector3(20, 0, 0)

	# Massa do Sol (mesma usada no cálculo)
	var M = 1000.0

	# Calcula a velocidade para órbita circular
	var r = global_position.length()
	var speed = sqrt(G * M / r)

	# Define velocidade perpendicular (em Z)
	velocity = Vector3(0, 0, speed)

func _physics_process(delta):
	if sun_ref == null:
		return

	var r_vec = sun_ref.global_position - global_position
	var distance = r_vec.length()

	if distance == 0:
		return # evita divisão por zero

	var direction = r_vec.normalized()
	var M = 1000.0  # massa do Sol

	# Aceleração gravitacional
	var accel = direction * (G * M / (distance * distance))

	# Atualiza velocidade e posição
	velocity += accel * delta
	global_position += velocity * delta
