extends Node

func _ready() -> void:
	print("Filling your hard drive with screenshots every " + str($Timer.wait_time)
	+ "s and saving to " + ProjectSettings.globalize_path("user://"))

func take_screenshot() -> Image:
	# Wait for the current frame to finish rendering
	await RenderingServer.frame_post_draw
	
	# Get the viewport texture
	var view_tex = get_viewport().get_texture()
	
	# Convert texture to image
	return view_tex.get_image()


func _on_timer_timeout() -> void:
	var img = await take_screenshot()
	var path = "user://screenshot_" + str(Time.get_unix_time_from_system()) + ".png"
	img.save_png(path)
