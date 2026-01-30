@tool
extends Node3D

@export var radius = 1.0
@export var color : Color
@export var deviation = Vector3(.1,.1,.1)
@export var isVisible : bool = true
var valid : bool = false


func _ready():
	pass

func _on_mesh_instance_3d_editor_state_changed() -> void:
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	pass

func evaluate():
	valid = false
	for decal in get_tree().get_nodes_in_group("decals"):
		if("color" in decal):
			if (decal.color.r - color.r < deviation.r) && (decal.color.g - color.g < deviation.g) && (decal.color.b - color.b < deviation.b):
				valid = true
	if(valid):
		$MeshInstance3D/Sprite3D.show()
	else:
		$MeshInstance3D/Sprite3D.hide()
	if(isVisible):
		self.show()
	else:
		self.hide()
	$MeshInstance3D.mesh.material.albedo_color = color
