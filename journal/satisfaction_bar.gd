extends Control
@onready var progress_bar = $PanelContainer/MarginContainer/ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func _change_satisfaction_value(amt) -> void:
	progress_bar.value = amt
