extends RigidBody3D

const G = 3.0

@export var initial_velocity: Vector3 = Vector3.ZERO 
var bodies

@export var log_interval: float = 1.0 
var log_file: FileAccess
var time_accum: float = 0.0

func _ready():
	var path = "user://posicoesp2SegundaIteracao.txt"
	log_file = FileAccess.open(path, FileAccess.WRITE)
	if not log_file:
		push_error("Não foi possível abrir o arquivo para escrita.")
		return
	linear_velocity = initial_velocity

func _physics_process(delta):
	bodies = get_parent().get_children()
	var forces = []
	var total_force = Vector3.ZERO

	for body in bodies:
		if body == self or !(body is RigidBody3D):
			continue

		var direction = body.global_position - global_position
		var dist_sq = direction.length_squared()
		if dist_sq == 0:
			continue

		var force_magnitude = G * mass * body.mass / dist_sq
		var gravitational_force = direction.normalized() * force_magnitude
		
		forces.append(gravitational_force)
		
	for vector in forces:
		total_force += vector
	
	apply_central_force(total_force)

	var x = global_position.x
	var y = global_position.z 

	var line = "%f,%f" % [x, y]
	log_file.store_line(line)
