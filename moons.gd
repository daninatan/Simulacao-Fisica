extends Node3D

@export var mass: float = 0.1
@export var central_star: NodePath
@export var central_planet: NodePath
@export var distance_from_planet: float = 2.0

var velocity: Vector3 = Vector3.ZERO
var G: float = 1.0

var star_node: Node3D
var planet_node: Node3D

func _ready():
	# Referência aos corpos centrais
	star_node = get_node_or_null(central_star)
	planet_node = get_node_or_null(central_planet)

	if not star_node or not planet_node:
		return

	# Direção do planeta em relação ao Sol
	var dir_planet_to_star = (planet_node.global_position - star_node.global_position).normalized()

	# Posiciona a lua a uma certa distância perpendicular ao vetor radial planeta-Sol
	var tangent = dir_planet_to_star.cross(Vector3.UP).normalized()
	var offset = tangent * distance_from_planet

	global_position = planet_node.global_position + offset


	_calcular_velocidade_inicial()	

func _calcular_velocidade_inicial():
	var rel_pos = global_position - planet_node.global_position
	var dist = rel_pos.length()

	if dist <= 0:
		return

	# Velocidade orbital da lua em relação ao planeta
	var speed = sqrt(G * planet_node.mass / dist)

	# Direção tangente à órbita (em plano horizontal)
	var dir = rel_pos.normalized()
	var tangent = dir.cross(Vector3.UP).normalized()

	# Herda a velocidade do planeta
	var v_planeta = planet_node.get_velocity() if planet_node.has_method("get_velocity") else Vector3.ZERO

	# Velocidade total = órbita ao redor do planeta + movimento do planeta ao redor do Sol
	velocity = tangent * speed + v_planeta

func _physics_process(delta):
	if not star_node or not planet_node:
		return

	var acc = Vector3.ZERO

	# Aceleração gravitacional do planeta
	var r_planet = planet_node.global_position - global_position
	var d_planet = r_planet.length()
	if d_planet > 0:
		acc += r_planet.normalized() * (G * planet_node.mass / (d_planet * d_planet))

	# Aceleração gravitacional do Sol
	var r_star = star_node.global_position - global_position
	var d_star = r_star.length()
	if d_star > 0:
		acc += r_star.normalized() * (G * star_node.mass / (d_star * d_star))

	# Atualiza movimento
	velocity += acc * delta
	global_position += velocity * delta

func get_velocity():
	return velocity
