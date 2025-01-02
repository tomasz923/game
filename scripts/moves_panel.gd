extends Control

@onready var move_info = $UpperPanels/MainPanel/MoveInfo
@onready var scroll_container = $UpperPanels/MainPanel/ScrollContainer
@onready var odd = $UpperPanels/MainPanel/ScrollContainer/MovesContainer/Odd
@onready var even = $UpperPanels/MainPanel/ScrollContainer/MovesContainer/Even

@onready var moves_description = $UpperPanels/MainPanel/MoveInfo/MovesDescription
@onready var moves_name = $UpperPanels/MainPanel/MoveInfo/MovesName
@onready var expected_damage_string = $UpperPanels/MainPanel/MoveInfo/Control/ExtraMoveInfoDamage/ExpectedDamageString
@onready var expected_damage_value = $UpperPanels/MainPanel/MoveInfo/Control/ExtraMoveInfoDamage/ExpectedDamageValue
@onready var expected_outcome_value = $UpperPanels/MainPanel/MoveInfo/Control/ExtraMoveInfoChances/ExpectedOutcomeValue
@onready var description = $UpperPanels/MainPanel/MoveInfo/MovesDescription/Description
@onready var bonuses = $UpperPanels/RightPanelContainer/RightPanel/Bonuses
@onready var extra_move_info_damage = $UpperPanels/MainPanel/MoveInfo/Control/ExtraMoveInfoDamage
@onready var damages = $UpperPanels/LeftPanelContainer/LeftPanel/Damages

@onready var left_panel = $UpperPanels/LeftPanelContainer/LeftPanel
@onready var right_panel = $UpperPanels/RightPanelContainer/RightPanel

@onready var hide_right_panel_button = $BottomPanel/ButtonsContainer/HideRightPanelButton
@onready var show_right_panel_button = $BottomPanel/ButtonsContainer/ShowRightPanelButton
@onready var hide_left_panel_button = $BottomPanel/ButtonsContainer/HideLeftPanelButton
@onready var show_left_panel_button = $BottomPanel/ButtonsContainer/ShowLeftPanelButton

@onready var buttons_container = $BottomPanel/ButtonsContainer
@onready var choose_move_label = $BottomPanel/ChooseMoveLabel
@onready var user_prefs: UserPreferences
@onready var left_unblur = $UpperBlurs/LeftUnblur
@onready var left_blur = $UpperBlurs/LeftBlur
@onready var right_blur = $UpperBlurs/RightBlur
@onready var right_unblur = $UpperBlurs/RightUnblur

@onready var fail_chance = $UpperPanels/RightPanelContainer/RightPanel/Chances/FailContainer/FailChance
@onready var fail_result = $UpperPanels/RightPanelContainer/RightPanel/Chances/FailContainer/FailResult
@onready var partial_success_chance = $UpperPanels/RightPanelContainer/RightPanel/Chances/PartialSuccessContainer/PartialSuccessChance
@onready var partial_sucsess_result = $UpperPanels/RightPanelContainer/RightPanel/Chances/PartialSuccessContainer/PartialSucsessResult
@onready var success_result = $UpperPanels/RightPanelContainer/RightPanel/Chances/SuccessContainer/SuccessResult
@onready var success_chance = $UpperPanels/RightPanelContainer/RightPanel/Chances/SuccessContainer/SuccessChance

const BONUS_NUMBERS_LABEL = preload("res://game/resources/bonus_numbers_label.tres")
const BONUS_NUMBERS_LABEL_RED = preload("res://game/resources/bonus_numbers_label_red.tres")
const BONUS_NUMBERS_LABEL_GREEN = preload("res://game/resources/bonus_numbers_label_green.tres")
const BONUS_NUMBERS_LABEL_YELLOW = preload("res://game/resources/bonus_numbers_label_yellow.tres")
const MVP_BONUS_NUMBERS_LABEL = preload("res://game/resources/mvp_bonus_numbers_label.tres")
const MVP_BONUS_NUMBERS_LABEL_GREEN = preload("res://game/resources/mvp_bonus_numbers_label_green.tres")
const MVP_BONUS_NUMBERS_LABEL_RED = preload("res://game/resources/mvp_bonus_numbers_label_red.tres")
const MVP_BONUS_NUMBERS_LABEL_YELLOW = preload("res://game/resources/mvp_bonus_numbers_label_yellow.tres")


