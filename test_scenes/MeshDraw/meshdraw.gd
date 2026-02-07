extends Node3D

var image : Image
var texture : ImageTexture
var mat : StandardMaterial3D
var mousepos = Vector2i(0,0)
var mesh : Mesh
var meshtool : MeshDataTool
var meshtools : Array[MeshDataTool]
var faceCounts : Array[int]

func _ready():
	mesh = $Mesh.get_mesh()
	meshtool = MeshDataTool.new()
	meshtool.create_from_surface($Mesh.get_mesh(),0)
	image = Image.new()
	
	image = Image.load_from_file("res://icon.svg")
	texture = ImageTexture.create_from_image(image)
	
	$Mesh.create_trimesh_collision()
	#$Mesh.get_child(0).get_child(0).shape.backface_collision = true
	meshtools.resize(mesh.get_surface_count())
	faceCounts.resize(mesh.get_surface_count())
	var count = 0
	for surfaceID in mesh.get_surface_count():
		meshtools[surfaceID] = MeshDataTool.new()
		meshtools[surfaceID].create_from_surface(mesh,surfaceID)
		mat = StandardMaterial3D.new()
		mat.albedo_texture = texture
		$Mesh.set_surface_override_material(surfaceID,mat)
		#print(meshtools[surfaceID].get_face_count())
		faceCounts[surfaceID] = count
		count += meshtools[surfaceID].get_face_count()
		
	
func barycentric(point, triangleA, triangleB, triangleC):
	var det = Basis(triangleA, triangleB, triangleC).determinant()
	var alpha = Basis(point, triangleB, triangleC).determinant() / det;
	var beta = -Basis(triangleA, triangleC, point ).determinant() / det;
	return Vector3(alpha, beta, 1.0 - alpha - beta)



func getUV(point):
	# Gets the uv coordinates on the mesh given a point on the mesh and normal
	# these values can be obtained from a raycast
	
	var face = $RayCast3D.get_collision_face_index()
	if face == null:
		return null
	for meshTID in meshtools.size():		
		var meshT = meshtools[meshTID]
		face = face-faceCounts[meshTID]
		var v1 = meshT.get_vertex(meshT.get_face_vertex(face, 0))
		var v2 = meshT.get_vertex(meshT.get_face_vertex(face, 1))
		var v3 = meshT.get_vertex(meshT.get_face_vertex(face, 2))

		var bc = barycentric(point, v1, v2, v3)
		var uv1 = meshT.get_vertex_uv(meshT.get_face_vertex(face, 0))
		var uv2 = meshT.get_vertex_uv(meshT.get_face_vertex(face, 1))
		var uv3 = meshT.get_vertex_uv(meshT.get_face_vertex(face, 2))
		return (uv1 * bc.x) + (uv2 * bc.y) + (uv3 * bc.z)
	pass
	
func _process(delta):
	if true:
		mousepos = get_viewport().get_mouse_position()
		$RayCast3D.global_position = $Camera3D.project_ray_origin(mousepos)
		$RayCast3D.target_position = $Camera3D.project_ray_normal(mousepos)*1000.0
		$RayCast3D.force_raycast_update()
		if($RayCast3D.is_colliding()):
			var meshFaces = mesh.get_faces().size()
			print($RayCast3D.get_collision_face_index()," of ", meshFaces)
			var rayCastPosition = $RayCast3D.get_collision_point()
			$Cursor.global_position = rayCastPosition
			var pos = getUV(rayCastPosition)
			#print(pos)
			image.set_pixelv(pos*image.get_width(), Color.RED)
			texture.set_image(image)
	pass
