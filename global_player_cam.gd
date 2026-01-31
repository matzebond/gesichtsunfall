extends Camera3D

@export var on: bool = false
@export var target: Node3D

var checkbox: CheckBox
var other_cameras: Array[Camera3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Find all other cameras in the scene
	_find_other_cameras(get_tree().root)

	# Create canvas layer for UI
	var canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)

	# Create checkbox
	checkbox = CheckBox.new()
	checkbox.text = "Global Player Camera"
	checkbox.button_pressed = on
	checkbox.position = Vector2(10, 10)
	checkbox.toggled.connect(_on_checkbox_toggled)
	canvas_layer.add_child(checkbox)

	if on:
		self.make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target:
		look_at(target.position)


func _find_other_cameras(node: Node) -> void:
	for child in node.get_children():
		if child is Camera3D and child != self:
			other_cameras.append(child)
		_find_other_cameras(child)


func _on_checkbox_toggled(pressed: bool) -> void:
	on = pressed
	if pressed:
		self.make_current()
	else:
		# Switch to the first available camera
		if other_cameras.size() > 0:
			other_cameras[0].make_current()
