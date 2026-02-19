extends Control

@export var matching_scene: PackedScene
@onready var character_list = $Background/HBoxContainer/CharacterList
@onready var portrait = $Background/HBoxContainer/EntryPanel/HBoxContainer/Portrait
@onready var name_label = $Background/HBoxContainer/EntryPanel/Name
@onready var bio_text = $Background/HBoxContainer/EntryPanel/BioScroll/BioText
@onready var satisfaction_bar = $Background/HBoxContainer/EntryPanel/HBoxContainer/SatisfactionBar

var entries = []
var matching_screen_instance = null  # Track the matching screen

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	GameEvents.match_made.connect(_on_match_made)

func _on_match_made(_left_id, _right_id):
	visible = false

func open_book(): 
	refresh_book() 
	visible = true

func close_book():
	# Close matching screen if it's open
	if matching_screen_instance:
		matching_screen_instance.queue_free()
		matching_screen_instance = null
	visible = false

func refresh_book():
	entries.clear()
	character_list.clear()
	var unlocked_ids = GameEvents.get_unlocked_fish()
	for id in unlocked_ids:
		var path = "res://resource/characters/%s.tres" % id
		if ResourceLoader.exists(path):
			var entry = load(path)
			entries.append(entry)
			character_list.add_item(entry.display_name)

func _on_fish_unlocked(_id):
	refresh_book()

func _on_character_list_item_selected(index):
	var entry = entries[index]
	display_entry(entry)

func display_entry(entry):
	portrait.texture = entry.portrait
	name_label.text = entry.display_name
	bio_text.text = entry.full_bio
	satisfaction_bar.visible = true
	satisfaction_bar._change_satisfaction_value(entry.satisfaction)

func _on_exit_button_pressed() -> void:
	close_book()

func _on_match_button_pressed() -> void:
	if matching_scene:
		# Hide the book content
		$Background.visible = false  # Hides all the book UI
		
		# Instantiate matching screen
		matching_screen_instance = matching_scene.instantiate()
		add_child(matching_screen_instance)
		
		# Connect the exit signal
		matching_screen_instance.exit_requested.connect(_on_matching_exit)

func _on_matching_exit():
	# Close the matching screen and return to book
	if matching_screen_instance:
		matching_screen_instance.queue_free()
		matching_screen_instance = null
	
	# Show the book content again
	$Background.visible = true
