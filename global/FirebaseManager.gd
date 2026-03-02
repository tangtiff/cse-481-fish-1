extends Node

var session_timer: Timer = Timer.new()
var version = GameEvents.get_version()
var startTime;
var ipv6 = IP.get_local_addresses()[0]
var fishCaught = 0
var matchesAttempted = 0
var playtime = 0

const ENABLE_LOGGING = true
const TIME_BETWEEN_LOGS: int = 60

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

	# Timing tomfoolery for logging
	startTime = Time.get_unix_time_from_system()
	add_child(session_timer)
	session_timer.timeout.connect(_on_timer_timeout)

	# Used to disable logging during testing
	if ENABLE_LOGGING:
		session_timer.start(TIME_BETWEEN_LOGS)
		log_data(false, false, true) # initial log

func log_data(fishEvent: bool, matchEvent: bool, timeEvent: bool) -> void:
	var path: String = "v" + version
	var data = {
		"ip" : ipv6,
		"playtime" : Time.get_unix_time_from_system() - startTime,
		"fishCaught" : fishCaught,
		"matchesAttempted" : matchesAttempted,
		"fishEvent" : fishEvent,
		"matchEvent" : matchEvent,
		"timeEvent" : timeEvent,
		"a-b" : GameEvents.ABVERSION
	}
	FirebaseLite.RealtimeDatabase.push(path, data)

func _on_timer_timeout() -> void:
	log_data(false, false, true)
	session_timer.start(TIME_BETWEEN_LOGS)
