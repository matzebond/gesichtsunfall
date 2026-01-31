@tool
extends Node3D
#Can cover mesh with markers colored like texture to create levels
@export_tool_button("Create Markers") var createMarkersButton = createMarkers
@export_tool_button("Export") var exportMarkersButton = exportMarkers
@export_tool_button("Import") var importMarkersButton = importMarkers
@export_tool_button("Clear") var clearMarkersButton = clearMarkers

@export var scanVector = Vector3.UP
@onready var markerScene : PackedScene = preload("res://test_scenes/colormarker.tscn")
@export var faceCount : int = 1000
var meshTool : MeshDataTool

var markerPositions = []
var markerColors = []

func ready():
	pass
func createMarkers():
	markerPositions.clear()
	markerColors.clear()
	
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
				createMarker(markerPosition,color,str(i))
				
	pass
	
func exportMarkers():
	var save_file = FileAccess.open("res://test_scenes/level_export.txt",FileAccess.WRITE)
	print(str(markerPositions))
	print(markerPositions)
	save_file.store_line(JSON.stringify(markerPositions))
	save_file.store_line(JSON.stringify(markerColors))
	save_file.close()
	pass
	
func importMarkers():
	clearMarkers()
	var save_file = FileAccess.open("res://test_scenes/level_export.txt",FileAccess.READ)
	markerPositions = JSON.parse_string(save_file.get_line())
	markerColors = JSON.parse_string(save_file.get_line())
	save_file.close()
	for i in markerPositions.size():
		
		createMarker(str_to_var(markerPositions[i]),str_to_var(markerColors[i]),str(i))
	pass

func clearMarkers():
	for child in $MarkerNode.get_children():
		child.queue_free()
	pass
	
func createMarker(markerPosition:Vector3, color:Color,name:String):
	var marker = markerScene.instantiate()
	marker.color = color
	marker.position = markerPosition
	markerPositions.push_back(markerPosition)
	markerColors.push_back(color)
	$MarkerNode.add_child(marker)
	marker.name = str(name)
	marker.owner = self
	marker.evaluate()
	pass
