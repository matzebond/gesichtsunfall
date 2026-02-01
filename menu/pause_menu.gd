extends CanvasLayer

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED

func open():
	self.show()
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
func close():
	self.hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	Global.emit_signal("unpause_signal")
	
func _process(delta):
	if Input.is_action_just_pressed("player_jump"):
		close()
		
func _on_btn_continue_pressed() -> void:
	close()
	

func _on_btn_reset_pressed() -> void:
	get_tree().reload_current_scene()

func _on_btn_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")
