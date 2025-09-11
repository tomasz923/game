extends Control

const CHARACTER_SHEET = "CharacterSheetButton"
const INVENTORY = "InventoryButton"
const MOVES = "MovesButton"
const JOURNAL = "JournalButton"
const MIDDLE_PANEL_INSTANCE = preload("res://game/scenes/middle_panel_instance.tscn")
const GREEN: Color = Color("#55927f") 
const RED: Color = Color("#dc6250")

@onready var button_pressed: AudioStreamPlayer = $ButtonPressed
@onready var character_sheet_button: Button = $BlackRectangle/MenuContainer/CharacterSheetButton
@onready var inventory_button: Button = $BlackRectangle/MenuContainer/InventoryButton
@onready var moves_button: Button = $BlackRectangle/MenuContainer/MovesButton
@onready var journal_button: Button = $BlackRectangle/MenuContainer/JournalButton

@onready var portrait: TextureRect = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/FirstLayer/Portrait
@onready var name_label: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/FirstLayer/InfoBox/HBoxContainer/NameLabel
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

@onready var status_effects_button: TextureButton = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/CharacterSheetPanelButtonsContainer/SubButtons/StatusEffectsButton
@onready var bonds_button: TextureButton = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/CharacterSheetPanelButtonsContainer/SubButtons/BondsButton
@onready var history_button: TextureButton = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/CharacterSheetPanelButtonsContainer/SubButtons/HistoryButton
@onready var character_sheet_subpanel_label: Label = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/CharacterSheetPanelButtonsContainer/CharacterSheetSubpanelLabel

@onready var melee_button: TextureButton = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/InventoryPanelButtonsContainer/SubButtons/MeleeButton
@onready var ranged_button: TextureButton = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/InventoryPanelButtonsContainer/SubButtons/RangedButton
@onready var armor_button: TextureButton = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/InventoryPanelButtonsContainer/SubButtons/ArmorButton
@onready var consumables_button: TextureButton = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/InventoryPanelButtonsContainer/SubButtons/ConsumablesButton
@onready var others_button: TextureButton = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/InventoryPanelButtonsContainer/SubButtons/OthersButton
@onready var inventory_sub_panel_label: Label = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/InventoryPanelButtonsContainer/InventorySubPanelLabel

@onready var basic_moves_button: TextureButton = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/MovesPanelButtonsContainer/SubButtons/BasicMovesButton
@onready var starting_moves_button: TextureButton = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/MovesPanelButtonsContainer/SubButtons/StartingMovesButton
@onready var advanced_1_button: TextureButton = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/MovesPanelButtonsContainer/SubButtons/Advanced1Button
@onready var advanced_2_button: TextureButton = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/MovesPanelButtonsContainer/SubButtons/Advanced2Button
@onready var moves_sub_panel_label: Label = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/MovesPanelButtonsContainer/MovesSubPanelLabel

@onready var active_quests_button: TextureButton = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/JournalButtonsContainer/JournalSubButtons/ActiveQuestsButton
@onready var general_info_button: TextureButton = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/JournalButtonsContainer/JournalSubButtons/GeneralInfoButton
@onready var done_quests_button: TextureButton = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/JournalButtonsContainer/JournalSubButtons/DoneQuestsButton
@onready var journal_sub_panel_label: Label = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/JournalButtonsContainer/JournalSubPanelLabel

# Subpanel buttons:
@onready var character_sheet_panel_buttons_container: VBoxContainer = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/CharacterSheetPanelButtonsContainer
@onready var inventory_panel_buttons_container: VBoxContainer = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/InventoryPanelButtonsContainer
@onready var moves_panel_buttons_container: VBoxContainer = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/MovesPanelButtonsContainer
@onready var journal_buttons_container: VBoxContainer = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/SubPanel/JournalButtonsContainer


