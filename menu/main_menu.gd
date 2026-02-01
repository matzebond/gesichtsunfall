extends CanvasLayer

func _ready():
	$VBoxContainer/select_level_btn.grab_focus()
	AudioManager.suppress_bgm(true)

func _on_select_level_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/level_preview_selection.tscn")

func _on_controls_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/ControlsMenu.tscn")

func _on_exit_btn_pressed() -> void:
	get_tree().quit()
