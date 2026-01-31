extends Node3D
var levelDecalPositions : Array[Vector3] = []
var levelDecalColors = []
var levelDecalValid : Array[bool] = []
var decalPositions : Array[Vector3] = []
var decalColors = []

var validDecals :int = 0
var checkProgress : int = 0
var checksPerFrame : int = 20

func _ready() -> void:
	print($Level.get_child_count())
	for child in $Level.get_children():
		if child is Decal:
			levelDecalPositions.push_back(child.global_position)
			levelDecalColors.push_back(child.modulate)
			levelDecalValid.push_back(false)
	print("Decal count: " + str(levelDecalPositions.size()))
	$LevelProgress.max_value = levelDecalPositions.size()
	$LevelProgress/CheckProgress.max_value = levelDecalPositions.size()

func evaluate():
	if(checkProgress==0):
		decalPositions.clear()
		decalColors.clear()
		validDecals = 0
		for child in $root.get_children():
			if child is Decal:
				decalPositions.push_back(child.global_position)
				decalColors.push_back(child.modulate)
	for decalIndex in range(checkProgress,checksPerFrame):
		if(decalIndex > levelDecalPositions.size()):
			break
		for compareDecal in decalPositions.size():
			if levelDecalPositions[decalIndex].distance_squared_to(decalPositions[compareDecal]) < 100.0:
				levelDecalValid[decalIndex] = true
				validDecals += 1
				$LevelProgress.value=validDecals
				continue
			else:
				levelDecalValid[decalIndex] = false
	checkProgress+=checksPerFrame		
	if(checkProgress>=levelDecalPositions.size()):
		print("Decals valid: " + str(validDecals) + "/" + str(levelDecalPositions.size()))
		checkProgress=0
	pass		

func _process(delta):
	evaluate()
	$LevelProgress/CheckProgress.value = checkProgress
	
	pass
