extends Node3D

var mode : bool
var rotateSpeed = 2.0

func _process(delta: float) -> void:
	$Pivot.rotate_y(-delta*rotateSpeed)
	pass


func _on_timer_timeout() -> void:
	$Area3D/CollisionShape3D.disabled=false
	$Pivot.show()
	pass # Replace with function body.


func _on_area_3d_area_entered(area: Area3D) -> void:
	$Timer.start()
	$Pivot.hide()
	#give pickup
	$Area3D/CollisionShape3D.disabled=true
	pass # Replace with function body.
