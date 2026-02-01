extends Camera3D

func _process(delta: float) -> void:
	var playerPos = unproject_position($"../../player".global_position)
	$"../../PlayerMarker".global_position = $"../../Sprite2D".global_position+playerPos*$"../../Sprite2D".scale.x
	$"../../PlayerMarker/Label".text = str(playerPos)#/#+$"../../Sprite2D".position
