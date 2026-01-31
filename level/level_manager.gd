extends Node3D


@onready var level_mesh: Node3D = $LevelMesh
@onready var level_objective_mesh: Node3D = $LevelObjectiveMesh

func _on_game_state_manager_preview_started() -> void:
	level_mesh.visible = false
	level_objective_mesh.visible = true
	level_objective_mesh.position = Vector3.ZERO

func _on_game_state_manager_playing_started(_game_timer: Timer) -> void:
	level_mesh.visible = true
	level_objective_mesh.visible = false

func _on_game_state_manager_playing_done() -> void:
	level_mesh.visible = true
	level_objective_mesh.position = Vector3(122, 0, 0)
	level_objective_mesh.visible = true
	
func load_level(level_scene: PackedScene):
	# remove prev level
	if level_objective_mesh.has_node("Level"):
		var prev_level = level_objective_mesh.get_node("Level")
		level_objective_mesh.remove_child(prev_level)
		prev_level.queue_free()
	
	# add new level
	var new_level = level_scene.instantiate()
	level_objective_mesh.add_child(new_level)
	
	# reattach Scoring to level
	$ScoringNode.levelDecalsNode = new_level

func _ready():
	load_level(Global.selected_level)
	
	
