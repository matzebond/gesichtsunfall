extends VehicleBody3D

# Movement Zeug
var throttle: float = 0.0
var steering_input: float = 0.0

@export_group("Speed")
## hängt auf jeden fall von mass ab
@export var ENGINE_POWER = 450
## alles fake
@export var max_speed = 50.0
## eben so fake
@export var acceleration: float = 120
var vehicle_linear_velocity: float = 0.0

@export_group("Steering & Brake")
@export var steering_speed = 5.5
@export var max_steering_angle = 0.65
@export var handbrake_force = 5.0
var handbrake: bool = false

@export_group("Wheel")
@export var front_left_wheel: VehicleWheel3D
@export var front_right_wheel: VehicleWheel3D
@export var rear_left_wheel: VehicleWheel3D
@export var rear_right_wheel: VehicleWheel3D

#@export_group("Suspension Setting")
#@export var wheel_friction: float = 10.5
#@export var suspension_stiff_value: float = 180.0

@export_group("Stability Control")
@export var roll_influence: float = 0.5
var anti_roll_torque: Vector3
var downforce: Vector3
@export var anti_roll_force: float = 20.0  # Force to resist rolling
@export var downforce_factor: float = 50.0 # Pushes car down at speed

@export_group("Brush")
var brush_down = true

# Decal Zeug
var last_pos = Vector3.ZERO
var distance_threshold = 0.5

# Arm-Bewegungs-Zeug
var arm_angle = 0

var disable_controls = false


func _ready() -> void:
	for wheel: VehicleWheel3D in [front_left_wheel, front_right_wheel]:
		pass # man könnte hier iwie was berechnen
		
func _process(delta: float) -> void:
	if arm_angle < 360:
		arm_angle += delta * 5
	else:
		arm_angle = 0
	$player_model/Cylinder_001.rotation = Vector3(arm_angle,0,0)
	
	
	# Handle scene reset
	if Input.is_action_just_pressed("ui_cancel"):  # ESC key
		get_tree().reload_current_scene()

func _physics_process(delta):
	if disable_controls:
		return

	# Handle brush toggle
	if Input.is_action_just_pressed("player_brush"):
		toggle_brush()

	handle_vehicle_control(delta)
	handle_engine_velocity()
	handle_anti_roll_force()
	handle_speed_based_downforce()

	process_decal()

func handle_vehicle_control(delta):
	steering_input = Input.get_axis("player_right", "player_left")
	steering = move_toward(steering, steering_input, delta * steering_speed)

func handle_engine_velocity():
	engine_force = Input.get_axis("player_down", "player_up") * ENGINE_POWER

	# Calculate engine force
	vehicle_linear_velocity = linear_velocity.length()
	var speed_factor = 1.0 - min(vehicle_linear_velocity / max_speed, 1.0)
	# Apply to vehicle
	#engine_force = throttle * acceleration * speed_factor

func handle_anti_roll_force():
	anti_roll_torque = -global_transform.basis.x * global_rotation.x * anti_roll_force * max_speed
	apply_torque(anti_roll_torque)
	
func handle_speed_based_downforce():
	# oder get_contact_count()
	if not any_wheel_in_contact():
		return

	downforce = -global_transform.basis.y * linear_velocity.length() * downforce_factor
	apply_central_force(downforce)

func any_wheel_in_contact():
	for wheel:VehicleWheel3D in [front_left_wheel, front_right_wheel, rear_left_wheel, rear_right_wheel]:
		if wheel.is_in_contact():
			return true

func toggle_brush() -> void:
	brush_down = !brush_down

func process_decal():
	if brush_down and global_position.distance_to(last_pos) > distance_threshold:
		$DecalSpawner.spawn_decal()
		last_pos = global_position

func get_camera() -> Camera3D:
	return $SpringArm3D/Camera3D

func _on_game_state_manager_preview_started() -> void:
	disable_controls = true

func _on_game_state_manager_playing_started(_game_timer: Timer) -> void:
	disable_controls = false

func _on_game_state_manager_playing_done() -> void:
	disable_controls = true
