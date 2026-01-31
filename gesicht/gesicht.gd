extends Node3D

func _ready() -> void:
	$spahn.create_trimesh_collision()
	$spahn.get_child(0).get_child(0).shape.backface_collision = true
