extends CanvasLayer

func _ready():
	$MarginContainer/VBoxContainer/CenterContainer/btn_back.grab_focus()
	AudioManager.suppress_bgm(true)
	
func _on_btn_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")
