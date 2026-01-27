extends Node2D

func _ready():
	visible = false
	GameEvents.fish_caught.connect(_on_fish_caught)

func _on_fish_caught():
	visible = true
