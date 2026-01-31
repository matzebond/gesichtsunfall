extends Node3D

# Decal Zeug
var last_pos = Vector3.ZERO
var distance_threshold = 0.5

@onready var decal_spawner = $DecalSpawner
@onready var decal_spawn_point = $DecalSpawnPoint
@onready var ray_cast: RayCast3D = $RayCast3D
@onready var camera: Camera3D = $Camera3D
@export var save_path = "res://level/editor/level.tscn"

func _process(delta: float) -> void:
	var pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)	
	if pressed:
		var mouse_pos = camera.get_viewport().get_mouse_position()
		ray_cast.position = camera.project_ray_origin(mouse_pos)
		ray_cast.target_position = camera.project_ray_normal(mouse_pos) * 1000
		
		if ray_cast.is_colliding():
			decal_spawn_point.global_position = ray_cast.get_collision_point()
			decal_spawner.spawn_decal()
			
func save():
	$CanvasLayer/Label.text = "Saving..."
	var root = Node3D.new()
	root.name = "Level"
	for child in $Decals.get_children():
		if child == decal_spawner.root_node:
			continue
		var duplicated_child = child.duplicate()
		root.add_child(duplicated_child)
	_set_owner_recursive(root, root)
	print("Total of %d nodes packed" % root.get_child_count())
	
	var scene = PackedScene.new()
	var ok := scene.pack(root)
	
	if ok != OK:
		printerr("Failed to pack decals scene")
		$CanvasLayer/Label.text = "Error"
		return

	var err := ResourceSaver.save(scene, save_path)
	if err != OK:
		printerr("Save failed: %s" % err)
		$CanvasLayer/Label.text = "Error"
		return
	
	scene.take_over_path(save_path)
	print("Successfully saved to %s (if it does not show/update try leaving and entering godot window again)" % save_path)
	$CanvasLayer/Label.text = "OK"


func _set_owner_recursive(n: Node, owner: Node) -> void:
	n.owner = owner
	for c in n.get_children():
		_set_owner_recursive(c, owner)
