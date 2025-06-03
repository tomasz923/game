extends Control

@onready var button_pressed: AudioStreamPlayer = $ButtonPressed
@onready var character_sheet_button: Button = $BlackRectangle/SettingsContainer/CharacterSheetButton
@onready var inventory_button: Button = $BlackRectangle/SettingsContainer/InventoryButton
@onready var moves_button: Button = $BlackRectangle/SettingsContainer/MovesButton
@onready var journal_button: Button = $BlackRectangle/SettingsContainer/JournalButton

@onready var portrait: TextureRect = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/FirstLayer/Portrait
@onready var name_label: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/FirstLayer/InfoBox/NameLabel
@onready var class_label: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/FirstLayer/InfoBox/ClassLabel
@onready var level_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/FirstLayer/InfoBox/QucikStats/RightColumn/LevelVal
@onready var xp_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/FirstLayer/InfoBox/QucikStats/RightColumn/XPVal
@onready var hp_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/FirstLayer/InfoBox/QucikStats/RightColumn/HPVal
@onready var ap_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/FirstLayer/InfoBox/QucikStats/RightColumn/APVal
@onready var ap_label: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/FirstLayer/InfoBox/QucikStats/LeftColumn/APLabel

@onready var str_panel: ColorRect = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/StrPanel
@onready var strength_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/StrPanel/StrengthVal
@onready var dex_panel: ColorRect = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/DexPanel
@onready var dexterity_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/DexPanel/DexterityVal
@onready var end_panel: ColorRect = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/EndPanel
@onready var endurance_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/EndPanel/EnduranceVal
@onready var pro_panel: ColorRect = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/ProPanel
@onready var processing_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/ProPanel/ProcessingVal
@onready var mem_panel: ColorRect = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/MemPanel
@onready var memory_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/MemPanel/MemoryVal
@onready var cha_panel: ColorRect = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/ChaPanel
@onready var charisma_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/ChaPanel/CharismaVal

@onready var coins_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/ThirdLayer/CurrencyContainer/CoinsVal
@onready var supplies_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/ThirdLayer/SuppliesContainer/SuppliesVal

@onready var status_effects_button: TextureButton = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/PanelButtonsContainer/SubButtons/StatusEffectsButton
@onready var bonds_button: TextureButton = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/PanelButtonsContainer/SubButtons/BondsButton
@onready var history_button: TextureButton = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/PanelButtonsContainer/SubButtons/HistoryButton
@onready var sub_panel_label: Label = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/PanelButtonsContainer/SubPanelLabel

@onready var status_effects_instances: Control = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/StatusEffectsInstances
@onready var status_effects_container: VBoxContainer = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/StatusEffectsInstances/StatusEffectsScrollContainer/StatusEffectsContainer
@onready var bonds_instances: Control = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/BondsInstances
@onready var history_instances: Control = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/HistoryInstances

@onready var picture_with_description_panel: Control = $ContentContainer/PanelsContainer/RightPanelContainer/PicureWithDescriptionPanel
@onready var right_panel_picture: TextureRect = $ContentContainer/PanelsContainer/RightPanelContainer/PicureWithDescriptionPanel/RightPanelPicture
@onready var small_description_label: Label = $ContentContainer/PanelsContainer/RightPanelContainer/PicureWithDescriptionPanel/SmallRightPanelBackground/SmallDescriptionContainer/SmallDescriptionLabel
@onready var status_effect_bonus_label: Label = $ContentContainer/PanelsContainer/RightPanelContainer/PicureWithDescriptionPanel/SmallRightPanelBackground/SmallDescriptionContainer/StatusEffectBonusBackground/StatusEffectBonusLabel
@onready var status_effect_bonus_background: ColorRect = $ContentContainer/PanelsContainer/RightPanelContainer/PicureWithDescriptionPanel/SmallRightPanelBackground/SmallDescriptionContainer/StatusEffectBonusBackground
@onready var small_description: Label = $ContentContainer/PanelsContainer/RightPanelContainer/PicureWithDescriptionPanel/SmallRightPanelBackground/SmallDescriptionContainer/SmallDescription

@onready var just_description_panel: Control = $ContentContainer/PanelsContainer/RightPanelContainer/JustDescriptionPanel

var available_characters: Array
var current_character_int: int = 0
var current_character_stats: AllyStats
var stat_labels: Dictionary
var stat_panels: Dictionary
var current_character_sheet_subpanel_button: TextureButton
var current_character_sheet_subpanel_screen: Control

var status_effects_button_active: Button

