extends Node3D

@export var decal_spawn_point: Node3D
@export var root_node: Node3D

# Decal Zeug
var decal_scene = preload("res://decal/decal.tscn")
var spawned_decals: Array[Decal] = []

# Brush Zeug
@export var brush_colors: Array[Color]
var selected_brush_color: Color

# Decal Zeug
var last_pos = Vector3.ZERO
var distance_threshold = 0.5
var spawning_enabled = false
var size = 1.0

func _ready() -> void:
	assert(len(brush_colors) > 0, "Must set at least one brush color")
	assert(len(brush_colors) <= 9, "At most 9 brush colors are supported")
	selected_brush_color = brush_colors[0]

func enable_spawning(enable: bool):
	spawning_enabled = enable

func change_size(amount: float):
	size += amount
	size = clamp(size, 1.0, 10.0)
	print("Updated brush size to ", size)

func _process(_delta: float) -> void:
	var brush_count = 9
	for brush in range(brush_count):
		if Input.is_action_just_pressed("player_brush_" + str(brush + 1)):
			# Check if valid brush color
			if brush < len(brush_colors):
				selected_brush_color = brush_colors[brush]
				print("Selected brush ", brush + 1)
				break
	if Input.is_action_just_pressed("player_increase_brush_size"):
		change_size(0.5)
	elif Input.is_action_just_pressed("player_decrease_brush_size"):
		change_size(-0.5)

	if spawning_enabled and decal_spawn_point.global_position.distance_to(last_pos) > distance_threshold:
		_spawn_decal()
		last_pos = decal_spawn_point.global_position

func _spawn_decal():
	var d = decal_scene.instantiate()
	root_node.get_parent().add_child(d)
	var new_decal_position = decal_spawn_point.global_position
	d.global_position = new_decal_position
	d.size = Vector3(size, size, size)
	d.modulate = selected_brush_color
	paint_over_decals(d.position)
	spawned_decals.append(d)

func paint_over_decals(new_decal_position: Vector3):
	var decals_to_remove = []
	var overlap_threshold = 0.8
	var new_radius = size / 2.0
	for decal in spawned_decals:
		var existing_radius = decal.size.x / 2.0
		var max_distance = (existing_radius + new_radius) * overlap_threshold
		if decal.position.distance_to(new_decal_position) < max_distance:
			if decal.modulate != selected_brush_color:
				decals_to_remove.append(decal)
	for i in range(spawned_decals.size() - 1, -1, -1):
		if spawned_decals[i] in decals_to_remove:
			spawned_decals[i].queue_free()
			spawned_decals.remove_at(i)