# Right panels
@onready var character_sheet_right_panel: Control = $ContentContainer/PanelsContainer/RightPanelContainer/CharacterSheetRightPanel
@onready var character_sheet_right_panel_picture: TextureRect = $ContentContainer/PanelsContainer/RightPanelContainer/CharacterSheetRightPanel/CharacterSheetRightPanelPicture
@onready var character_sheet_right_panel_vbox: VBoxContainer = $ContentContainer/PanelsContainer/RightPanelContainer/CharacterSheetRightPanel/SmallRightPanelBackground/CharacterSheetRightPanelVbox
@onready var character_sheet_right_panel_label: Label = $ContentContainer/PanelsContainer/RightPanelContainer/CharacterSheetRightPanel/SmallRightPanelBackground/CharacterSheetRightPanelVbox/CharacterSheetRightPanelLabel
@onready var character_sheet_right_panel_colored_strip: ColorRect = $ContentContainer/PanelsContainer/RightPanelContainer/CharacterSheetRightPanel/SmallRightPanelBackground/CharacterSheetRightPanelVbox/CharacterSheetRightPanelColoredStrip
@onready var character_sheet_right_panel_colored_strip_label: Label = $ContentContainer/PanelsContainer/RightPanelContainer/CharacterSheetRightPanel/SmallRightPanelBackground/CharacterSheetRightPanelVbox/CharacterSheetRightPanelColoredStrip/CharacterSheetRightPanelColoredStripLabel
@onready var character_sheet_right_panel_description: Label = $ContentContainer/PanelsContainer/RightPanelContainer/CharacterSheetRightPanel/SmallRightPanelBackground/CharacterSheetRightPanelVbox/CharacterSheetRightPanelDescription

@onready var inventory_right_panel: Control = $ContentContainer/PanelsContainer/RightPanelContainer/InventoryRightPanel
@onready var inventory_right_panel_picture: TextureRect = $ContentContainer/PanelsContainer/RightPanelContainer/InventoryRightPanel/InventoryRightPanelPicture
@onready var inventory_right_panel_description: Label = $ContentContainer/PanelsContainer/RightPanelContainer/InventoryRightPanel/SmallRightPanelBackground/InventoryRightPanelVbox/InventoryRightPanelDescription
@onready var inventory_right_panel_label: Label = $ContentContainer/PanelsContainer/RightPanelContainer/InventoryRightPanel/SmallRightPanelBackground/InventoryRightPanelVbox/InventoryRightPanelLabel
@onready var inventory_description_left_column_row_1: Label = $ContentContainer/PanelsContainer/RightPanelContainer/InventoryRightPanel/SmallRightPanelBackground/InventoryRightPanelVbox/StatsHBoxContainer/LeftColumnsVBoxContainer/InventoryDescriptionLeftColumnRow1
@onready var inventory_description_left_column_row_2: Label = $ContentContainer/PanelsContainer/RightPanelContainer/InventoryRightPanel/SmallRightPanelBackground/InventoryRightPanelVbox/StatsHBoxContainer/LeftColumnsVBoxContainer/InventoryDescriptionLeftColumnRow2
@onready var inventory_description_left_column_row_3: Label = $ContentContainer/PanelsContainer/RightPanelContainer/InventoryRightPanel/SmallRightPanelBackground/InventoryRightPanelVbox/StatsHBoxContainer/LeftColumnsVBoxContainer/InventoryDescriptionLeftColumnRow3
@onready var inventory_description_right_column_row_1: Label = $ContentContainer/PanelsContainer/RightPanelContainer/InventoryRightPanel/SmallRightPanelBackground/InventoryRightPanelVbox/StatsHBoxContainer/RightColumnsHBoxContainer/CurrentValVBoxContainer/InventoryDescriptionRightColumnRow1
@onready var inventory_description_right_column_row_2: Label = $ContentContainer/PanelsContainer/RightPanelContainer/InventoryRightPanel/SmallRightPanelBackground/InventoryRightPanelVbox/StatsHBoxContainer/RightColumnsHBoxContainer/CurrentValVBoxContainer/InventoryDescriptionRightColumnRow2
@onready var inventory_description_right_column_row_3: Label = $ContentContainer/PanelsContainer/RightPanelContainer/InventoryRightPanel/SmallRightPanelBackground/InventoryRightPanelVbox/StatsHBoxContainer/RightColumnsHBoxContainer/CurrentValVBoxContainer/InventoryDescriptionRightColumnRow3
@onready var inventory_description_right_column_row_5: Label = $ContentContainer/PanelsContainer/RightPanelContainer/InventoryRightPanel/SmallRightPanelBackground/InventoryRightPanelVbox/StatsHBoxContainer/RightColumnsHBoxContainer/CurrentValVBoxContainer/InventoryDescriptionRightColumnRow5

