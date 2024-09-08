extends Control

@onready var reel = $DiceScreen/HBoxContainer/Reel
@onready var reel_2 = $DiceScreen/HBoxContainer/Reel2


func _on_start_rolling_pressed():
	reel.is_rolling = true
	reel_2.is_rolling = true
