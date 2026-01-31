extends Node3D

@export var decal_spawn_point: Node3D
@export var root_node: Node3D

# Decal Zeug
var decal_scene = preload("res://decal/decal.tscn")

# Brush Zeug
@export var brush_colors: Array[Color]
var selected_brush_color: Color

# Decal Zeug
var last_pos = Vector3.ZERO
var distance_threshold = 0.5
var spawning_enabled = false

func _ready() -> void:
	assert(len(brush_colors) > 0, "Must set at least one brush color")
	assert(len(brush_colors) <= 9, "At most 9 brush colors are supported")
	selected_brush_color = brush_colors[0]

func enable_spawning(enable: bool):
	spawning_enabled = enable
	
func _spawn_decal():
	var d = decal_scene.instantiate()
	root_node.get_parent().add_child(d)
	d.global_position = decal_spawn_point.global_position
	d.modulate = selected_brush_color

func _process(_delta: float) -> void:
	var brush_count = 9
	for brush in range(brush_count):
		if Input.is_action_just_pressed("player_brush_" + str(brush + 1)):
			# Check if valid brush color
			if brush < len(brush_colors):
				selected_brush_color = brush_colors[brush]
				print("Selected brush ", brush + 1)
				break

	if spawning_enabled and decal_spawn_point.global_position.distance_to(last_pos) > distance_threshold:
		_spawn_decal()
		last_pos = decal_spawn_point.global_position
