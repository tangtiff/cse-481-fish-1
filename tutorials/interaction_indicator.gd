extends Node2D
@onready var e: Sprite2D = $E
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var e_timer = $"E Timer"

var e_pressed = false

func _ready() -> void:
	e.visible = true
	animation_player.play("bobbing")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_fish") && !e_pressed:
		e_pressed = true
		e_timer.start(1)
	_update_transparency()

func _update_transparency():
	if e_pressed:
		e.modulate = Color(0, 0, 0, e_timer.time_left)

func _on_e_timer_timeout():
	e.visible = false
