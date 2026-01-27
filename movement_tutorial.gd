extends Node2D

@onready var w_button = $W
@onready var a_button = $A
@onready var s_button = $S
@onready var d_button = $D
@onready var w_timer = $"W Timer"
@onready var a_timer = $"A Timer"
@onready var s_timer = $"S Timer"
@onready var d_timer = $"D Timer"

var w_pressed = false
var a_pressed = false
var s_pressed = false
var d_pressed = false

func _ready() -> void:
	w_button.visible = true
	a_button.visible = true
	s_button.visible = true
	d_button.visible = true

func _process(_delta):
	if Input.is_action_just_pressed("ui_up") && !w_pressed:
		w_pressed = true
		w_timer.start(1)
	if Input.is_action_just_pressed("ui_down") && !s_pressed:
		s_pressed = true
		s_timer.start(1)
	if Input.is_action_just_pressed("ui_left") && !a_pressed:
		a_pressed = true
		a_timer.start(1)
	if Input.is_action_just_pressed("ui_right") && !d_pressed:
		d_pressed = true
		d_timer.start(1)
	_update_transparency()
	
func _update_transparency():
	if w_pressed:
		w_button.modulate = Color(0, 0, 0, w_timer.time_left)
	if a_pressed:
		a_button.modulate = Color(0, 0, 0, a_timer.time_left)
	if s_pressed:
		s_button.modulate = Color(0, 0, 0, s_timer.time_left)
	if d_pressed:
		d_button.modulate = Color(0, 0, 0, d_timer.time_left)
	
func _on_w_timer_timeout():
	w_button.visible = false

func _on_a_timer_timeout():
	a_button.visible = false

func _on_s_timer_timeout():
	s_button.visible = false

func _on_d_timer_timeout():
	d_button.visible = false
