extends TextureButton

@export var inside_book_scene: PackedScene

func _ready():
	print("=== BOOK ICON READY ===")
	print("Scene tree path: ", get_path())
	print("Visible: ", visible)
	print("Disabled: ", disabled)
	print("Mouse filter: ", mouse_filter)
	visible = false
	disabled = true
	GameEvents.fish_unlocked.connect(_on_first_unlock)
	pressed.connect(_on_pressed)

func _on_first_unlock(_id):
	visible = true
	disabled = false

func _on_pressed() -> void:
	print("Book icon pressed!")
	if inside_book_scene:
		var book = inside_book_scene.instantiate()
		get_tree().root.add_child(book)  # Changed from current_scene to root
		book.open_book()
