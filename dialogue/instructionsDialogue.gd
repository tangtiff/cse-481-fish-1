extends Node2D

@onready var panel: Panel = $Panel
@onready var dialogue_box: HBoxContainer = $HBoxContainer
@onready var dialogue_text: RichTextLabel = $HBoxContainer/VBoxContainer/RichTextLabel
@onready var speaker_sprite: Sprite2D = $HBoxContainer/SpeakerParent/Sprite2D

var dialogue_lines: Array[String] = [
	"Hello, traveler use WASD to move. Press E twice on the pier to fish. After, press SPACE to advance the text.",
	
]

var current_line: int = 0
var dialogue_active: bool = false

func _ready():
	#panel.visible = false
	#dialogue_box.visible = false
	#dialogue_text.bbcode_enabled = true
	start_dialogue()

func start_dialogue():
	dialogue_active = true
	current_line = 0
	panel.visible = true
	dialogue_box.visible = true
	_show_current_line()

func _show_current_line():
	dialogue_text.clear()
	dialogue_text.append_text(dialogue_lines[current_line])

func _input(event):
	if not dialogue_active:
		return
	
	if event.is_action_pressed("ui_accept"):
		_next_line()

func _next_line():
	current_line += 1
	
	if current_line >= dialogue_lines.size():
		end_dialogue()
	else:
		_show_current_line()

func end_dialogue():
	dialogue_active = false
	panel.visible = false
	dialogue_box.visible = false
