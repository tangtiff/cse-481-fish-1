extends Control

@export var matching_scene: PackedScene

@onready var character_list = $Background/HBoxContainer/CharacterList
@onready var portrait = $Background/HBoxContainer/EntryPanel/Portrait
@onready var name_label = $Background/HBoxContainer/EntryPanel/Name
@onready var bio_text = $Background/HBoxContainer/EntryPanel/BioScroll/BioText

var entries = []

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	
#func _input(event):
	#if event is InputEventMouseButton and event.pressed:
		#print("Book received click")

func open_book(): 
	refresh_book() 
	visible = true 
	#get_tree().paused = true

func close_book():
	visible = false
	#get_tree().paused = false

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

func _on_exit_button_pressed() -> void:
	close_book()
	close_book()

func _on_match_button_pressed() -> void:
	if matching_scene:
		get_tree().change_scene_to_packed(matching_scene)
