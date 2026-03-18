extends TextureButton

@export var inside_book_scene: PackedScene
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var book_instance: Node = null

func _ready():
	visible = false
	disabled = true
	GameEvents.fish_unlocked.connect(_on_first_unlock)
	GameEvents.book_closed.connect(_on_book_closed)  # <-- add this
	pressed.connect(_on_pressed)

func _on_first_unlock(_id):
	visible = true
	disabled = false
	if GameEvents.get_abversion() == "B":
		animation_player.play("bobbing")

func _on_pressed() -> void:
	disabled = true
	animation_player.stop()
	if inside_book_scene:
		var book = inside_book_scene.instantiate()
		get_tree().root.add_child(book)
		book.open_book()
		
func _on_book_closed():
	print("book closed, re-enabling button")
	disabled = false 
