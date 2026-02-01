extends Node3D

@export var mesh_for_collider: Node

func _ready() -> void:
	if $spahn:
		$spahn.create_trimesh_collision()
		$spahn.get_child(0).get_child(0).shape.backface_collision = true

	if $Plane:
		$Plane.create_trimesh_collision()
		$Plane.get_child(0).get_child(0).shape.backface_collision = true

	if $Suzanne:
		$Suzanne.create_trimesh_collision()
		$Suzanne.get_child(0).get_child(0).shape.backface_collision = true
