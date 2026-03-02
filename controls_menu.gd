extends Control

func _on_exit_pressed() -> void:
	hide()
	var pause_menu = $"../PauseMenu"
	pause_menu.show()
	
	# reset the bool on the PauseMenu script so it knows controls is closed
	pause_menu.controls = false
	
	Engine.time_scale = 0
