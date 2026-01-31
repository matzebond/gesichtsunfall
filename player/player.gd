extends VehicleBody3D

# Movement Zeug
var throttle: float = 0.0

var prev_brush_down = false

@export_group("Speed")
## hängt auf jeden fall von mass ab
@export var ENGINE_POWER = 550
## alles fake
@export var max_speed = 50.0
## eben so fake
@export var acceleration: float = 120
var vehicle_linear_velocity: float = 0.0

@export_group("Steering & Brake")
var steering_input
@export var steering_speed = 2.5
@export var max_steering_angle = 1.65
@export var steering_speed_air = 40000.0
## unused
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

@export_group("Decal")
@export var decal_root_node: Node3D:
	set(value):
		_decal_root_node = value
		$DecalSpawner.root_node = value
	get:
		return _decal_root_node
var _decal_root_node: Node3D

# Arm-Bewegungs-Zeug
var arm_angle = 0
var spawn_position
var disable_controls = false

var in_air_time = 0
var allow_yeehaw = 0


func _ready() -> void:
	for wheel: VehicleWheel3D in [front_left_wheel, front_right_wheel]:
		pass # man könnte hier iwie was berechnen
	$GPUParticles3D.emitting = false
	spawn_position = position

func _process(delta: float) -> void:
	
	arm_angle = fmod(arm_angle + delta * linear_velocity.length() * 0.75, 360)
	
	$player_model/arm_mit_hut.rotation = Vector3(-arm_angle,0,0)

	# Handle scene reset
	if Input.is_action_just_pressed("ui_cancel"):  # ESC key
		get_tree().reload_current_scene()

func _physics_process(delta):
	if disable_controls:
		return

	if Input.is_action_just_pressed("player_reset"):
		reset_position()

	handle_vehicle_control(delta)
	handle_engine_velocity()
	handle_anti_roll_force()
	handle_speed_based_downforce()
	handle_air_control(delta)
	handle_decal()

func handle_vehicle_control(delta):
	steering_input = Input.get_axis("player_right", "player_left")
	steering = move_toward(steering, steering_input * max_steering_angle, delta * steering_speed)

func handle_engine_velocity():
	engine_force = Input.get_axis("player_down", "player_up") * ENGINE_POWER

	if Input.is_action_pressed("player_down"):
		$player_model/Cylinder.rotation_degrees = Vector3(-15,0,0)
		$player_model/Cylinder_001.rotation_degrees = Vector3(-15,0,0)
	else:
		$player_model/Cylinder.rotation_degrees = Vector3(30,0,0)
		$player_model/Cylinder_001.rotation_degrees = Vector3(30,0,0)

	# Calculate engine force
	vehicle_linear_velocity = linear_velocity.length()
	var speed_factor = 1.0 - min(vehicle_linear_velocity / max_speed, 1.0)
	# Apply to vehicle
	#engine_force = throttle * acceleration * speed_factor
	AudioManager.set_global_parameter("Speed", speed_factor)

func handle_anti_roll_force():
	anti_roll_torque = -global_transform.basis.x * global_rotation.x * anti_roll_force * max_speed
	apply_torque(anti_roll_torque)

func handle_speed_based_downforce():
	# oder get_contact_count()
	if not any_wheel_in_contact():
		return

	downforce = -global_transform.basis.y * linear_velocity.length() * downforce_factor
	apply_central_force(downforce)

func handle_air_control(delta):
	
	var in_air = not any_wheel_in_contact()
	
	if in_air:
		in_air_time += get_process_delta_time()
	else:
		if in_air_time > 1:
			AudioManager.play_one_shot("Land", transform)
		in_air_time = 0
		allow_yeehaw -= get_process_delta_time()
		return
		
	if in_air_time >= 0.1 and allow_yeehaw <= 0:
		AudioManager.play_one_shot("Yeehaw", transform)
		allow_yeehaw = 5

	var air_control_torque = global_transform.basis.y * steering_input * steering_speed_air
	apply_torque(air_control_torque * delta)

func any_wheel_in_contact():
	for wheel:VehicleWheel3D in [front_left_wheel, front_right_wheel, rear_left_wheel, rear_right_wheel]:
		if wheel.is_in_contact():
			return true
	return false
	
func set_particle_color(color: Color):
	$GPUParticles3D.draw_pass_1.material.albedo_color = color

func handle_decal():
	var brush_down = Input.is_action_pressed("player_brush_down")
	$GPUParticles3D.emitting = brush_down
	$DecalSpawner.enable_spawning(brush_down)
	if brush_down and not prev_brush_down:
		AudioManager.play_event("Painting")
	elif not brush_down and prev_brush_down:
		AudioManager.stop_event("Painting")
	prev_brush_down = brush_down

func reset_position():
	position = spawn_position
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

func get_camera() -> Camera3D:
	return $SpringArm3D/Camera3D

func _on_game_state_manager_preview_started() -> void:
	disable_controls = true
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_game_state_manager_playing_started(_game_timer: Timer) -> void:
	disable_controls = false
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT

func _on_game_state_manager_playing_done() -> void:
	disable_controls = true
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_decal_spawner_color_changed(color: Color) -> void:
	set_particle_color(color)
