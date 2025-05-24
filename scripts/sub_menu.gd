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

var available_characters: Array
var current_character_int: int = 0
var current_character_stats: AllyStats
var stat_labels: Dictionary
var stat_panels: Dictionary
var current_character_sheet_subpanel_button: TextureButton
var current_character_sheet_subpanel_screen: Control

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


func options_node_changed(button_toggled: TextureButton, screen_chosen: Control):
	button_pressed.play()
	if current_character_sheet_subpanel_button != null:
		current_character_sheet_subpanel_button.set_pressed(false)
		current_character_sheet_subpanel_screen.visible = false
	current_character_sheet_subpanel_button = button_toggled
	current_character_sheet_subpanel_screen = screen_chosen
	button_toggled.set_pressed(true)
	screen_chosen.visible = true
