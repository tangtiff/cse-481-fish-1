extends Control

@onready var pause_menu = self
@onready var controls_menu = $"../ControlsMenu"

var controls = false

func _on_exit_pressed() -> void:
	pause_menu.hide()
	controls_menu.hide()
	controls = false
	Engine.time_scale = 1

func _ready() -> void:
	pause_menu.hide()
	controls_menu.hide()

func _on_resume_pressed() -> void:
	print("resume")
	pause_menu.hide()
	controls_menu.hide()
	controls = false
	Engine.time_scale = 1

func _on_main_menu_pressed() -> void:
	Engine.time_scale = 1
	print("MAIN MENU")
	get_tree().change_scene_to_file("res://MainMenu.tscn")

func _on_controls_pressed() -> void:
	controlsMenu()

func controlsMenu():
	if controls:
		# go back to pause menu
		controls_menu.hide()
		pause_menu.show()
		Engine.time_scale = 0   # stay paused
	else:
		# show controls menu
		controls_menu.show()
		pause_menu.hide()
		Engine.time_scale = 0   # stay paused

	controls = !controls
