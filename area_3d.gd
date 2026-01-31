extends Area3D

func _ready() -> void:
	$TextureRect.visible = false
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body is VehicleBody3D:
		$TextureRect.visible = true
		AudioManager.suppress_bgm(true)
		AudioManager.play_one_shot("Nomnom")
