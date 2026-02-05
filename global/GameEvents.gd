extends Node

signal fish_caught
signal fish_unlocked(unlocked_id)

# Hard-coded fish order (match your .tres file names or IDs)
var fish_order: Array[String] = [
	"Gary",
	"Matt",
	"ThirdFishID"
]

var current_index: int = 0
var unlocked_fish: Array[String] = []

func _ready():
	fish_caught.connect(_on_fish_caught)

func _on_fish_caught():
	if current_index >= fish_order.size():
		return  # All fish unlocked

	var new_fish_id = fish_order[current_index]
	unlocked_fish.append(new_fish_id)
	current_index += 1

	fish_unlocked.emit(new_fish_id)

func get_unlocked_fish() -> Array[String]:
	return unlocked_fish