#@onready var small_description_label: Label = $ContentContainer/PanelsContainer/RightPanelContainer/PicureWithDescriptionPanel/SmallRightPanelBackground/SmallDescriptionContainer/SmallDescriptionLabel
#@onready var status_effect_bonus_label: Label = $ContentContainer/PanelsContainer/RightPanelContainer/PicureWithDescriptionPanel/SmallRightPanelBackground/SmallDescriptionContainer/StatusEffectBonusBackground/StatusEffectBonusLabel
#@onready var status_effect_bonus_background: ColorRect = $ContentContainer/PanelsContainer/RightPanelContainer/PicureWithDescriptionPanel/SmallRightPanelBackground/SmallDescriptionContainer/StatusEffectBonusBackground
#@onready var small_description: Label = $ContentContainer/PanelsContainer/RightPanelContainer/PicureWithDescriptionPanel/SmallRightPanelBackground/SmallDescriptionContainer/SmallDescription

#@onready var just_description_panel: Control = $ContentContainer/PanelsContainer/RightPanelContainer/JustDescriptionPanel
@onready var instances_container: VBoxContainer = $ContentContainer/PanelsContainer/MiddlePanelContainer/Container/Instances/InstancesScrollContainer/InstancesContainer

var available_characters: Array
var current_character_stats: AllyStats
var stat_labels: Dictionary 
var stat_panels: Dictionary

var submenu_panel_button_toggled: Button = null
var submenu_panel_buttons_container_toggled: VBoxContainer = null
var subpanel_button_toggled: Dictionary[String, TextureButton] = {
	CHARACTER_SHEET: null,
	INVENTORY: null,
	MOVES: null,
	JOURNAL: null
}
var subpanel_labels: Dictionary[String, String] = {
			"StatusEffectsButton": "cs_subpanel_status_effects",
			"BondsButton": "cs_subpanel_bonds",
			"HistoryButton": "cs_subpanel_history",
			"MeleeButton": "inv_subpanel_melee",
			"RangedButton": "inv_subpanel_ranged",
			"ArmorButton": "inv_subpanel_armor",
			"ConsumablesButton": "inv_subpanel_consumables",
			"OthersButton": "inv_subpanel_others"
		}

#var current_character_sheet_subpanel_button: TextureButton
#var current_character_sheet_subpanel_screen: Control
#
#var status_effects_button_active: Button

