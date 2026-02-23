extends Node

signal fish_caught
signal fish_unlocked(unlocked_id)
signal fish_matched(fish_a, fish_b)
signal match_made(left_id: String, right_id: String)

# Hard-coded fish order (match your .tres file names or IDs)
var fish_order: Array[String] = [
	"Gary",
	"Matt",
	"Leona",
	"Finn",
	"Coral",
	"Pearl",
	"Kelp"
]

var current_index: int = 0
var unlocked_fish: Array[String] = []
var fish_matches: Array = []  # stores pairs of IDs

# Version number of this release
const VERSION: String = "0-1"

func _ready():
	fish_caught.connect(_on_fish_caught)
	reset_satisfaction()

func _on_fish_caught():
	if current_index >= fish_order.size():
		return  # All fish unlocked

	var new_fish_id = fish_order[current_index]
	unlocked_fish.append(new_fish_id)
	current_index += 1

	fish_unlocked.emit(new_fish_id)

func get_unlocked_fish() -> Array[String]:
	return unlocked_fish

func get_matches() -> Array:
	return fish_matches

func get_version() -> String:
	return VERSION

func add_match(a: String, b: String) -> bool:
	if a == b:
		return false

	if is_pair_existing(a, b):
		return false

	fish_matches.append([a, b])
	fish_matched.emit(a, b)
	return true
	
func is_pair_existing(a: String, b: String) -> bool:
	for pair in fish_matches:
		if (pair[0] == a and pair[1] == b) or (pair[0] == b and pair[1] == a):
			return true
	return false

func set_satisfaction(id, amt) -> void:
	var path = "res://resource/characters/%s.tres" % id
	if ResourceLoader.exists(path):
		var entry = load(path)
		entry.satisfaction = amt
		ResourceSaver.save(entry, path)

func reset_satisfaction() -> void:
	for fish in fish_order:
		set_satisfaction(fish, 0)
