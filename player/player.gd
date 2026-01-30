extends RigidBody3D

@onready var animation_player = $AnimationPlayer
var trail_scene = preload("res://player/decal.tscn")
var last_pos = Vector3.ZERO
var distance_threshold = 0.5

# Movement settings
var forward_speed = 5.0
var min_speed = 2.0
var max_speed = 100.0
var acceleration = 5.0
var rotation_speed = 2.0
var jump_force = 5.0

# Brush state
var brush_down = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:

	# Handle jump (check if any contacts)
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

	# Handle speed control
	if Input.is_action_pressed("player_up"):
		forward_speed += acceleration * delta
	elif Input.is_action_pressed("player_down"):
		forward_speed -= acceleration * delta

	# Clamp speed to min/max range
	forward_speed = clamp(forward_speed, min_speed, max_speed)

	# Handle rotation using torque
	var rotation_input = 0.0
	if Input.is_action_pressed("player_left"):
		rotation_input = 1.0
	elif Input.is_action_pressed("player_right"):
		rotation_input = -1.0

	rotate_y(rotation_input * rotation_speed * delta)

	# Always move forward in the direction the player is facing
	var forward_direction = -transform.basis.x
	var target_velocity = forward_direction * forward_speed

	# Apply force to reach target velocity
	var velocity_diff = target_velocity - Vector3(linear_velocity.x, 0, linear_velocity.z)
	apply_central_force(velocity_diff * mass * 10.0)
	process_decal()


func toggle_brush() -> void:
	brush_down = !brush_down
	if brush_down:
		animation_player.play("brush_down")
	else:
		animation_player.play_backwards("brush_down")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func process_decal():
	if global_position.distance_to(last_pos) > distance_threshold:
		spawn_decal()
		last_pos = global_position
	
func spawn_decal():
	var t = trail_scene.instantiate()
	get_parent().add_child(t)
	# Spawn at player's current position
	t.global_position = global_position
