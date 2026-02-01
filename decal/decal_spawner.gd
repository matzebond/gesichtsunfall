extends Node3D

signal color_changed(color: Color, key_id: Global.BRUSH_COLOR_NAMES)
@export var decal_spawn_point: Node3D
@export var root_node: Node3D

# Decal Zeug
var decal_scene = preload("res://decal/decal.tscn")
var spawned_decals: Array[Decal] = []

# Brush Zeug
var selected_brush_color_name: Global.BRUSH_COLOR_NAMES

# Decal Zeug
var last_pos = Vector3.ZERO
var distance_threshold = 0.5
var spawning_enabled = false
@export var size = 2.0
@export var size_increase = 0.5
@export var max_size = 100
@export var min_size = 1

func _ready() -> void:
	selected_brush_color_name = Global.BRUSH_COLOR_NAMES.YELLOW
	color_changed.emit(selected_brush_color_name, 0)

func enable_spawning(enable: bool):
	spawning_enabled = enable
	print("Enabled spawning")

func change_size(amount: float):
	size += amount
	size = clamp(size, min_size, max_size)
	print("Updated brush size to ", size)

func _process(_delta: float) -> void:
	var brush_keys = Global.BRUSH_COLORS.keys()
	var brush_count = brush_keys.size()
	var brush_idx = Global.BRUSH_COLORS.keys().find(selected_brush_color_name)
	print(Global.BRUSH_COLORS.keys())
	print(selected_brush_color_name)

	if Input.is_action_just_pressed("player_brush_next"):
		brush_idx = (brush_idx + 1) % brush_count
	if Input.is_action_just_pressed("player_brush_previous"):
		brush_idx = posmod(brush_idx - 1, brush_count)
	for i in range(brush_count):
		if Input.is_action_just_pressed("player_brush_" + str(i + 1)):
			brush_idx = i
			break

	print("IDX", brush_idx)
	selected_brush_color_name = brush_idx
	color_changed.emit(selected_brush_color_name, brush_idx)
	print("Selected brush: ", selected_brush_color_name)

	if Input.is_action_just_pressed("player_increase_brush_size"):
		change_size(size_increase)
	elif Input.is_action_just_pressed("player_decrease_brush_size"):
		change_size(-size_increase)

	if spawning_enabled and decal_spawn_point.global_position.distance_to(last_pos) > distance_threshold:
		spawn_decal()
		last_pos = decal_spawn_point.global_position

func spawn_decal(new_decal_position = null):
	if new_decal_position == null:
		new_decal_position = decal_spawn_point.global_position
	var d = decal_scene.instantiate()
	root_node.add_child(d)
	d.global_position = new_decal_position
	d.size = Vector3(size, size, size)
	d.modulate = Global.BRUSH_COLORS[selected_brush_color_name]
	paint_over_decals(d.position)
	spawned_decals.append(d)

func paint_over_decals(new_decal_position: Vector3):
	#print(new_decal_position)
	var decals_to_remove = []
	var overlap_threshold = 0.8
	var new_radius = size / 2.0
	for decal in spawned_decals:
		var existing_radius = decal.size.x / 2.0
		var max_distance = (existing_radius + new_radius) * overlap_threshold
		if decal.position.distance_to(new_decal_position) < max_distance:
			if decal.modulate != Global.BRUSH_COLORS[selected_brush_color_name]:
				decals_to_remove.append(decal)
	for i in range(spawned_decals.size() - 1, -1, -1):
		if spawned_decals[i] in decals_to_remove:
			spawned_decals[i].queue_free()
			spawned_decals.remove_at(i)

func erase_decals(new_decal_position: Vector3):
	var decals_to_remove = []
	var overlap_threshold = 0.8
	var new_radius = size / 2.0
	for decal in spawned_decals:
		var existing_radius = decal.size.x / 2.0
		var max_distance = (existing_radius + new_radius) * overlap_threshold
		if decal.position.distance_to(new_decal_position) < max_distance:
			decals_to_remove.append(decal)
	for i in range(spawned_decals.size() - 1, -1, -1):
		if spawned_decals[i] in decals_to_remove:
			spawned_decals[i].queue_free()
			spawned_decals.remove_at(i)
