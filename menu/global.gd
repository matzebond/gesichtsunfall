extends Node

var selected_face: Face = Face.SPAHN_TOON
var selected_mask: String = "res://level/levels/SPAHN_TOON--Panzerknacker Spahn.tscn"
signal pause_signal
signal unpause_signal

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

const FACE_NAME = {
	Face.SPAHN_TOON: "Jens Spahn",
	Face.SPAHN_REAL: "@realJensSpahn",
	Face.MERZ_TOON: "Friedrich Merz",
	Face.MERZ_REAL: "@realFriedrichMerz",
	Face.SUZANNE: "Suzanne",
}

const FACE_INFO = {
	Face.SPAHN_TOON: {
		"name": "Jens Spahn",
		"zoom": 160,
		"cam_pos": 50,
	},
	Face.SPAHN_REAL: {
		"name": "@realJensSpahn",
		"zoom": 500,
		"cam_pos": 220,
	},
	Face.MERZ_TOON: {
		"name": "Friedrich Merz",
		"zoom": 900,
		"cam_pos": 320,
	},
	Face.MERZ_REAL: {
		"name": "@realFriedrichMerz",
		"zoom": 600,
		"cam_pos": 250,
	},
	Face.SUZANNE: {
		"name": "Suzanne",
		"zoom": 360,
		"cam_pos": 80,
	},
}

var MASKS_PER_FACE = {
	Face.SPAHN_TOON: [
		"res://level/levels/SPAHN_TOON--Querdenker.tscn",
		"res://level/levels/SPAHN_TOON--Panzerknacker Spahn.tscn",
		"res://level/levels/SPAHN_TOON--Spahnferkel.tscn",
		"res://level/levels/SPAHN_TOON--Fawkes.tscn",
		"res://level/levels/SPAHN_TOON--Kiss.tscn",
	],
	Face.SPAHN_REAL: [
		"res://level/levels/SPAHN_REAL--Querdenker.tscn",
	],
	Face.MERZ_TOON: [
		"res://level/levels/MERZ_TOON--Querdenker.tscn"
	],
	Face.MERZ_REAL: [
		"res://level/levels/MERZ_REAL--Querdenker.tscn",
	],
	Face.SUZANNE: [
		"res://level/levels/SUZANNE--Querdenker.tscn",
		"res://level/levels/SUZANNE--Clown.tscn"
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


var level_editor_load: bool = false
var save_path_res = "res://level/levels/"
var save_path_user = "user://"
var level_name_format = "%s--%s.tscn"
var save_path = save_path_res + level_name_format

func _ready() -> void:
	if not OS.is_debug_build() or true:
		save_path = save_path_user + level_name_format
	load_levels()
	
func load_levels():
	print("loading from resources")
	load_dyanmic_levels_from_path(save_path_res)
	print("loading from user")
	load_dyanmic_levels_from_path(save_path_user)
	print()

func load_dyanmic_levels_from_path(path: String):
	var level_scene_paths = dir_contents(path)
	for lvl_path in level_scene_paths:
		var lvl_full_name: String = lvl_path.get_file().get_basename()
		var _t = lvl_full_name.split("--") # by convention (enforced by the new level editor)
		if not _t or len(_t) <= 1:
			continue
		var level_face = _t[0]
		var level_name = _t[1]
		if Face.has(level_face) and MASKS_PER_FACE[Face[level_face]].find(lvl_path) == -1:
			MASKS_PER_FACE[Face[level_face]].append(lvl_path)
			print("dynamically loaded %s for %s" % [level_name, level_face])
			print(MASKS_PER_FACE[Face[level_face]])


## utils

func dir_contents(path):
	var scene_loads = []	

	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if file_name.get_extension() == "tscn":
					var full_path = path.path_join(file_name)
					scene_loads.append(full_path)
			else:
				#print("Found directory: " + file_name)
				pass
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return scene_loads
