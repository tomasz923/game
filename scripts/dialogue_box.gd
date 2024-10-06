extends Control

@onready var dialogue_box = $"."
@onready var text_label = $Text
@onready var choices_box = $ChoicesContainer/ChoicesBox
@onready var speaker_name = $Name/SpeakerName
@onready var choice_button_scn = preload("res://game/scenes/choice_button.tscn")
@onready var ez_dialogue: EzDialogue = $DialogueHandler/EzDialogue
@onready var continue_button = $ContinueButton
@onready var animation_player = $AnimationPlayer
@onready var choices_container = $ChoicesContainer

var choice_buttons: Array[Button] = []
var awaiting_response: bool = false
var is_going_down: bool = false
var is_down: bool = false
var talker_name: String
var choice_len: int = 0

func _process(_delta):
	if awaiting_response and Input.is_action_just_pressed("interact"):
		next_slide()

func _start_dialogue(dialogue_file, talker: String):
	ez_dialogue.start_dialogue(dialogue_file, Global.state_var_dialogue)
	Global.state_var_dialogue['talker'] = talker
	speaker_name.text = Global.state_var_dialogue['talker'] 
	#animation_player.play("jumping_arrow")

func add_text(text: String):
	text_label.text = text

func clear_dialogue_box():
	choice_len = 0
	text_label.visible = false
	for choice in choice_buttons:
		choices_box.remove_child(choice)
	choice_buttons = []

func add_choice(choice_text: String):
	var button_obj: ChoiceButton = choice_button_scn.instantiate()
	button_obj.choice_index =  choice_buttons.size()
	choice_buttons.push_back(button_obj)
	button_obj.text = choice_text
	button_obj.choice_selected.connect(_on_choice_selected)
	choices_box.add_child(button_obj)
	if button_obj.size.x > choice_len:
		choice_len = int(button_obj.size.x)
		print('DEBUG: The longest size is now: ', choice_len)

func _on_choice_selected(choice_index: int):
	#AWAIT and disable buttons
	ez_dialogue.next(choice_index)
	print(choice_index)

#func _on_ez_dialogue_dialogue_generated(response: DialogueResponse):


#func _on_ez_dialogue_custom_signal_received(value: String):


#func _on_ez_dialogue_end_of_dialogue_reached():


func next_slide():
	awaiting_response = false
	continue_button.visible = false
	_on_choice_selected(0)

func _on_ez_dialogue_dialogue_generated(response):
	#if is_going_down:
		#pass
		#var TWN = create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT).set_parallel()
		#TWN.tween_property(dialogue_box, "position:y", 800, 1.0)
		#await TWN.finished
		#dialogue_box.visible = false
		#is_down = true
		#is_going_down = false
	#elif is_down:
		#pass
		#var TWN = create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT).set_parallel()
		#TWN.tween_property(dialogue_box, "position:y", 0, 1.0)
		#is_down = false
	clear_dialogue_box()
	
	if response.text != '':
		speaker_name.visible = true
		speaker_name.text = Global.state_var_dialogue['talker'] 
		text_label.visible = true
		add_text(response.text)
	
	if response.choices.is_empty() and !Global.is_rolling_dice_now:
		awaiting_response = true
		continue_button.visible = true
		#add_choice('..')
	else:
		speaker_name.visible = false
		for choice in response.choices:
			add_choice(choice)
		for choice in choice_buttons:
			choice.custom_minimum_size.x = choice_len
		choices_container.custom_minimum_size.x = choice_len + 20

func _on_ez_dialogue_end_of_dialogue_reached():
	Global.talker.is_talking = false
	Global.pausable = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.allow_movement = true
	Global.dialogue_box.visible = false
	Global.main_cam.current = true

func _on_ez_dialogue_custom_signal_received(value):
	var params = value.split(",")
	match params[0]:
		"set":
			var variable_name = params[1]
			var variable_value = params[2]
			Global.state_var_dialogue[variable_name] = variable_value
		"cam":
			var cam_num = params[1]
			match cam_num:
				"t": 
					Global.talker_cam.current = true
				"p":
					Global.player_cam.current = true
		"dice":
			is_going_down = true
			var which_dice_roll = params[1]
			Global.dice_box.ready_reels(which_dice_roll)
			fade_in()
			Global.dice_box.visible = true
			Global.is_rolling_dice_now = true

func fade_out():
	animation_player.play("fade_out")

func fade_in():
	animation_player.play("fade_in")
