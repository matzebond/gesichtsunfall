extends Node3D

@export var face_label: Label
@export var mask_label: Label
@onready var dynamic_face = $DynamicFace
@export var mask_prev: Button
@export var mask_next: Button

func _ready() -> void:
	Global.load_levels()
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
	var masks_count = len(Global.MASKS_PER_FACE[Global.selected_face])
	if masks_count > 0:
		print(Global.MASKS_PER_FACE[Global.selected_face][0])
		Global.selected_mask = Global.MASKS_PER_FACE[Global.selected_face][0]
	else:
		Global.selected_mask = ""
	update_mask()
	
	$Camera3D.position.y = Global.FACE_INFO[Global.selected_face]["zoom"]
	$Camera3D.position.z = Global.FACE_INFO[Global.selected_face]["cam_pos"]


	# Hide next/prev mask buttons if face only has one mask
	var should_show_mask_buttons = masks_count > 1
	mask_prev.visible = should_show_mask_buttons
	mask_next.visible = should_show_mask_buttons


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
	
	mask_label.text = Global.parse_mask_scene(Global.selected_mask)[1]
	dynamic_face.selected_face = Global.selected_face
	dynamic_face.selected_mask = Global.selected_mask


func _on_play_pressed() -> void:
	print("Playing ", Global.selected_face, " with ", Global.selected_mask)
	get_tree().change_scene_to_file("res://main.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")


func _on_editor_pressed() -> void:
	Global.level_editor_load = true
	get_tree().change_scene_to_file("res://level/dynamic_level_editor.tscn")
