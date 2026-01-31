extends Node3D

# Decal Zeug
var last_pos = Vector3.ZERO
var distance_threshold = 0.5

@onready var decal_spawner = $DecalSpawner
@onready var decal_spawn_point = $DecalSpawnPoint
@onready var ray_cast: RayCast3D = $RayCast3D
@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
	$gesicht/Plane.create_trimesh_collision()
	$gesicht/Plane.get_child(0).get_child(0).shape.backface_collision = true

func _process(delta: float) -> void:
	var pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	decal_spawner.enable_spawning(pressed)
	
	if pressed:
		var mouse_pos = camera.get_viewport().get_mouse_position()
		
		ray_cast.position = camera.project_ray_origin(mouse_pos)
		ray_cast.target_position = camera.project_ray_normal(mouse_pos) * 1000
		
		if ray_cast.is_colliding():
			decal_spawn_point.global_position = ray_cast.get_collision_point()
