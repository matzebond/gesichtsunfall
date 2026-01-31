extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Plane.create_trimesh_collision()
	$Plane.get_child(0).get_child(0).shape.backface_collision = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
