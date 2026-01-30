extends Camera3D

@export var on: bool = false
@export var target: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if on:
		self.make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(target.position)
