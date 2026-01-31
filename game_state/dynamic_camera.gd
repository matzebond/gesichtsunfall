extends Camera3D

@export var static_camera_preview: Camera3D
@export var static_camera_rating: Camera3D
@export var player: Node

@onready var player_camera: Camera3D = player.get_camera()

var _transition_tween: Tween


func _on_game_state_manager_preview_started() -> void:
	# Snap this cam to the static cam and make it current
	_copy_camera_pose(static_camera_preview, self)
	self.current = true

func _on_game_state_manager_preview_done() -> void:
	_interpolate_camera(self, static_camera_preview, player_camera, 0.7)

func _on_game_state_manager_playing_done() -> void:
	_interpolate_camera(self, player_camera, static_camera_rating, 0.7)

func _copy_camera_pose(source_camera: Camera3D, target_camera: Camera3D) -> void:
	target_camera.global_transform = source_camera.global_transform
	
func _interpolate_camera(camera: Camera3D, source_camera: Camera3D, target_camera: Camera3D, transition_time: float) -> void:
	_copy_camera_pose(source_camera, camera)
	camera.current = true

	if _transition_tween and _transition_tween.is_valid():
		_transition_tween.kill()

	var target_pos: Vector3 = target_camera.global_transform.origin
	var target_basis: Basis = target_camera.global_transform.basis
	var target_quat: Quaternion = target_basis.get_rotation_quaternion()

	# Current pose
	var start_pos: Vector3 = source_camera.global_transform.origin
	var start_quat: Quaternion = source_camera.global_transform.basis.get_rotation_quaternion()

	_transition_tween = create_tween()
	_transition_tween.set_trans(Tween.TRANS_SINE)
	_transition_tween.set_ease(Tween.EASE_IN_OUT)

	_transition_tween.tween_method(func(t: float) -> void:
		camera.global_transform.origin = start_pos.lerp(target_pos, t)
		var q := start_quat.slerp(target_quat, t)
		var b := Basis(q)
		camera.global_transform.basis = b,
		0.0, 1.0, transition_time
	)

	_transition_tween.finished.connect(func():
		target_camera.current = true
	)
