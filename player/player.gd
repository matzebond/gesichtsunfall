extends VehicleBody3D

@onready var decal_spawn_point = $DecalSpawnPoint

var trail_scene = preload("res://player/decal.tscn")

# Decal Zeug
var last_pos = Vector3.ZERO
var distance_threshold = 0.5

# Movement Zeug
var jump_force = 5.0

# Brush state
var brush_down = true

# Arm-Bewegungs-Zeug
var arm_angle = 0

func _ready() -> void:
	pass # Replace with function body.

@export var MAX_STEER = 0.2
@export var ENGINE_POWER = 450

func _process(delta: float) -> void:
	if arm_angle < 360:
		arm_angle += delta * 5
	else:
		arm_angle = 0
	$player_model/Cylinder_001.rotation = Vector3(arm_angle,0,0)

func _physics_process(delta):
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

func toggle_brush() -> void:
	brush_down = !brush_down

func process_decal():
	if brush_down and global_position.distance_to(last_pos) > distance_threshold:
		spawn_decal()
		last_pos = global_position

func spawn_decal():
	var t = trail_scene.instantiate()
	get_parent().add_child(t)
	t.global_position = decal_spawn_point.global_position

func get_camera() -> Camera3D:
	return $SpringArm3D/Camera3D
