@tool
extends Node

var face_scene: PackedScene
@export var selected_face: Global.FaceScenes = Global.FaceScenes.SPAHN_REAL:
	set(value):
		selected_face = value
		face_scene = load_face_from_enum(selected_face)
		print(face_scene)
		if Engine.is_editor_hint():
			_update_face()
			
func load_face_from_enum(selected_face):
	print(selected_face)
	if Global.FACE_SCENE_PATHS.has(selected_face):
		return load(Global.FACE_SCENE_PATHS[selected_face])
	else:
		assert(false, "Face '%s' not found" % selected_face)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	face_scene = load_face_from_enum(selected_face)
	if not Engine.is_editor_hint():
		_update_face()


func _update_face() -> void:
	# Remove all existing children
	for child in get_children():
		child.queue_free()

	# Add new face instance if scene is set
	if face_scene != null:
		var new_face = face_scene.instantiate()
		add_child(new_face)
		if Engine.is_editor_hint():
			new_face.set_owner(get_tree().edited_scene_root)
