extends Camera3D

@onready var minimap = $"../../Minimap"
func _process(delta: float) -> void:
	var playerPos = unproject_position($"../../player".global_position)
	$"../../Minimap/PlayerMarker".global_position = minimap.global_position+playerPos * minimap.scale.x
	$"../../Minimap/PlayerMarker/Label".text = str(playerPos)#/#+$"../../Sprite2D".position


func _on_game_state_manager_playing_started(game_timer: Timer) -> void:
	minimap.visible = true

func _on_game_state_manager_playing_done() -> void:
	minimap.visible = false

func _on_game_state_manager_preview_started() -> void:
	minimap.visible = false
