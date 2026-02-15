extends Control

@export_file("*.tscn") var game_scene_path: String

@onready var left_list: ItemList = $Panel2/LeftItemList
@onready var right_list: ItemList = $Panel3/RightItemList
@onready var match_button: Button = $MatchButton
@onready var exit_button: Button = $ExitButton

var entries: Array = []  # loaded .tres resources
var entry_ids: Array[String] = []  # matching ID order

func _ready():
	visible = true
	
	GameEvents.fish_unlocked.connect(_on_fish_unlocked)
	
	load_unlocked_fish()
	populate_lists()

func load_unlocked_fish():
	entries.clear()
	entry_ids.clear()

	var unlocked_ids = GameEvents.get_unlocked_fish()

	for id in unlocked_ids:
		var path = "res://resource/characters/%s.tres" % id
		if ResourceLoader.exists(path):
			var entry = load(path)
			entries.append(entry)
			entry_ids.append(id)

func populate_lists():
	left_list.clear()
	right_list.clear()

	for entry in entries:
		left_list.add_item(entry.display_name)
		right_list.add_item(entry.display_name)

func _on_fish_unlocked(_id):
	load_unlocked_fish()
	populate_lists()

func _on_exit_pressed() -> void:	
	print("Exit pressed")
	if game_scene_path == "":
		print("Scene path empty")
		return
	get_tree().change_scene_to_file(game_scene_path)



	

func _on_date_pressed() -> void:
	var left_selected = left_list.get_selected_items()
	var right_selected = right_list.get_selected_items()

	if left_selected.is_empty() or right_selected.is_empty():
		print("Select a fish on both sides.")
		return

	var left_index = left_selected[0]
	var right_index = right_selected[0]

	var left_id = entry_ids[left_index]
	var right_id = entry_ids[right_index]

	var success = GameEvents.add_match(left_id, right_id)

	if not success:
		print("Invalid match (duplicate or same fish).")
		return

	print("Matched: ", left_id, " + ", right_id)
