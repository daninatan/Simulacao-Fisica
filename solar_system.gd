extends Node3D

func _ready():
	var bodies = get_tree().get_nodes_in_group("gravity_bodies")

	for body in bodies:
		body.all_bodies = bodies
