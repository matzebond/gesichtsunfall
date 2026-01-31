extends VehicleBody3D

@onready var decal_spawn_point = $DecalSpawnPoint

var decal_scene = preload("res://player/decal.tscn")

# Decal Zeug
var last_pos = Vector3.ZERO
var distance_threshold = 0.5

# Movement Zeug
var jump_force = 5.0

# Brush Zeug
var brush_down = true
@export var brush_colors: Array[Color]
var selected_brush_color: Color

# Arm-Bewegungs-Zeug
var arm_angle = 0

var disable_controls = false

@export var MAX_STEER = 0.2
@export var ENGINE_POWER = 450

func _ready() -> void:
	assert(len(brush_colors) > 0, "Must set at least one brush color")
	assert(len(brush_colors) <= 9, "At most 9 brush colors are supported")
	selected_brush_color = brush_colors[0]

func _process(delta: float) -> void:
	if arm_angle < 360:
		arm_angle += delta * 5
	else:
		arm_angle = 0
	$player_model/Cylinder_001.rotation = Vector3(arm_angle,0,0)

func _physics_process(delta):
	if disable_controls:
		return

	steering = move_toward(steering, Input.get_axis("player_right", "player_left") * MAX_STEER, delta * 1.5)
	engine_force = Input.get_axis("player_down", "player_up") * ENGINE_POWER

	# Handle jump (check if any contacts)
	# Das funktioniert nicht mehr, seit wir auf VehicleBody3D umgestiegen sind
	if Input.is_action_just_pressed("player_jump"):
		var contacts = get_contact_count()
		if contacts > 0:
			apply_central_impulse(Vector3.UP * jump_force)

	# Handle brush toggle
	if Input.is_action_just_pressed("player_brush"):
		toggle_brush()

	# Handle scene reset
	if Input.is_action_just_pressed("ui_cancel"):  # ESC key
		get_tree().reload_current_scene()

	process_decal()
	process_brush_selected()

func toggle_brush() -> void:
	brush_down = !brush_down

func process_decal():
	if brush_down and global_position.distance_to(last_pos) > distance_threshold:
		spawn_decal()
		last_pos = global_position

func process_brush_selected():
	var brush_count = 9
	for brush in range(brush_count):
		if Input.is_action_just_pressed("player_brush_" + str(brush + 1)):
			# Check if valid brush color
			if brush < len(brush_colors):
				selected_brush_color = brush_colors[brush]
				print("Selected brush ", brush + 1)
				break

func spawn_decal():
	var d = decal_scene.instantiate()
	get_parent().add_child(d)
	d.global_position = decal_spawn_point.global_position
	d.modulate = selected_brush_color

func get_camera() -> Camera3D:
	return $SpringArm3D/Camera3D

func _on_game_state_manager_preview_started() -> void:
	disable_controls = true

func _on_game_state_manager_playing_started(_game_timer: Timer) -> void:
	disable_controls = false

func _on_game_state_manager_playing_done() -> void:
	disable_controls = true
