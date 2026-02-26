extends Node2D

@onready var pause_menu = $CanvasLayer/Control/PauseMenu
@onready var controls_menu = $CanvasLayer/Control/ControlsMenu

var paused = false

func _ready() -> void:
	pause_menu.hide()
	controls_menu.hide()

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.hide()
		controls_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		controls_menu.hide()
		Engine.time_scale = 0
		
		# reset controls flag on pause menu script
		pause_menu.controls = false
	
	paused = !paused
