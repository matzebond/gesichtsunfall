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

var mistakeDecalPositions : Array[Vector3] = []
var mistakeDecalColors = []
var mistakeDecalValid : Array[bool] = []

var validDecals : int = 0
var lastValidDecals := 0
var mistakeDecals : int = 0
var lastMistakeDecals := 0

var checkProgress : int = 0
var mistakeCheckProgress : int = 0

var lastTotalScore := 0
var lastPlayerDecalsCount := 0

@export var checksPerFrame : int = 100
@export var checkRadius : float = 10.0
@export var mistakeCheckRadius : float = 40.0

@onready var fakeDecalScene = preload("res://test_scenes/fakedecal.tscn")

func _on_game_state_manager_playing_started(game_timer: Timer) -> void:
	if(!levelDecalsNode):
		print("ERROR: Scoring node is missing node for level decals. playing started")
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

func evaluate(final = false, checks = checksPerFrame):
	if(!playerDecalsNode):
		print("ERROR: Scoring node is missing node for player decals. evaluate")
		return
	if final:
		checkProgress = 0
		checks = levelDecalPositions.size()
	if(checkProgress==0):
		decalPositions.clear()
		decalColors.clear()
		levelDecalValid.clear()
		levelDecalValid.resize(levelDecalPositions.size())
		validDecals = 0
		for child in playerDecalsNode.get_children():
			decalPositions.push_back(child.global_position)
			decalColors.push_back(child.modulate)
	for decalIndex in range(checkProgress,checkProgress+checks):
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
	checkProgress+=checks
	if(checkProgress>=levelDecalPositions.size()):
		#print("Decals valid: " + str(validDecals) + "/" + str(levelDecalPositions.size()))
		lastValidDecals = validDecals
		checkProgress=0
	pass
	
func evaluateMistakes(final = false, checks = checksPerFrame):
	if(!playerDecalsNode):
		print("ERROR: Scoring node is missing node for player decals. evaluate")
		return
	if(mistakeCheckProgress==0):
		mistakeDecalPositions.clear()
		mistakeDecalColors.clear()
		mistakeDecalValid.clear()
		for child in playerDecalsNode.get_children():
			mistakeDecalPositions.push_back(child.global_position)
			mistakeDecalColors.push_back(child.modulate)
			mistakeDecalValid.push_back(true)
		mistakeDecals = mistakeDecalValid.size()
	if final:
		checkProgress = 0
		checks = mistakeDecals
	for mistakeDecalIndex in range(mistakeCheckProgress,mistakeCheckProgress+checksPerFrame):
		if(mistakeDecalIndex >= mistakeDecalPositions.size()):
			break
		for compareDecalIndex in levelDecalPositions.size():
			if mistakeDecalValid[mistakeDecalIndex] == true:
				if (mistakeDecalPositions[mistakeDecalIndex].distance_squared_to(levelDecalPositions[compareDecalIndex]) <= mistakeCheckRadius) and (mistakeDecalColors[mistakeDecalIndex]==levelDecalColors[compareDecalIndex]):
					mistakeDecalValid[mistakeDecalIndex] = false
					mistakeDecals-=1
	mistakeCheckProgress+=checks
	if(mistakeCheckProgress>=mistakeDecalPositions.size()):
		#print("Decal mistakes: " + str(mistakeDecals) + "/" + str(mistakeDecalPositions.size()))
		$MistakesPanel/MistakesLabel.text = "Mistakes: " + str(mistakeDecals) + " / " + str(mistakeDecalPositions.size())
		lastMistakeDecals = mistakeDecals
		lastPlayerDecalsCount = playerDecalsNode.get_child_count()
		mistakeCheckProgress=0
	pass
pass

func _process(delta):
	evaluate()
	evaluateMistakes(false, 10)
	
	var scorePlus = lastValidDecals / float(levelDecalPositions.size()) if levelDecalPositions.size() > 0 else 0
	var scoreMinus = lastMistakeDecals / float(lastPlayerDecalsCount) if lastPlayerDecalsCount > 0 else 0
	var totalScore = max(0, scorePlus - 0.2 * scoreMinus)
	
	if totalScore != lastTotalScore:
		score_percent_changed.emit(totalScore * 100)
	
	$CheckProgress.value = checkProgress
	pass
