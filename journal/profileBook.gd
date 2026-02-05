extends TextureButton

@export var inside_book_scene: PackedScene

func _ready():
	visible = false
	disabled = true
	GameEvents.fish_unlocked.connect(_on_first_unlock)

func _on_first_unlock(_id):
	visible = true
	disabled = false

func _pressed():
	if inside_book_scene:
		var book = inside_book_scene.instantiate()
		get_tree().current_scene.add_child(book)
		book.open_book()
