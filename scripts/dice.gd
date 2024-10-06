extends Control

@onready var reel = $DiceScreen/HBoxContainer/Reel
@onready var reel_2 = $DiceScreen/HBoxContainer/Reel2
@onready var start_rolling = $DiceScreen/StartRolling
@onready var ok_button = $DiceScreen/OKButtonContainer/OkButton
@onready var bonus_label_scn = preload("res://game/scenes/bonus_label.tscn")
@onready var listed_bonuses = $DiceScreen/BonusesNode/ListedBonuses
@onready var label = $DiceScreen/Label
@onready var animation_player = $AnimationPlayer
@onready var dice_screen = $DiceScreen
@onready var chances_h_box = $DiceScreen/ChancesHBox
@onready var bonuses_node = $DiceScreen/BonusesNode
@onready var fail_chance = $DiceScreen/ChancesHBox/FailChance
@onready var complications_chance = $DiceScreen/ChancesHBox/ComplicationsChance
@onready var success_chance = $DiceScreen/ChancesHBox/SuccessChance
@onready var result_backg = $DiceScreen/ResultShow/ResultBackg
@onready var result_label = $DiceScreen/ResultShow/ResultBackg/VBoxContainer/ResultLabel
@onready var ok_button_container = $DiceScreen/OKButtonContainer

#@onready var result_number = $DiceScreen/ResultShow/ResultBackg/VBoxContainer/ResultNumber

#@onready var success_theme_chance = preload("res://game/resources/chances_success.tres")
#@onready var failure_theme_chance = preload("res://game/resources/chances_fail.tres")
#@onready var complications_theme_chance = preload("res://game/resources/chances_complications.tres")
#@onready var normal_theme_chance = preload("res://game/resources/chances.tres")

var result: int
var is_roll_one_done: bool = false
var is_roll_two_done: bool = false
var first_number: int
var second_number: int
var failure_prob: float
var complication_prob: float
var success_prob: float
var roll_type: String
var bonuses: Array
var total_bonus: int
var current_dice_roll: Dictionary
var rolling_for: String
var attribute: String
var new_container: HBoxContainer
var viewport

var prob_table: Array = [
	[2, 2.77777777778],
	[3, 5.55555555556],
	[4, 8.33333333333],
	[5, 11.1111111111],
	[6, 13.8888888889],
	[7, 16.6666666667],
	[8, 13.8888888889],
	[9, 11.1111111111],
	[10, 8.33333333333],
	[11, 5.55555555556],
	[12, 2.77777777778]
]


func ready_reels(which_dice_roll):
	viewport = get_viewport()
	dice_screen.position.x = DisplayServer.screen_get_size().x/2 - 250
	
	for n in listed_bonuses.get_children():
		listed_bonuses.remove_child(n)
		n.queue_free() 
	result_backg.position.y = -130
	
	bonuses = []
	total_bonus = 0
	failure_prob = 0
	complication_prob = 0
	success_prob = 0
	reel._ready()
	reel_2._ready()
	start_rolling.visible = true
	ok_button_container.visible = false
	#chances_h_box.visible = true #Not needed for such rolls
	bonuses_node.visible = true
	is_roll_one_done = false
	is_roll_two_done = false
	
	rolling_for = which_dice_roll
	current_dice_roll = Global.dice_rolls_data[which_dice_roll]
	bonuses = current_dice_roll['state_vars']
	roll_type = current_dice_roll['roll_type']
	label.text = roll_type
	attribute = Global.roll_types[roll_type]
	
	count_bonus()
	list_bonuses()
	#calculate_chances() #No chances visible needed for such rolls
	
	#animation_player.play("fade_in")
	var TWN = create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT).set_parallel()
	TWN.tween_property(dice_screen, "position:y", 155, 1.0)
	
func count_bonus():
	if Global.state_var_dialogue[attribute] != 0:
		total_bonus += Global.state_var_dialogue[attribute] #has to be changed to attribute list later
	for bonus in bonuses:
		#print('DEBUG: printing bonus in bonuses: ', bonus)
		if Global.state_var_dialogue[bonus['state_var']] == int(bonus['value']):
			total_bonus += int(bonus['roll_effect'])
	for row in prob_table:
		if row[0] + total_bonus > 9:
			success_prob += row[1]
		elif row[0] + total_bonus < 7:
			failure_prob += row[1]
		else:
			complication_prob += row[1]

func list_bonuses():
	if Global.state_var_dialogue[attribute] != 0:
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
	#chances_h_box.visible = false
	bonuses_node.visible = false

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

func calculate_chances():
	var probs = [failure_prob, complication_prob, success_prob]
	var chances_buttons = [fail_chance, complications_chance, success_chance]
	var highest_prob = max(failure_prob, complication_prob, success_prob)
	
	for i in len(probs):
		var chance_button = chances_buttons[i]
		var prob_value = probs[i]
		chance_button.text = str(snapped(prob_value, 0.1)) + "%"
		if prob_value == highest_prob:
			chance_button.get_colored()
		else:
			chance_button.get_normal()

func show_results():
	result = first_number + second_number + total_bonus
	Global.state_var_dialogue[rolling_for] = result
	if result > 9:
		result_backg.color = '#55927f'
		result_label.text = 'label_roll_result_success'
	elif result < 7:
		result_backg.color = '#dc6250'
		result_label.text = 'label_roll_result_fail'
	else:
		result_backg.color = '#eeb24a'
		result_label.text = 'label_roll_result_complications'
	#result_number.text = str(result)
	var TWN = create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT).set_parallel()
	TWN.tween_property(result_backg, "position:y", 20, 1.0)
	await TWN.finished
	#result.text = str(first_number + second_number + total_bonus)
	#result.visible = true
	ok_button_container.visible = true
	TWN = create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT).set_parallel()
	TWN.tween_property(ok_button, "position:y", 14, 1.0)
	

func _on_ok_button_pressed():
	var TWN = create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT).set_parallel()
	Global.is_rolling_dice_now = false
	Global.dialogue_box.next_slide()
	Global.dialogue_box.fade_out()
	#Global.dialogue_box.visible = true
	#animation_player.play("fade_out")
	TWN.tween_property(dice_screen, "position:y", -665, 1.0)
	await TWN.finished
	Global.dice_box.visible = false
	

#func add_choice(choice_text: String):
	#var button_obj: ChoiceButton = choice_button_scn.instantiate()
	#button_obj.choice_index =  choice_buttons.size()
	#choice_buttons.push_back(button_obj)
	#button_obj.text = choice_text
	#button_obj.choice_selected.connect(_on_choice_selected)
	#v_box_container.add_child(button_obj)
