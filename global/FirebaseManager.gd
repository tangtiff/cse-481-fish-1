extends Node

var session_timer: Timer = Timer.new()
var userID: int = randi() # FIX THIS TO GRAB FROM BROWSER
var version = GameEvents.get_version()
var playtime = 0

const ENABLE_LOGGING = false
const TIME_BETWEEN_LOGS: int = 120

const firebaseConfig = {
  "apiKey": "AIzaSyDwzaxvsOjJAuX5HWvqo-F3dQaxGXrDgxM",
  "authDomain": "fish-game-91443.firebaseapp.com",
  "databaseURL": "https://fish-game-91443-default-rtdb.firebaseio.com",
  "projectId": "fish-game-91443",
  "storageBucket": "fish-game-91443.firebasestorage.app",
  "messagingSenderId": "355397986176",
  "appId": "1:355397986176:web:90a33b0fd322ca04aa4365",
  "measurementId": "G-YH2ZEDP8SK"
};


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FirebaseLite.initialize(firebaseConfig)
	FirebaseLite.terminate("Authentication")
	FirebaseLite.terminate("Firestore")
	FirebaseLite.terminate("Storage")
	
	add_child(session_timer)
	session_timer.timeout.connect(_on_timer_timeout)
	if ENABLE_LOGGING:
		session_timer.start(TIME_BETWEEN_LOGS)
		log_data()

func log_data() -> void:
	var path: String = "version_" + version + "/" + str(userID)
	var data = {
		"timeStamp" : Time.get_datetime_string_from_system(true),
		"playtime" : playtime,
		"numFishCaught" : len(GameEvents.get_unlocked_fish()),
		"numMatches" : len(GameEvents.get_matches())
	}
	FirebaseLite.RealtimeDatabase.push(path, data)

func _on_timer_timeout() -> void:
	playtime += TIME_BETWEEN_LOGS
	log_data()
	session_timer.start(TIME_BETWEEN_LOGS)
