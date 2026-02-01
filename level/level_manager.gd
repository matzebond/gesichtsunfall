extends Node3D

@onready var level_mesh: Node3D = $Face
@onready var level_objective_mesh: Node3D = $FaceWithMask
@onready var target_objective_final_position = level_objective_mesh.position

@export var preview_cam:Camera3D
@export var final_cam:Camera3D
@export var mini_cam:Camera3D

var objective_x

func _on_game_state_manager_preview_started() -> void:
	level_mesh.visible = false
	level_objective_mesh.visible = true
	level_objective_mesh.position = Vector3.ZERO

func _on_game_state_manager_playing_started(_game_timer: Timer) -> void:
	level_mesh.visible = true
	level_objective_mesh.visible = false

func _on_game_state_manager_playing_done() -> void:
	level_mesh.visible = true
	level_objective_mesh.position.x = objective_x
	level_objective_mesh.visible = true

func _ready() -> void:
	$ScoringNode.levelDecalsNode = $FaceWithMask.mask_instance
	# move the cameras according the the magic values for the current face
	# TODO don't do that if the face was selected by a different method (run scene manually)
	objective_x = (220/160) * Global.FACE_INFO[Global.selected_face]["zoom"] * 1.6
	print(objective_x)
	preview_cam.position.y = Global.FACE_INFO[Global.selected_face]["zoom"]
	preview_cam.position.z = Global.FACE_INFO[Global.selected_face]["cam_pos"]
	final_cam.position.x = objective_x / 2
	final_cam.position.y = Global.FACE_INFO[Global.selected_face]["zoom"]
	final_cam.position.z = Global.FACE_INFO[Global.selected_face]["cam_pos"]
	mini_cam.position.y = Global.FACE_INFO[Global.selected_face]["zoom"]
	mini_cam.position.z = Global.FACE_INFO[Global.selected_face]["cam_pos"]
