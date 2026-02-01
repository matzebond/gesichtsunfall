extends Node3D

@export var face_label:Label
@export var mask_label:Label
@onready var dynamic_face = $DynamicFace

func _ready() -> void:
	face_label.text = Global.Face.find_key(Global.selected_face)
	update_face()


func _on_face_next_pressed() -> void:
	var faces = len(Global.Face)
	if Global.selected_face >= faces -1:
		Global.selected_face = 0 as Global.Face
	else:
		Global.selected_face = (Global.selected_face + 1) as Global.Face
	update_face()

func _on_face_prev_pressed() -> void:
	if Global.selected_face <= 0:
		Global.selected_face = (len(Global.Face) - 1) as Global.Face
	else:
		Global.selected_face = (Global.selected_face - 1) as Global.Face
	update_face()

func update_face():
	# Update face global & text
	face_label.text = Global.FACE_NAME[Global.selected_face]
	dynamic_face.selected_face = Global.selected_face
	
	# select first mask & update text
	if len(Global.MASKS_PER_FACE[Global.selected_face]) > 0:
		print(Global.MASKS_PER_FACE[Global.selected_face][0])
		Global.selected_mask = Global.MASKS_PER_FACE[Global.selected_face][0]
	else:
		Global.selected_mask = ""
	update_mask()


func _on_mask_prev_pressed() -> void:
	var masks = Global.MASKS_PER_FACE[Global.selected_face]
	var cur_mask_index = masks.find(Global.selected_mask)
	if cur_mask_index <= 0:
		Global.selected_mask = masks[-1]
	else:
		Global.selected_mask = masks[cur_mask_index - 1]
	update_mask()

func _on_mask_next_pressed() -> void:
	var masks = Global.MASKS_PER_FACE[Global.selected_face]
	var cur_mask_index = masks.find(Global.selected_mask)
	if cur_mask_index >= len(masks) - 1:
		Global.selected_mask = masks[0]
	else:
		Global.selected_mask = masks[cur_mask_index + 1]
	update_mask()
	
func update_mask():
	if Global.selected_mask == "":
		print("no mask to select") ## TODO disable play button (or free play)
		return
		
	print(Global.selected_mask)
	print(Global.parse_mask_scene(Global.selected_mask))
	
	mask_label.text = Global.parse_mask_scene(Global.selected_mask)[1]
	dynamic_face.selected_face = Global.selected_face
	dynamic_face.selected_mask = Global.selected_mask


func _on_play_pressed() -> void:
	print(Global.selected_mask)
	get_tree().change_scene_to_file("res://main.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")
