extends WorldEnvironment

var counter = 0.0

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	counter += delta / 10
	if counter > 359:
		counter = 0.0
	
	environment.background_color = Color.from_hsv(counter,0.8,0.4)
