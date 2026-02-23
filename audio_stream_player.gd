extends Node

var music_player: AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS  # add this line
	music_player.stream = preload("res://bassa-island-game-loop-kevin-macleod-main-version-8008-00-32.mp3")
	music_player.play()