func refresh():
	#TODO Zmień zbieranie bohaterów, żeby mogło być ich mniej niż 4
	available_characters = [
		Global.current_scene.hero, 
		Global.current_scene.follower_one,
		Global.current_scene.follower_two,
		Global.current_scene.follower_three
		]
	current_character_stats = available_characters[Global.save_state["current_ui_character_int"]].stats
	name_label.text = current_character_stats.character_name
	class_label.text = current_character_stats.character_class
	portrait.texture = current_character_stats.portrait
	level_val.text = str(Global.save_state["level"])
	xp_val.text = str(Global.save_state["experience"]) + "/" + str(Global.save_state["level"] + 7)
	hp_val.text = str(current_character_stats.current_health) + "/" + str(current_character_stats.max_health)
	coins_val.text = str(Global.save_state["coins"])
	supplies_val.text = str(Global.save_state["supplies"])
	
	stat_labels= {
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
	
	#TODO dodać warunek, że postać ma AP
	if false:
		ap_val.visible = true
		ap_label.visible = true
		ap_val.text = str(current_character_stats.slots_and_cores) + "/" + str(Global.save_state["level"] + 1)
	else:
		ap_val.visible = false
		ap_label.visible = false
	
	if submenu_panel_button_toggled == null:
		# We cannot initiate those subpanel buttons at the beginning since the buttons
		# are being assigned to the variables at the later stage:
		subpanel_button_toggled[CHARACTER_SHEET] = status_effects_button
		subpanel_button_toggled[INVENTORY] = melee_button
		subpanel_button_toggled[MOVES] = basic_moves_button
		subpanel_button_toggled[JOURNAL] = active_quests_button

		
		# All panels should be invisible and toggled off at the start:
		character_sheet_button.emit_signal("pressed")
		#submenu_panel_button_toggled = character_sheet_button
		#submenu_panel_buttons_container_toggled = character_sheet_panel_buttons_container
		#submenu_panel_button_toggled.set_pressed(true)
		#submenu_panel_buttons_container_toggled.visible = true
		#subpanel_button_toggled[INVENTORY].emit_signal("pressed")
	else:
		submenu_panel_button_toggled.emit_signal("pressed")
	
	#list_status_effects(current_character_stats)
	
	# Populating the screen so it is not empty 
	# when opened for the first time.
	#if status_effects_button_active == null:
		#status_effects_button_active = status_effects_container.get_child(0)
		#status_effects_button_active.pressed


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

#func subpanel_node_changed(button_toggled: TextureButton, screen_chosen: Control, subpanel_label_text: String):
	#button_pressed.play()
	#character_sheet_subpanel_label.text = subpanel_label_text
	#
	#if current_character_sheet_subpanel_button == null:
		#current_character_sheet_subpanel_button = status_effects_button
		#current_character_sheet_subpanel_screen = status_effects_instances
	#
	#current_character_sheet_subpanel_button.set_pressed(false)
	#current_character_sheet_subpanel_screen.visible = false
	#current_character_sheet_subpanel_button = button_toggled
	#current_character_sheet_subpanel_screen = screen_chosen
	#button_toggled.set_pressed(true)
	#screen_chosen.visible = true


#func list_status_effects(stats: AllyStats):
	#var all_status_effects = stats.status_effects
	#var n: int = 0
	#Global.remove_all_child_nodes(status_effects_container)
	#for status in all_status_effects:
		#var se_instance =  Button.new()
		#se_instance.custom_minimum_size = Vector2(684, 84)
		#se_instance.pressed.connect(func(): right_panel_se_changed(se_instance, status))
		#se_instance.text = status.status_name
		#se_instance.toggle_mode = true
		#status_effects_container.add_child(se_instance)


#func right_panel_se_changed(button_toggled: Button, status: StatusEffect):
	#button_pressed.play()
	#
	#just_description_panel.visible = false
	#
	#status_effects_button_active.set_pressed(false)
	#status_effects_button_active = button_toggled
	#status_effects_button_active.set_pressed(true)
	#show_status_effect(status)
	#
	#picture_with_description_panel.visible = true


#func show_status_effect(status: StatusEffect):
	#small_description_label.text = status.status_name
	##Dodać kolorwanie panelu
	#status_effect_bonus_label.text = status.bonus_description
	#small_description.text = status.description
	#right_panel_picture.texture = status.picture


func change_submenu_panel(new_button: Button, panel_buttons_container: VBoxContainer, needs_right_panel_with_pic: bool):
	button_pressed.play()
	clear_instances()
	if new_button != submenu_panel_button_toggled:
		if submenu_panel_button_toggled != null:
			submenu_panel_button_toggled.set_pressed_no_signal(false)
			submenu_panel_buttons_container_toggled.visible = false
		submenu_panel_button_toggled = new_button
		submenu_panel_button_toggled.set_pressed_no_signal(true)
		submenu_panel_buttons_container_toggled = panel_buttons_container
		submenu_panel_buttons_container_toggled.visible = true
		# TODO: Change only when window is clciked
		hide_right_panels()
			
	else:
		new_button.set_pressed_no_signal(true)
		

func change_character_sheet_panels(new_button: TextureButton) -> void:
	button_pressed.play()
	hide_right_panels()
	#if new_button != subpanel_button_toggled[CHARACTER_SHEET]:
	if subpanel_button_toggled[CHARACTER_SHEET] != null:
		subpanel_button_toggled[CHARACTER_SHEET].set_pressed_no_signal(false)
	subpanel_button_toggled[CHARACTER_SHEET] = new_button
	subpanel_button_toggled[CHARACTER_SHEET].set_pressed_no_signal(true)
	character_sheet_subpanel_label.text = subpanel_labels[new_button.name]
	clear_instances()


func change_inventory_panels(new_button: TextureButton) -> void:
	button_pressed.play()
	hide_right_panels()
	if subpanel_button_toggled[INVENTORY] != null:
		subpanel_button_toggled[INVENTORY].set_pressed_no_signal(false)
	subpanel_button_toggled[INVENTORY] = new_button
	subpanel_button_toggled[INVENTORY].set_pressed_no_signal(true)
	inventory_sub_panel_label.text = subpanel_labels[new_button.name]
	clear_instances()


func _on_previous_character_button_pressed() -> void:
	button_pressed.play()
	if Global.save_state["current_ui_character_int"] == 0:
		Global.save_state["current_ui_character_int"] = 3
	else:
		Global.save_state["current_ui_character_int"] -= 1
	refresh()


func _on_next_character_button_pressed() -> void:
	button_pressed.play()
	if Global.save_state["current_ui_character_int"] == (len(available_characters) - 1):
		Global.save_state["current_ui_character_int"] = 0
	else:
		Global.save_state["current_ui_character_int"] += 1
	refresh()

func clear_instances():
	for n in instances_container.get_children():
		instances_container.remove_child(n)
		n.queue_free() 
	#TODO Dodaj zmiany w prawym panelu

func hide_right_panels():
	character_sheet_right_panel.visible = false
	inventory_right_panel.visible = false
	
# Changing submenus (probably could have been written better):
func _on_character_sheet_button_pressed() -> void:
	change_submenu_panel(character_sheet_button,character_sheet_panel_buttons_container, true)
	subpanel_button_toggled[CHARACTER_SHEET].emit_signal("pressed")


func _on_inventory_button_pressed() -> void:
	change_submenu_panel(inventory_button, inventory_panel_buttons_container, true)
	subpanel_button_toggled[INVENTORY].emit_signal("pressed")

func _on_moves_button_pressed() -> void:
	change_submenu_panel(moves_button, moves_panel_buttons_container, false)


func _on_journal_button_pressed() -> void:
	change_submenu_panel(journal_button, journal_buttons_container, false)


# Character Sheet Buttons ------------------------------------------------------
func _on_status_effects_button_pressed() -> void:
	change_character_sheet_panels(status_effects_button)
	if len(current_character_stats.status_effects) == 0:
		var new_instance = MIDDLE_PANEL_INSTANCE.instantiate()
		new_instance.disabled = true
		new_instance.text = "cs_no_status_effects_found"
		instances_container.add_child(new_instance)
	else:
		for status in current_character_stats.status_effects:
			var new_instance = MIDDLE_PANEL_INSTANCE.instantiate()
			new_instance.has_resources = true
			new_instance.nested_resource = status
			new_instance.text = status.status_name
			new_instance.instance_was_highlighted.connect(_on_status_effect_was_highlighted)
			instances_container.add_child(new_instance)


func _on_status_effect_was_highlighted(resource: StatusEffect):
	character_sheet_right_panel_picture.texture = resource.picture
	character_sheet_right_panel_colored_strip_label.text = resource.bonus_description
	character_sheet_right_panel_label.text = resource.status_name
	character_sheet_right_panel_description.text = resource.description
	if resource.bonus > 0:
		character_sheet_right_panel_colored_strip.color = GREEN 
	else:
		character_sheet_right_panel_colored_strip.color = RED
	character_sheet_right_panel.visible = true
	

func _on_bonds_button_pressed() -> void:
	change_character_sheet_panels(bonds_button)
	if len(current_character_stats.bonds) == 0:
		var new_instance = MIDDLE_PANEL_INSTANCE.instantiate()
		new_instance.disabled = true
		new_instance.text = "cs_no_bonds_found"
		instances_container.add_child(new_instance)
	else:
		for status in current_character_stats.bonds:
			var new_instance = MIDDLE_PANEL_INSTANCE.instantiate()
			new_instance.has_resources = true
			new_instance.nested_resource = status
			new_instance.text = status.status_name
			new_instance.instance_was_highlighted.connect(_on_status_effect_was_highlighted)
			instances_container.add_child(new_instance)


#func _on_history_button_pressed() -> void:
	#change_character_sheet_panels(history_button)

# Character Sheet Buttons ------------------------------------------------------
func _on_melee_button_pressed() -> void:
	change_inventory_panels(melee_button)
	if current_character_stats.melee_weapon:
		var new_instance = MIDDLE_PANEL_INSTANCE.instantiate()
		new_instance.has_resources = true
		new_instance.unmark_item_as_equipped()
		new_instance.nested_resource = current_character_stats.melee_weapon
		new_instance.text = current_character_stats.melee_weapon.item_name
		new_instance.instance_was_highlighted.connect(_on_weapon_was_highlighted)
		new_instance.instance_was_pressed.connect(_on_weapon_was_chosen)
		new_instance.mark_item_as_equipped()
		instances_container.add_child(new_instance)
	if Global.inventory[Global.InventoryCategory.MELEE]:
		for weapon in Global.inventory[Global.InventoryCategory.MELEE]:
			var number_str = ""
			var amount = Global.inventory[Global.InventoryCategory.MELEE][weapon]
			var new_instance = MIDDLE_PANEL_INSTANCE.instantiate()
			if amount > 1:
				number_str = "(" + str(amount) + ")"
			new_instance.has_resources = true
			new_instance.nested_resource = weapon
			new_instance.text = weapon.item_name + number_str
			new_instance.instance_was_highlighted.connect(_on_weapon_was_highlighted)
			new_instance.instance_was_pressed.connect(_on_weapon_was_chosen)
			instances_container.add_child(new_instance)


func _on_weapon_was_highlighted(resource: Weapon):
	inventory_right_panel_picture.texture = resource.item_picture
	inventory_right_panel_label.text = resource.item_name
	inventory_right_panel_description.text = resource.item_description
	
	inventory_description_left_column_row_1.text = "inv_weapon_type"
	if resource.weapon_type == Weapon.ItemType.WEAPON_2H:
		inventory_description_right_column_row_1.text = "inv_two_handed_weapon"
	else:
		inventory_description_right_column_row_1.text = "inv_one_handed_weapon"
	
	inventory_description_left_column_row_2.text = "inv_weapon_damage_type"
	if resource.piercing:
		inventory_description_right_column_row_2.text = "inv_weapon_piercing_bonus"
	else:
		inventory_description_right_column_row_2.text = "inv_weapon_blunt_damage"
	
	inventory_description_left_column_row_3.text = "inv_weapon_damage_bonus"
	if resource.damage_bonus > 0:
		inventory_description_right_column_row_3.text = "+" + str(resource.damage_bonus)
	else:
		inventory_description_right_column_row_3.text = "0"
	
	inventory_description_right_column_row_5.text = str(resource.value)
	inventory_right_panel.visible = true

func _on_weapon_was_chosen(resource: Weapon, marked: bool):
	if not marked:
		var equipped_weapon = current_character_stats.melee_weapon.duplicate()
		Global.remove_item(resource)
		Global.add_item(equipped_weapon)
		current_character_stats.melee_weapon = resource
		available_characters[Global.save_state["current_ui_character_int"]].change_equipment(current_character_stats)
	subpanel_button_toggled[INVENTORY].emit_signal("pressed")

func _on_armor_button_pressed() -> void:
	change_inventory_panels(armor_button)
	var no_items_found:bool = true
	if current_character_stats.shield:
		var new_instance = MIDDLE_PANEL_INSTANCE.instantiate()
		no_items_found = false
		new_instance.has_resources = true
		new_instance.nested_resource = current_character_stats.shield
		new_instance.text = current_character_stats.shield.item_name
		new_instance.instance_was_highlighted.connect(_on_protection_was_highlighted)
		new_instance.instance_was_pressed.connect(_on_protection_was_chosen)
		new_instance.mark_item_as_equipped()
		instances_container.add_child(new_instance)
	if current_character_stats.defence:
		var new_instance = MIDDLE_PANEL_INSTANCE.instantiate()
		no_items_found = false
		new_instance.has_resources = true
		new_instance.nested_resource = current_character_stats.defence
		new_instance.text = current_character_stats.defence.item_name
		new_instance.instance_was_highlighted.connect(_on_protection_was_highlighted)
		new_instance.instance_was_pressed.connect(_on_protection_was_chosen)
		new_instance.mark_item_as_equipped()
		instances_container.add_child(new_instance)
	if Global.inventory[Global.InventoryCategory.PROTECTION]:
		for protection in Global.inventory[Global.InventoryCategory.PROTECTION]:
			var number_str = ""
			var amount = Global.inventory[Global.InventoryCategory.PROTECTION][protection]
			var new_instance = MIDDLE_PANEL_INSTANCE.instantiate()
			no_items_found = false
			if amount > 1:
				number_str = "(" + str(amount) + ")"
			new_instance.has_resources = true
			new_instance.nested_resource = protection
			new_instance.text = protection.item_name + number_str
			new_instance.instance_was_highlighted.connect(_on_protection_was_highlighted)
			new_instance.instance_was_pressed.connect(_on_protection_was_chosen)
			instances_container.add_child(new_instance)
		print("Items found")
	if no_items_found:
		var new_instance = MIDDLE_PANEL_INSTANCE.instantiate()
		new_instance.disabled = true
		new_instance.text = "inv_no_items_found"
		instances_container.add_child(new_instance)
		print("No items found")
		print(Global.inventory[Global.InventoryCategory.PROTECTION])
		print("---")


func _on_protection_was_highlighted(resource: InventoryItem):
	inventory_right_panel_picture.texture = resource.item_picture
	inventory_right_panel_label.text = resource.item_name
	inventory_right_panel_description.text = resource.item_description
	
	inventory_description_left_column_row_1.text = "inv_protection_type"
	if resource is Shield:
		inventory_description_right_column_row_1.text = "inv_protection_shield"
	else:
		inventory_description_right_column_row_1.text = "inv_protection_field"
	
	inventory_description_left_column_row_2.text = "inv_protection_label"
	inventory_description_right_column_row_2.text = "+" + str(resource.protection)
	
	inventory_description_left_column_row_3.text = ""
	inventory_description_right_column_row_3.text = ""
	
	inventory_description_right_column_row_5.text = str(resource.value)
	inventory_right_panel.visible = true


func _on_protection_was_chosen(resource: InventoryItem, marked: bool):
	if resource is Shield:
		var equipped_shield = current_character_stats.shield.duplicate()
		if not marked:
			Global.remove_item(resource)
			Global.add_item(equipped_shield)
			current_character_stats.shield = resource
		else:
			Global.add_item(equipped_shield)
			current_character_stats.shield = null
	if resource is Defence:
		var equipped_defence= current_character_stats.defence.duplicate()
		if not marked:
			Global.remove_item(resource)
			Global.add_item(equipped_defence)
			current_character_stats.defence = resource
		else:
			Global.add_item(equipped_defence)
			current_character_stats.defence = null
	subpanel_button_toggled[INVENTORY].emit_signal("pressed")


func _on_ranged_button_pressed() -> void:
	change_inventory_panels(ranged_button)
	var no_items_found = true
	if no_items_found:
		var new_instance = MIDDLE_PANEL_INSTANCE.instantiate()
		new_instance.disabled = true
		new_instance.text = "inv_no_items_found"
		instances_container.add_child(new_instance)


func _on_consumables_button_pressed() -> void:
	change_inventory_panels(consumables_button)
	var no_items_found = true
	if no_items_found:
		var new_instance = MIDDLE_PANEL_INSTANCE.instantiate()
		new_instance.disabled = true
		new_instance.text = "inv_no_items_found"
		instances_container.add_child(new_instance)


func _on_others_button_pressed() -> void:
	change_inventory_panels(others_button)
	var no_items_found = true
	if no_items_found:
		var new_instance = MIDDLE_PANEL_INSTANCE.instantiate()
		new_instance.disabled = true
		new_instance.text = "inv_no_items_found"
		instances_container.add_child(new_instance)
