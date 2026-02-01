@tool
extends PanelContainer

var _key_id: int = -1
@export var key_id: int:
	get:
		return _key_id
	set(value):
		_key_id = value
		$Label.text = str(value + 1)
		$Label/ColorRect.color = Global.BRUSH_COLORS[value]

func on_color_key_id_changed(new_key_id: int):
	var active = new_key_id == key_id
	scale = Vector2.ONE * (1.2 if active else 1)
