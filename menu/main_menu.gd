extends CanvasLayer


func _on_select_level_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/level_selection.tscn")
