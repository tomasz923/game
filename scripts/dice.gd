extends Control

@onready var reel = $DiceScreen/HBoxContainer/Reel
@onready var reel_2 = $DiceScreen/HBoxContainer/Reel2
@onready var start_rolling = $DiceScreen/StartRolling
@onready var ok_button = $DiceScreen/OkButton
@onready var result = $DiceScreen/Result
@onready var bonus_label_scn = preload("res://game/scenes/bonus_label.tscn")
@onready var listed_bonuses = $DiceScreen/BonusesNode/ListedBonuses

var is_roll_one_done: bool = false
var is_roll_two_done: bool = false
var first_number: int
var second_number: int
var attribute: String
var bonuses: Array
var total_bonus: int
var current_dice_roll: Dictionary
var rolling_for: String
var new_container: HBoxContainer


func ready_reels(which_dice_roll):
	for n in listed_bonuses.get_children():
		listed_bonuses.remove_child(n)
		n.queue_free() 
	
	bonuses = []
	total_bonus = 0
	reel._ready()
	reel_2._ready()
	start_rolling.visible = true
	result.visible = false
	ok_button.visible = false
	is_roll_one_done = false
	is_roll_two_done = false
	
	rolling_for = which_dice_roll
	current_dice_roll = Global.dice_rolls_data[which_dice_roll]
	bonuses = current_dice_roll['state_vars']
	attribute = current_dice_roll['attribute']
	
	count_bonus()
	list_bonuses()
	
func count_bonus():
	total_bonus += Global.state_var_dialogue[attribute] #has to be changed to attribute list later
	for bonus in bonuses:
		#print('DEBUG: printing bonus in bonuses: ', bonus)
		if Global.state_var_dialogue[bonus['state_var']] == int(bonus['value']):
			total_bonus += int(bonus['roll_effect'])

func list_bonuses():
	new_container = HBoxContainer.new()
	new_container.alignment = BoxContainer.ALIGNMENT_CENTER
	create_bonus_number(int(Global.state_var_dialogue[attribute]), new_container)
	create_bonus_description(attribute, new_container)
	listed_bonuses.add_child(new_container)
	for bonus in bonuses:
		if Global.state_var_dialogue[bonus['state_var']] == int(bonus['value']):
			var bonus_number = bonus['roll_effect']
			var bonus_description = bonus['description']
			new_container = HBoxContainer.new()
			new_container.alignment = BoxContainer.ALIGNMENT_CENTER
			create_bonus_number(int(bonus_number), new_container)
			create_bonus_description(bonus_description, new_container)
			listed_bonuses.add_child(new_container)

func create_bonus_number(number, container: HBoxContainer):
	var bonus_label: BonusLabel = bonus_label_scn.instantiate()
	if int(number) > 0:
		bonus_label.text = "+" + str(number)
	else:
		bonus_label.text = str(number)
	bonus_label.bonus_number()
	container.add_child(bonus_label)

func create_bonus_description(description: String, container: HBoxContainer):
	var bonus_label: BonusLabel = bonus_label_scn.instantiate()
	bonus_label.text = description
	bonus_label.bonus_description()
	container.add_child(bonus_label)

func _on_start_rolling_pressed():
	reel.is_rolling = true
	reel_2.is_rolling = true
	start_rolling.visible = false

func _on_reel_roll_done(rolled_number):
	is_roll_one_done = true
	first_number = rolled_number
	if is_roll_two_done:
		show_results()

func _on_reel_2_roll_done(rolled_number):
	is_roll_two_done = true
	second_number = rolled_number
	if is_roll_one_done:
		show_results() 

func show_results():
	Global.state_var_dialogue[rolling_for] = first_number + second_number + total_bonus
	result.text = str(first_number + second_number + total_bonus)
	result.visible = true
	ok_button.visible = true

func _on_ok_button_pressed():
	Global.dice_box.visible = false
	Global.is_rolling_dice_now = false
	Global.dialogue_box.next_slide()

#func add_choice(choice_text: String):
	#var button_obj: ChoiceButton = choice_button_scn.instantiate()
	#button_obj.choice_index =  choice_buttons.size()
	#choice_buttons.push_back(button_obj)
	#button_obj.text = choice_text
	#button_obj.choice_selected.connect(_on_choice_selected)
	#v_box_container.add_child(button_obj)