func refresh():
	available_characters = [Global.current_scene.hero]
	current_character_stats = available_characters[current_character_int].stats
	name_label.text = current_character_stats.character_name
	class_label.text = current_character_stats.character_class
	portrait.texture = current_character_stats.portrait
	level_val.text = str(Global.save_state["level"])
	xp_val.text = str(Global.save_state["experience"]) + "/" + str(Global.save_state["level"] + 7)
	hp_val.text = str(current_character_stats.current_health) + "/" + str(current_character_stats.max_health)
	coins_val.text = str(Global.save_state["coins"])
	supplies_val.text = str(Global.save_state["supplies"])
	
	stat_labels = {
		"strength": strength_val,
		"dexterity": dexterity_val,
		"endurance": endurance_val,
		"processing": processing_val,
		"memory": memory_val,
		"charisma": charisma_val
	}
	
	for stat_name in stat_labels.keys():
		var stat_value = current_character_stats.get(stat_name)
		if stat_value != null:
			stat_labels[stat_name].text = turn_stats_in_strings(stat_value)
		else:
			stat_labels[stat_name].text = "N/A"
	
	stat_panels = {
		"strength": str_panel,
		"dexterity": dex_panel,
		"endurance": end_panel,
		"processing": pro_panel,
		"memory": mem_panel,
		"charisma": cha_panel
	}
	
	for stat_name in stat_labels.keys():
		var stat_value = current_character_stats.get(stat_name)
		if stat_value != null:
			match_stats_colors(stat_panels[stat_name], stat_value)
	
	if true:
		ap_val.visible = true
		ap_label.visible = true
		ap_val.text = str(current_character_stats.slots_and_cores) + "/" + str(Global.save_state["level"] + 1)
	else:
		ap_val.visible = false
		ap_label.visible = false
	
	list_status_effects(current_character_stats)


func match_stats_colors(panel: ColorRect, stat: int):
	panel.color = Color("ffffff33")
	match stat:
		0:
			panel.color = Color("ffffff66")
		1:
			panel.color = Color("ffffff99")
		2:
			panel.color = Color("ffffffcc")
		3:
			panel.color = Color("ffffff")
	
	
func turn_stats_in_strings(stats: int) -> String:
	var result: String
	if stats > 0:
		result = "+" + str(stats)
	else:
		result = str(stats)
	
	return result


func subpanel_node_changed(button_toggled: TextureButton, screen_chosen: Control, subpanel_label_text: String):
	button_pressed.play()
	sub_panel_label.text = subpanel_label_text
	
	if current_character_sheet_subpanel_button == null:
		current_character_sheet_subpanel_button = status_effects_button
		current_character_sheet_subpanel_screen = status_effects_instances
	
	current_character_sheet_subpanel_button.set_pressed(false)
	current_character_sheet_subpanel_screen.visible = false
	current_character_sheet_subpanel_button = button_toggled
	current_character_sheet_subpanel_screen = screen_chosen
	button_toggled.set_pressed(true)
	screen_chosen.visible = true


func list_status_effects(stats: AllyStats):
	var all_status_effects = stats.status_effects
	var n: int = 0
	Global.remove_all_child_nodes(status_effects_container)
	for status in all_status_effects:
		var se_instance =  Button.new()
		se_instance.custom_minimum_size = Vector2(684, 84)
		se_instance.pressed.connect(func(): right_panel_changed(se_instance, status))
		se_instance.text = status.status_name
		se_instance.toggle_mode = true
		status_effects_container.add_child(se_instance)


func right_panel_changed(button_toggled: Button, status: StatusEffect):
	button_pressed.play()
	
	just_description_panel.visible = false
	
	if status_effects_button_active != null:
		status_effects_button_active.set_pressed(false)
	button_toggled.set_pressed(true)
	status_effects_button_active = button_toggled
	show_status_effect(status)
	
	picture_with_description_panel.visible = true


func show_status_effect(status: StatusEffect):
	small_description_label.text = status.status_name
	#Dodać kolorwanie panelu
	status_effect_bonus_label.text = status.bonus_description
	small_description.text = status.description
	right_panel_picture.texture = status.picture


func _on_status_effects_button_pressed() -> void:
	subpanel_node_changed(status_effects_button, status_effects_instances, "cs_subpanel_status_effects")


func _on_bonds_button_pressed() -> void:
	subpanel_node_changed(bonds_button, bonds_instances, "cs_subpanel_bonds")


func _on_history_button_pressed() -> void:
	subpanel_node_changed(history_button, history_instances, "cs_subpanel_history")
