extends Node

var selected_face: Face = Face.SPAHN_TOON
var selected_face_scene: PackedScene
var selected_mask: String ## this is the res of the mask scene
var selected_level: PackedScene ## legacy: should be calld seletcde_mask_scene now

enum Face {
	SPAHN_TOON,
	SPAHN_REAL,
	MERZ_REAL,
	MERZ_TOON,
	SUZANNE,
}

# do we want to preload these
const FACE_SCENE_PATHS = {
	Face.SPAHN_TOON: "res://gesicht/spahn_toon.tscn",
	Face.SPAHN_REAL: "res://gesicht/spahn_ki_platt.tscn",
	Face.MERZ_TOON: "res://gesicht/merz_toon.tscn",
	Face.MERZ_REAL: "res://gesicht/merz_ki.tscn",
	Face.SUZANNE: "res://gesicht/suzanne.tscn",
}

var MASKS_PER_FACE = {
	Face.SPAHN_TOON: [
		"res://level/levels/SPAHN_TOON--Querdenker.tscn",
		"res://level/levels/SPAHN_TOON--Panzerknacker Spahn.tscn",
		"res://level/levels/level_bandit.tscn",
		"res://level/levels/level_corona.tscn",
	],
	Face.SPAHN_REAL: [
		"res://level/levels/SPAHN_REAL--Querdenker.tscn",
	],
	Face.MERZ_TOON: [
		"res://level/levels/MERZ_TOON--Querdenker.tscn"
	],
	Face.MERZ_REAL: [
		"res://level/levels/MERZ_REAL--Querdenker.tscn",
		"res://level/levels/MERZ_REAL--hitler.tscn",
	],
	Face.SUZANNE: [
		"res://level/levels/SUZANNE--Querdenker.tscn"
	],
}

func parse_mask_scene(path: String):
	var lvl_full_name: String = path.get_file().get_basename()
	var _t = lvl_full_name.split("--") # by convention (enforced by the new level editor)
	if not _t or len(_t) <= 1:
		return [null, lvl_full_name]
	var level_face = _t[0]
	var level_name = _t[1]
	return [level_face, level_name]


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


func _ready() -> void:
	load_dyanmic_levels_from_path()

func load_dyanmic_levels_from_path():
	var level_scene_paths = dir_contents("res://level/levels")
	for lvl_path in level_scene_paths:
		var lvl_full_name: String = lvl_path.get_file().get_basename()
		var _t = lvl_full_name.split("--") # by convention (enforced by the new level editor)
		if not _t or len(_t) <= 1:
			continue
		var level_face = _t[0]
		var level_name = _t[1]
		if Face.has(level_face) and MASKS_PER_FACE[Face[level_face]].find(lvl_path):
			MASKS_PER_FACE[Face[level_face]].append(lvl_path)
			print("dynamically loaded %s for %s" % [level_name, level_face])


## utils

func dir_contents(path):
	var scene_loads = []	

	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.get_extension() == "tscn":
					var full_path = path.path_join(file_name)
					scene_loads.append(full_path)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return scene_loads
>>>>>>> 78ad2b5 (level selection mit preview)
