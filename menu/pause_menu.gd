extends CanvasLayer
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _on_btn_continue_pressed() -> void:
	print("press")
	Global.emit_signal("unpause_signal")
	self.hide()

func _on_btn_reset_pressed() -> void:
	get_tree().reload_current_scene()

func _on_btn_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")
