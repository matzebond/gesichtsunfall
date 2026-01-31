extends Node

var selected_level: PackedScene

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
