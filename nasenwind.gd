extends Area3D

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body is VehicleBody3D:
		print("hatschi mein schatzi")
		body.apply_impulse(Vector3(0,50,-1000))
		$hatschi.play()
