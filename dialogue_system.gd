extends Node2D

@onready var panel: Panel = $Panel
@onready var dialogue_box: HBoxContainer = $HBoxContainer
@onready var dialogue_text: RichTextLabel = $HBoxContainer/VBoxContainer/RichTextLabel
@onready var speaker_sprite: Sprite2D = $HBoxContainer/SpeakerParent/Sprite2D

var dialogue_lines: Array[String] = [
	"Hello, traveler. Press E twice on the pier to fish. After, press SPACE to advance the text.",
	"Gary: If you're going to eat me, I should mention I'm a venomous stone fish.
	Relax, I'm not going to sting you, people always expect a scene.",
	"Honestly, you can just put me back and catch someone more exciting. We'll both be fine",
	"Player: You're surprisingly calm, your first time being caught?",
	"Gary: Not even close. Most fishermen see me, realize what I am, and suddenly remember an appointment 
	somewhere else.",
	"I get a free snack and an early release, it's a very low-stakes arrangement.",
	"Player: Living like this by choice? Do other fish avoid you too?",
	"Gary: I tell myself it's a lifestyle decision. Truth is, most fish hear 'venomous' and assume I'd be difficult to date.",
	"Toxic, dramatic, emotionally hazardous.",
	"Gets a little lonly, I guess. I'm just lookin' for my forever partner.",
	"Someone to ride the waves of life with—fin to fin.",
	"I believe in currents pulling the right fish together but maybe I’ve been waiting for long enough.", 
	"Player: Have you ever thought about dating again? Maybe I can set you up with someone nice?",
	"Gary: That would be nice. If you're offering, I suppose I can leave you my information. Let me know if you find someone for me."
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
