extends RigidBody3D

const G = 1.0

@export var initial_velocity: Vector3 = Vector3.ZERO 
var bodies

func _ready():
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
	
	print(self, "  ", total_force)
	apply_central_force(total_force)

	
