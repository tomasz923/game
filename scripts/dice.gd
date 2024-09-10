extends Control

@onready var reel = $DiceScreen/HBoxContainer/Reel
@onready var reel_2 = $DiceScreen/HBoxContainer/Reel2
@onready var start_rolling = $DiceScreen/StartRolling
@onready var ok_button = $DiceScreen/OkButton
@onready var result = $DiceScreen/Result

var is_roll_one_done: bool = false
var is_roll_two_done: bool = false
var first_number: int
var second_number: int

func ready_reels():
	reel._ready()
	reel_2._ready()
	start_rolling.visible = true
	result.visible = false
	ok_button.visible = false
	is_roll_one_done = false
	is_roll_two_done = false
	
func _on_start_rolling_pressed():
	reel.is_rolling = true
	reel_2.is_rolling = true
	start_rolling.visible = false

func _on_reel_roll_done(rolled_number):
	print('roll 1 done')
	is_roll_one_done = true
	first_number = rolled_number
	if is_roll_two_done:
		show_results()

func _on_reel_2_roll_done(rolled_number):
	print('rool 2 done')
	is_roll_two_done = true
	second_number = rolled_number
	if is_roll_one_done:
		show_results() 

func show_results():
	Global.state_var_dialogue['rolled_number'] = first_number + second_number
	result.text = str(first_number + second_number)
	result.visible = true
	ok_button.visible = true

func _on_ok_button_pressed():
	Global.dice_box.visible = false
	Global.is_rolling_dice_now = false
	Global.dialogue_box.next_slide()
