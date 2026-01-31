extends Node

@export var debug: bool = false

signal preview_started()
signal preview_done()
signal playing_started(game_timer: Timer)
signal playing_done()


var current_state: GameState

enum GameState {
	PREVIEW,
	PLAYING,
	RATING
}

func _ready() -> void:
	var initial_state: GameState = GameState.PLAYING if debug else GameState.PREVIEW
	set_current_state(initial_state)

func set_current_state(new_state: GameState):
	print("GameStateManager: entering state ", GameState.keys()[new_state])
	
	current_state = new_state
	
	match current_state:
		GameState.PREVIEW:
			$PreviewTimer.start()
			preview_started.emit()
			AudioManager.play_one_shot("Gong")
		GameState.PLAYING:
			$PlayingTimer.start()
			if not debug:
				preview_done.emit()
			playing_started.emit($PlayingTimer)
		GameState.RATING:
			playing_done.emit()

func _on_preview_timer_timeout() -> void:
	set_current_state(GameState.PLAYING)


func _on_playing_timer_timeout() -> void:
	if not debug:
		set_current_state(GameState.RATING)
