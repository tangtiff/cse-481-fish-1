extends Control

func _on_resume_pressed() -> void:
	print("resume")
	hide()
	Engine.time_scale = 1
	#get_tree().paused = false  # optional if you use tree pausing

func _on_main_menu_pressed() -> void:
	Engine.time_scale = 1
	#get_tree().paused = false  # optional
	print("MAIN MENU")
	get_tree().change_scene_to_file("res://MainMenu.tscn")  # update path
	
func _on_controls_pressed()-> void:
	Engine.time_scale = 1;
	get_tree().change_scene_to_file("res://controls_menu.tscn")
	
