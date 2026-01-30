extends CanvasLayer

var game_timer: Timer
@onready var game_timer_label: Label = $VBoxContainer/HBoxContainer/Label

func _on_game_state_manager_playing_started(game_timer: Timer) -> void:
	self.game_timer = game_timer

func _on_game_state_manager_playing_done() -> void:
	self.game_timer = null

func _process(delta: float) -> void:
	if game_timer:
		game_timer_label.text = str(int(game_timer.time_left))

func _on_game_state_manager_preview_started() -> void:
	game_timer_label.text = ""
