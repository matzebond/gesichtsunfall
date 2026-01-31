@tool
extends Node

enum FaceScenes {
	MERZ_TOON,
	MERZ_REAL,
	SPAHN_REAL,
	SPAHN_TOON,
	SUZANNE,
}

const FACE_SCENE_PATHS = {
	FaceScenes.SPAHN_REAL: "res://gesicht/spahn_ki_platt.tscn",
	FaceScenes.SPAHN_TOON: "res://gesicht/spahn_toon.tscn",
	FaceScenes.MERZ_TOON: "res://gesicht/merz_toon.tscn",
	FaceScenes.MERZ_REAL: "res://gesicht/merz_ki.tscn",
	FaceScenes.SUZANNE: "res://gesicht/suzanne.tscn",
}

@export var selected_face: FaceScenes = FaceScenes.SPAHN_REAL:
	set(value):
		selected_face = value
		_load_face_from_enum()
		if Engine.is_editor_hint():
			_update_face()

var face_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_load_face_from_enum()
	if not Engine.is_editor_hint():
		_update_face()


func _load_face_from_enum() -> void:
	if FACE_SCENE_PATHS.has(selected_face):
		face_scene = load(FACE_SCENE_PATHS[selected_face])


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
