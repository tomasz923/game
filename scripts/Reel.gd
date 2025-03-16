extends Control

signal roll_done(rolled_number: int)

@export var roll_duration_length: int = 2

@onready var reel_1 = $Reel1
@onready var reel_2 = $Reel2


var is_rolling: bool = false
var is_getting_ready: bool = false
var roll_duration: int = 2
var roll_speed: int = 45
var rng: int
var final_pos: int
var stopping_pos: int
var another_pos: int
var final_slot
var TWN
var safe_break: int = 2

func _ready():
	reel_1.position.y = -415
	reel_2.position.y = -1405
	roll_duration = roll_duration_length
	rng = randi_range(1,6)
	#rng = 4
	match_rng(rng)
	
func _process(_delta):
	if is_rolling:
		_roll()
		
		if roll_duration == 0:
			is_rolling = false
			is_getting_ready = true
	if is_getting_ready:
		_readyRoll()
		if reel_2.position.y > (stopping_pos - 20) and reel_2.position.y < (stopping_pos + 20):
			_stopRoll()

func combat_result(result: int):
	match_rng(result)
	reel_1.position.y = final_pos

func _roll():
	var newPOS1 = reel_1.position.y + roll_speed
	var newPOS2 = reel_2.position.y + roll_speed
	
	if newPOS1 >= 575:
		newPOS1 = -1405
		#roll_speed -= 2
	reel_1.position.y = newPOS1
	
	if newPOS2 >= 575:
		newPOS2 = -1405 
		#roll_speed -= 2
		roll_duration -= 1
	reel_2.position.y = newPOS2	
	
func _readyRoll():	
	var newPOS1 = reel_1.position.y + roll_speed
	var newPOS2 = reel_2.position.y + roll_speed

	if newPOS1 >= 575:
		newPOS1 = -1405 
	reel_1.position.y = newPOS1
	
	if newPOS2 >= 575:
		newPOS2 = -1405 
		safe_break -= 1
	reel_2.position.y = newPOS2

func _stopRoll():
	var another_slot
	is_getting_ready = false
	
	TWN = create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT).set_parallel()
	
	if final_slot == reel_2:
		another_slot = reel_1
	elif final_slot == reel_1:
		another_slot = reel_2#

	TWN.tween_property(final_slot, "position:y", final_pos, 1.2)
	TWN.tween_property(another_slot, "position:y", another_pos, 1.2)

	await TWN.finished
	roll_done.emit(rng)

func match_rng(num: int):
	match num:
		1:
			final_pos = 410
			stopping_pos = 80
			another_pos = final_pos - 990
			final_slot = reel_2
		2:
			final_pos = 245
			stopping_pos = -85
			final_slot = reel_2
			another_pos = final_pos - 990
		3:
			final_pos = 80
			stopping_pos = -250
			final_slot = reel_2
			another_pos = final_pos - 990
		4:
			final_pos = -85
			stopping_pos = -415
			final_slot = reel_1
			another_pos = final_pos + 990
		5: 
			final_pos = -250
			stopping_pos = 410
			final_slot = reel_1
			another_pos = final_pos + 990
			
		6:
			final_pos = -415
			stopping_pos = 245
			final_slot = reel_1
			another_pos = final_pos + 990
