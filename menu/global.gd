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

const BRUSH_COLORS = [
	Color(0.9437293, 0.7933064, 0.18490851, 1),
	Color(0.91240376, 0.2230595, 0.45916617, 1),
	Color(0.25798154, 0.6871544, 0.4016019, 1),
	Color(0.7435644, 0.16701159, 0.81802505, 1),
	Color(0.92156863, 0.03137255, 0, 1),
	Color(0.851769, 0.8517689, 0.85176885, 1),
	Color(0, 0, 0.6745098, 1),
	Color(0.47843137, 0.23137255, 0.7882353, 1),
	Color(0, 0, 0, 1)
]
