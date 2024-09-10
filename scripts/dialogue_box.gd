extends Control

@onready var text_label = $TextureRect/VBoxContainer/Text
@onready var v_box_container = $TextureRect/VBoxContainer
@onready var speaker_name = $TextureRect/SpeakerName
@onready var choice_button_scn = preload("res://game/scenes/choice_button.tscn")
@onready var ez_dialogue: EzDialogue = $DialogueHandler/EzDialogue
@onready var script_file: JSON = preload("res://game/script/demo.json")
@onready var continue_button = $TextureRect/ContinueButton

var choice_buttons: Array[Button] = []
var awaiting_response: bool = false

func _process(_delta):
	if awaiting_response and Input.is_action_just_pressed("interact"):
		next_slide()

func _start_dialogue(dialogue_file):
	ez_dialogue.start_dialogue(dialogue_file, Global.state_var_dialogue)

func add_text(text: String):
	text_label.text = text

func clear_dialogue_box():
	text_label.visible = false
	for choice in choice_buttons:
		v_box_container.remove_child(choice)
	choice_buttons = []

func add_choice(choice_text: String):
	var button_obj: ChoiceButton = choice_button_scn.instantiate()
	button_obj.choice_index =  choice_buttons.size()
	choice_buttons.push_back(button_obj)
	button_obj.text = choice_text
	button_obj.choice_selected.connect(_on_choice_selected)
	v_box_container.add_child(button_obj)

func _on_choice_selected(choice_index: int):
	ez_dialogue.next(choice_index)
	print(choice_index)

func _on_ez_dialogue_dialogue_generated(response: DialogueResponse):
	clear_dialogue_box()
	
	if response.text != '':
		text_label.visible = true
		add_text(response.text)
	
	if response.choices.is_empty() and !Global.is_rolling_dice_now:
		awaiting_response = true
		continue_button.visible = true
		#add_choice('..')
	else:
		for choice in response.choices:
			add_choice(choice)

func _on_ez_dialogue_custom_signal_received(value: String):
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
			Global.dice_box.ready_reels()
			Global.dice_box.visible = true
			Global.is_rolling_dice_now = true

func _on_ez_dialogue_end_of_dialogue_reached():
	Global.talker.is_talking = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.allow_movement = true
	Global.dialogue_box.visible = false
	Global.main_cam.current = true

func next_slide():
	awaiting_response = false
	continue_button.visible = false
	_on_choice_selected(0)
