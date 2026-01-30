extends CharacterBody3D

@onready var animation_player = $AnimationPlayer

# Movement settings
var forward_speed = 5.0
var min_speed = 2.0
var max_speed = 10.0
var acceleration = 5.0
var rotation_speed = 2.0
var jump_velocity = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_select") and is_on_floor():  # Space bar
		velocity.y = jump_velocity

	# Handle brush animation
	if Input.is_action_just_pressed("ui_accept"):  # Enter key
		animation_player.play("brush_down")

	# Handle scene reset
	if Input.is_action_just_pressed("ui_cancel"):  # ESC key
		get_tree().reload_current_scene()

	# Handle speed control
	if Input.is_action_pressed("ui_up"):
		forward_speed += acceleration * delta
	elif Input.is_action_pressed("ui_down"):
		forward_speed -= acceleration * delta

	# Clamp speed to min/max range
	forward_speed = clamp(forward_speed, min_speed, max_speed)

	# Handle rotation
	var rotation_input = 0.0
	if Input.is_action_pressed("ui_left"):
		rotation_input = 1.0
	elif Input.is_action_pressed("ui_right"):
		rotation_input = -1.0

	rotate_y(rotation_input * rotation_speed * delta)

	# Always move forward in the direction the player is facing
	var forward_direction = -transform.basis.x
	velocity.x = forward_direction.x * forward_speed
	velocity.z = forward_direction.z * forward_speed

	move_and_slide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
