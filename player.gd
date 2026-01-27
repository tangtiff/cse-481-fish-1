extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var tile_marker = $AnimatedSprite2D/TileMarker
@onready var waiting: Sprite2D = $Waiting
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var waiting_timer: Timer = $WaitingTimer

const SPEED = 70.0

var rng = RandomNumberGenerator.new()
var startFishing = false
var waitForFish = false
var fishBitten = false
var maxWaitingTime = 4

func _ready() -> void:
	waiting.visible = false

func _physics_process(_delta):
	if startFishing: _fishing_state()
	else: _move_state()
	
	move_and_slide()

func _move_state():
	if Input.is_action_just_pressed("ui_fish"):
		_start_fishing()
		return
	
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if velocity.x < 0: animated_sprite_2d.scale.x = -1
	elif velocity.x >0: animated_sprite_2d.scale.x = 1
	
	if velocity: animated_sprite_2d.play("walk_forward")
	else: animated_sprite_2d.play("idle")

func _fishing_state():
	velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("ui_fish") && fishBitten:
		_start_mini_game()
		_stop_fishing()
	
	if waitForFish: _wait_for_fish()
	if fishBitten: _fish_bitten_animation()

func _start_fishing():
	if not _get_tile_data() == "Water": return
	
	startFishing = true
	animated_sprite_2d.play("fishing_start")

func _stop_fishing():
	fishBitten = false
	waitForFish = false
	animation_player.stop()
	animated_sprite_2d.visible = true
	waiting.visible = false
	animated_sprite_2d.play("fishing_end")

func _wait_for_fish():
	animated_sprite_2d.visible = false
	waiting.scale = animated_sprite_2d.scale
	animation_player.play("waiting")
	
	if waiting_timer.time_left == 0:
		waiting_timer.wait_time = rng.randf_range(0, maxWaitingTime)
		waiting_timer.start()

func _fish_bitten_animation():
	var forceX = rng.randf_range(-1, 1) * 2
	var forceY = rng.randf_range(-1, 1) * 2
	
	waiting.offset = Vector2(forceX, forceY)

func _get_tile_data():
	var tileMap = get_parent().find_child("Ocean")
	var searchPosition = tileMap.local_to_map(tile_marker.global_position)
	var data = tileMap.get_cell_tile_data(searchPosition)
	print(searchPosition)
	if data: return data.get_custom_data("type")

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "fishing_start":
		waitForFish = true
	elif animated_sprite_2d.animation == "fishing_end":
		startFishing = false
		

var fishingGameScene = preload("res://fishing_minigame/fishing_minigame.tscn")
var fishingGame: Node = null  # reference to the instantiated minigame

func _start_mini_game():
	# 1️⃣ Pause the main game while the minigame is active
	get_tree().paused = true
	PhysicsServer2D.set_active(true)
	
	# 2️⃣ Instance the minigame scene
	fishingGame = fishingGameScene.instantiate()
	get_tree().current_scene.add_child(fishingGame)

	# 3️⃣ Connect the fish_caught signal from the child node that has fishing_game.gd
	GameEvents.fish_caught.connect(_on_fish_caught)

func _on_fish_caught():
	# 1️⃣ Remove the minigame from the scene
	if is_instance_valid(fishingGame):
		fishingGame.queue_free()
		fishingGame = null

	# 2️⃣ Unpause the main game
	get_tree().paused = false

	# 3️⃣ Play player's "fishing_end" animation
	animated_sprite_2d.play("fishing_end")

	# 4️⃣ Start dialogue using DialogueManager
	var dialogueRes: DialogueResource = preload("res://dialogue/dialogueFile.dialogue")
	var balloon_scene = preload("res://dialogue/balloon.tscn").instantiate()
	
	# Use DialogueManager helper to start the balloon
	DialogueManager._start_balloon(balloon_scene, dialogueRes, "start", [])




func _on_waiting_timer_timeout() -> void:
	waiting_timer.stop()
	animation_player.stop()
	fishBitten = true
	waitForFish = false
