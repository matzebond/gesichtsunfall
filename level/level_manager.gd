extends Node3D

@onready var level_mesh: Node3D = $Face
@onready var level_objective_mesh: Node3D = $FaceWithMask
@onready var target_objective_final_position = level_objective_mesh.position

func _on_game_state_manager_preview_started() -> void:
	level_mesh.visible = false
	level_objective_mesh.visible = true
	level_objective_mesh.position = Vector3.ZERO

func _on_game_state_manager_playing_started(_game_timer: Timer) -> void:
	level_mesh.visible = true
	level_objective_mesh.visible = false

func _on_game_state_manager_playing_done() -> void:
	level_mesh.visible = true
	level_objective_mesh.position = target_objective_final_position
	level_objective_mesh.visible = true

func _ready() -> void:
	$ScoringNode.levelDecalsNode = $FaceWithMask.mask_instance
