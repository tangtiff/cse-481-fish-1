extends Control

@onready var catch_bar: ProgressBar = %CatchBar

var onCatch := false
var catchSpeed := 0.3
var catchingValue := 0.0

signal fish_caught

func _physics_process(_delta):
	if onCatch: catchingValue += catchSpeed
	else: catchingValue -= catchSpeed
	
	if catchingValue < 0.0: catchingValue = 0
	elif catchingValue >= 100: _game_end()
	
	catch_bar.value = catchingValue
	

func _game_end() -> void:
	fish_caught.emit()
	get_tree().paused = false
	queue_free()

func _on_target_target_entered() -> void:
	onCatch = true


func _on_target_target_exited() -> void:
	onCatch = false
