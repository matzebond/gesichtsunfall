@tool
extends CanvasLayer

var game_timer: Timer
@onready var timer_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/Panel/LabelTime
@onready var fps_label: Label = $MarginContainer/VBoxContainer/LabelFps
@onready var score_progress: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/ProgressBar
@onready var top_bar: Control = $MarginContainer/VBoxContainer/HBoxContainer
@onready var color_selector: Control = $MarginContainer/VBoxContainer/ColorSelector
@onready var rating_ui: Control = $MarginContainer/VBoxContainer/Rating
@onready var rating_ui_back_button: Control = $MarginContainer/VBoxContainer/Rating/BackButton

func _ready() -> void:
	rating_ui.visible = false

func _on_game_state_manager_playing_started(game_timer: Timer) -> void:
	self.game_timer = game_timer
	timer_label.text = ""
	top_bar.visible = true
	color_selector.visible = true
	rating_ui.visible = false

func _on_game_state_manager_playing_done() -> void:
	self.game_timer = null
	rating_ui.visible = true
	rating_ui_back_button.grab_focus()
	color_selector.visible = false

func _process(delta: float) -> void:
	if game_timer:
		timer_label.text = str(int(game_timer.time_left))
	if not Engine.is_editor_hint():
		fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

func _on_game_state_manager_preview_started() -> void:
	top_bar.visible = false
	color_selector.visible = false

func _on_scoring_percent_changed(percent: float) -> void:
	score_progress.value = percent


func _on_player_brush_color_changed(color: Color, key_id: int) -> void:
	color_selector.on_color_key_id_changed(key_id)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/level_preview_selection.tscn")
