extends Node3D
var decalpositions = []
var decalcolors = []

func _ready() -> void:
	print($Level.get_child_count())
	for child in $Level.get_children():
		if child:
			decalpositions.push_back(child.global_position)
			decalcolors.push_back(child.modulate)
	print("Decal count: " + str(decalpositions.size()))

func evaluate():
	
	pass

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		evaluate()
	pass