var variable_was_changed: bool = false

func _on_hide_right_panel_button_pressed():
	right_panel.visible = false
	hide_right_panel_button.visible = false
	show_right_panel_button.visible = true
	right_blur.visible = false
	right_unblur.visible = true
	Global.user_prefs.mvp_right_panel_visible = false
	Global.user_prefs.save()

func _on_show_right_panel_button_pressed():
	right_panel.visible = true
	hide_right_panel_button.visible = true
	show_right_panel_button.visible = false
	right_blur.visible = true
	right_unblur.visible = false
	Global.user_prefs.mvp_right_panel_visible = true
	Global.user_prefs.save()

func _on_hide_left_panel_button_pressed():
	left_panel.visible = false
	hide_left_panel_button.visible = false
	show_left_panel_button.visible = true
	left_unblur.visible = true
	left_blur.visible = false
	Global.user_prefs.mvp_left_panel_visible = false
	Global.user_prefs.save()

func _on_show_left_panel_button_pressed():
	left_panel.visible = true
	hide_left_panel_button.visible = true
	show_left_panel_button.visible = false
	left_unblur.visible = false
	left_blur.visible = true
	Global.user_prefs.mvp_left_panel_visible = true
	Global.user_prefs.save()

func show_chances(fail: float, partial_success: float, success: float, total_bonus: int):
	var chances = [fail, partial_success, success]
	var chance_labels = [fail_chance, partial_success_chance, success_chance]
	var highest_chance = snapped(max(fail, partial_success, success), 1)
	
	for i in len(chance_labels):
		chance_labels[i].text = str(snapped(chances[i], 1)) + '%'
	
	if snapped(fail, 1) == highest_chance:
		fail_chance.set("label_settings", BONUS_NUMBERS_LABEL_RED)
		fail_result.set("label_settings", MVP_BONUS_NUMBERS_LABEL_RED)
	else:
		fail_chance.set("label_settings", BONUS_NUMBERS_LABEL)
		fail_result.set("label_settings", MVP_BONUS_NUMBERS_LABEL)
	
	if snapped(partial_success, 1) == highest_chance:
		partial_success_chance.set("label_settings", BONUS_NUMBERS_LABEL_YELLOW)
		partial_sucsess_result.set("label_settings", MVP_BONUS_NUMBERS_LABEL_YELLOW)
	else:
		partial_success_chance.set("label_settings", BONUS_NUMBERS_LABEL)
		partial_sucsess_result.set("label_settings", MVP_BONUS_NUMBERS_LABEL)
	
	if snapped(success, 1) == highest_chance:
		success_chance.set("label_settings", BONUS_NUMBERS_LABEL_GREEN)
		success_result.set("label_settings", MVP_BONUS_NUMBERS_LABEL_GREEN)
	else:
		success_chance.set("label_settings", BONUS_NUMBERS_LABEL)
		success_result.set("label_settings", MVP_BONUS_NUMBERS_LABEL)
	
	if total_bonus > 0:
		expected_outcome_value.text = '+' + str(total_bonus)
		expected_outcome_value.set("label_settings", MVP_BONUS_NUMBERS_LABEL_GREEN)
	elif total_bonus < 0:
		expected_outcome_value.text = str(total_bonus)
		expected_outcome_value.set("label_settings", MVP_BONUS_NUMBERS_LABEL_RED)
	else:
		expected_outcome_value.text = str(total_bonus)
		expected_outcome_value.set("label_settings", MVP_BONUS_NUMBERS_LABEL_YELLOW)

func _on_go_back_button_pressed():
	scroll_container.visible = true
	move_info.visible = false
	choose_move_label.visible = true
	buttons_container.visible = false
	left_panel.visible = false
	right_panel.visible = false
	left_unblur.visible = true
	left_blur.visible = false
	right_blur.visible = false
	right_unblur.visible = true
	clear_bonuses()
	
func clear_bonuses():
	for n in bonuses.get_children():
		bonuses.remove_child(n)
		n.queue_free() 
func clear_damages():
	for n in damages.get_children():
		damages.remove_child(n)
		n.queue_free() 
