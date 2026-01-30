extends Camera3D

@onready var player: Node3D  = $player
@export var on: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if on:
		self.make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(player.position)
