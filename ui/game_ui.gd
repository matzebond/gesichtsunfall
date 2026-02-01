extends CanvasLayer

var game_timer: Timer
@onready var timer_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/Panel/LabelTime
@onready var fps_label: Label = $MarginContainer/VBoxContainer/HBoxContainer2/LabelFps
@onready var score_progress: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/ProgressBar
@onready var top_bar: Control = $MarginContainer/VBoxContainer/HBoxContainer

func _on_game_state_manager_playing_started(game_timer: Timer) -> void:
	self.game_timer = game_timer
	timer_label.text = ""
	top_bar.visible = true

func _on_game_state_manager_playing_done() -> void:
	self.game_timer = null

func _process(delta: float) -> void:
	if game_timer:
		timer_label.text = str(int(game_timer.time_left))
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

func _on_game_state_manager_preview_started() -> void:
	top_bar.visible = false


func _on_scoring_percent_changed(percent: float) -> void:
	score_progress.value = percent
