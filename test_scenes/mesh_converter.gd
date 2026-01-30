@tool
extends Node3D

@export_tool_button("Create Markers") var createMarkersButton = createMarkers
@export var scanVector = Vector3.UP
@onready var markerScene : PackedScene = preload("res://test_scenes/colormarker.tscn")
@export var faceCount : int = 1000
var meshTool : MeshDataTool

func ready():
	pass
func createMarkers():
	meshTool = MeshDataTool.new()
	meshTool.create_from_surface($MeshNode.mesh,0)
	for child in $MarkerNode.get_children():
		child.queue_free()		
	var img = Image.load_from_file("res://gesicht/gesicht_test.png")
	var imgSize = img.get_size()
	var count = meshTool.get_face_count()/faceCount
	for i in meshTool.get_face_count():
		if (i % count) == 0:
			#Check if face points to vector
			if(meshTool.get_face_normal(i).dot(scanVector)>0.0):
				var color = Color.BLACK
				var markerPosition = Vector3(0.0,0.0,0.0)
				for v in [0,1,2]:
					var vUV = meshTool.get_vertex_uv(meshTool.get_face_vertex(i,v))
					color += img.get_pixelv(vUV*Vector2(imgSize))/3.0
					markerPosition += meshTool.get_vertex(meshTool.get_face_vertex(i,v))/3.0
				var marker = markerScene.instantiate()
				marker.color = color
				marker.position = markerPosition
				$MarkerNode.add_child(marker)
				marker.name = str(i)
				marker.owner = self
				marker.evaluate()
	pass
