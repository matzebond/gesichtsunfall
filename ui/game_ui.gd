extends CanvasLayer

var game_timer: Timer
@onready var timer_label: Label = $VBoxContainer/HBoxContainer/LabelTime
@onready var fps_label: Label = $VBoxContainer/HBoxContainer2/LabelFps

func _on_game_state_manager_playing_started(game_timer: Timer) -> void:
	self.game_timer = game_timer

func _on_game_state_manager_playing_done() -> void:
	self.game_timer = null

func _process(delta: float) -> void:
	if game_timer:
		timer_label.text = str(int(game_timer.time_left))
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

func _on_game_state_manager_preview_started() -> void:
	timer_label.text = ""
