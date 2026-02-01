@tool
extends Node

var face_scene: PackedScene
var face_instance
@export var selected_face: Global.Face = Global.selected_face:
	set(value):
		selected_face = value
		face_scene = load_face_from_enum(selected_face)
		_update_face()
## if load Global.seleted_face 
@export var load_face_from_global: bool = false

var mask_scene: PackedScene
var mask_instance
@export_file("*.tscn") var selected_mask: String:
	set(value):
		selected_mask = value
		mask_scene = load_mask(selected_mask)
		_update_face()
@export var load_mask_from_global: bool = false


func load_face_from_enum(face):
	if Global.FACE_SCENE_PATHS.has(face):
		return load(Global.FACE_SCENE_PATHS[face])
	else:
		assert(false, "Face '%s' not found" % face)
		
func load_mask(mask):
	print("loading Mask level '%s'" % mask)
	return load(mask)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if load_face_from_global:
		selected_face = Global.selected_face
	else:
		selected_face = selected_face # hack to run the setter
		
	if load_mask_from_global:
		selected_mask = Global.selected_mask
	else:
		selected_mask = selected_mask # more hacks


func _update_face() -> void:
	# Remove all existing children
	for child in get_children():
		child.queue_free()

	# Add new face instance if scene is set
	if face_scene != null:
		var new_face = face_scene.instantiate()
		new_face.name = "Face"
		add_child(new_face)
		if Engine.is_editor_hint():
			new_face.set_owner(get_tree().edited_scene_root)
		face_instance = new_face
	else:
		face_instance = null
			
	if mask_scene != null:
		var new_mask = mask_scene.instantiate()
		new_mask.name = "Level" + str(randf())
		add_child(new_mask)
		if Engine.is_editor_hint():
			new_mask.set_owner(get_tree().edited_scene_root)
		mask_instance = new_mask
	else:
		mask_instance = null
