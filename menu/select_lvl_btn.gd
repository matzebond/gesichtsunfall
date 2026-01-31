extends Button
@export_file("*.tscn") var level: String

func _ready():
	disabled = (level == null or level == "")

func _pressed() -> void:
	Global.selected_level = load(level)
	get_tree().change_scene_to_file("res://main.tscn")
