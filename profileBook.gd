extends Node2D

@export var popup_sprite: Sprite2D
@export var display_time: float = 2.0
@export var fishing_game_node_path: NodePath

func _enter_tree() -> void:
	if is_instance_valid(popup_sprite):
		popup_sprite.visible = false

func _ready() -> void:
	if not is_instance_valid(popup_sprite):
		push_error("FishPopup: No popup_sprite assigned!")
		return

	# Connect to the fish_caught signal
	var fishing_game = get_node_or_null(fishing_game_node_path)
	if fishing_game:
		if fishing_game.has_signal("fish_caught"):
			fishing_game.fish_caught.connect(_on_fish_caught)
		else:
			push_error("FishPopup: The target node has no 'fish_caught' signal.")
	else:
		push_error("FishPopup: Fishing game node not found at path: %s" % fishing_game_node_path)

func _on_fish_caught() -> void:
	_show_popup()

func _show_popup() -> void:
	if not is_instance_valid(popup_sprite):
		return

	popup_sprite.visible = true
	popup_sprite.scale = Vector2(0, 0)

	var tween = create_tween()
	tween.tween_property(popup_sprite, "scale", Vector2(1, 1), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	await get_tree().create_timer(display_time).timeout
	popup_sprite.visible = false
