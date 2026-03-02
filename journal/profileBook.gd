extends TextureButton

@export var inside_book_scene: PackedScene
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	visible = false
	disabled = true
	GameEvents.fish_unlocked.connect(_on_first_unlock)
	pressed.connect(_on_pressed)

func _on_first_unlock(_id):
	visible = true
	disabled = false
	animation_player.play("bobbing")

func _on_pressed() -> void:
	animation_player.stop()
	if inside_book_scene:
		var book = inside_book_scene.instantiate()
		get_tree().root.add_child(book)  # Changed from current_scene to root
		book.open_book()
