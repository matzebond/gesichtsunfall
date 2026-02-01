extends Node3D
signal score_percent_changed(float)
@export var fakeDecalToggle : bool = false
@export var levelDecalsNode : Node3D
@export var playerDecalsNode : Node3D
var levelDecalPositions : Array[Vector3] = []
var levelDecalColors = []
var levelDecalValid : Array[bool] = []
var levelFakeDecals = []
var decalPositions : Array[Vector3] = []
var decalColors = []

var validDecals :int = 0
var checkProgress : int = 0
@export var checksPerFrame : int = 100
@export var checkRadius : float = 10.0

@onready var fakeDecalScene = preload("res://test_scenes/fakedecal.tscn")

func _on_game_state_manager_playing_started(game_timer: Timer) -> void:
	if(!levelDecalsNode):
		print("ERROR: Scoring node is missing node for level decals")
		return
	for child in levelDecalsNode.get_children():
		levelDecalPositions.push_back(child.global_position)
		levelDecalColors.push_back(child.modulate)
		levelDecalValid.push_back(false)
		if(fakeDecalToggle):
			var fakeDecal = fakeDecalScene.instantiate()
			levelFakeDecals.push_back(fakeDecal)
			$FakeDecals.add_child(fakeDecal)
			fakeDecal.owner = get_tree().get_root()
			fakeDecal.global_position = child.global_position
			fakeDecal.visible = true
	$CheckProgress.max_value = levelDecalPositions.size()

func evaluate():
	if(!playerDecalsNode):
		print("ERROR: Scoring node is missing node for player decals")
		return
	if(checkProgress==0):
		decalPositions.clear()
		decalColors.clear()
		levelDecalValid.clear()
		levelDecalValid.resize(levelDecalPositions.size())
		validDecals = 0
		for child in playerDecalsNode.get_children():
			decalPositions.push_back(child.global_position)
			decalColors.push_back(child.modulate)
	for decalIndex in range(checkProgress,checkProgress+checksPerFrame):
		if(decalIndex >= levelDecalPositions.size()):
			break
		for compareDecalIndex in decalPositions.size():
			if levelDecalValid[decalIndex] == false:
				if (levelDecalPositions[decalIndex].distance_squared_to(decalPositions[compareDecalIndex]) <= checkRadius) and (levelDecalColors[decalIndex]==decalColors[compareDecalIndex]):
					levelDecalValid[decalIndex] = true
					if(fakeDecalToggle):
						levelFakeDecals[decalIndex].visible = false
					validDecals += 1
				else:
					levelDecalValid[decalIndex] = false
	checkProgress+=checksPerFrame		
	if(checkProgress>=levelDecalPositions.size()):
		#print("Decals valid: " + str(validDecals) + "/" + str(levelDecalPositions.size()))
		var levelDecalPositionsCount = levelDecalPositions.size()
		var scorePercent = 100 * validDecals / levelDecalPositionsCount if levelDecalPositionsCount > 0 else 0
		score_percent_changed.emit(scorePercent)
		checkProgress=0
	pass		

func _process(delta):
	evaluate()
	$CheckProgress.value = checkProgress
	pass
