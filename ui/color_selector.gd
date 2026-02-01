@tool
extends Control

var color_button_scene = preload("res://ui/color_button.tscn")

func _ready() -> void:
	for child in get_children():
		child.queue_free()

	for i in range(len(Global.BRUSH_COLORS.keys())):
		var color_button = color_button_scene.instantiate()
		color_button.key_id = i
		add_child(color_button)

func on_color_key_id_changed(key_id: int):
	for child in get_children():
		child.on_color_key_id_changed(key_id)


