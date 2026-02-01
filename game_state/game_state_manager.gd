extends Node

@export var debug: bool = false

signal preview_started()
signal preview_done()
signal playing_started(game_timer: Timer)
signal playing_done()
signal pause()
signal unpause()


var current_state: GameState

enum GameState {
	PREVIEW,
	PLAYING,
	RATING,
	PAUSED
}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Global.pause_signal.connect(set_current_state.bind(GameState.PAUSED))
	Global.unpause_signal.connect(set_current_state.bind(GameState.PLAYING))
	var initial_state: GameState = GameState.PLAYING if debug else GameState.PREVIEW
	set_current_state(initial_state)

func set_current_state(new_state: GameState):
	print("GameStateManager: entering state ", GameState.keys()[new_state])
	#On leaving state
	var previous_state = current_state
	if(new_state == GameState.PAUSED):
		if(current_state!=GameState.PLAYING):
			return

	current_state = new_state
	
	match previous_state:
		GameState.PAUSED:
			$PauseMenu.hide()
			$PlayingTimer.paused = false
			get_tree().paused=false
			if(current_state == GameState.PLAYING):
				return
	
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
		GameState.PAUSED:
			$PauseMenu.show()
			$PlayingTimer.paused = true
			get_tree().paused=true
		GameState.RATING:
			playing_done.emit()

func _on_preview_timer_timeout() -> void:
	set_current_state(GameState.PLAYING)

func _on_playing_timer_timeout() -> void:
	if not debug:
		set_current_state(GameState.RATING)
