extends Control

@onready var health_label = $BlackBox/Stats/StatsContainer/VitalsContainer/HealthContainer/HealthLabel
@onready var health_bar = $BlackBox/Stats/StatsContainer/VitalsContainer/HealthContainer/Bar/Numbers/HealthBar
@onready var current_health_label = $BlackBox/Stats/StatsContainer/VitalsContainer/HealthContainer/Bar/Numbers/HealthBar/HealthNumbersContainer/CurrentHealthLabel
@onready var max_health_label = $BlackBox/Stats/StatsContainer/VitalsContainer/HealthContainer/Bar/Numbers/HealthBar/HealthNumbersContainer/MaxHealthLabel

@onready var special_slot_label = $BlackBox/Stats/StatsContainer/VitalsContainer/SpecialSlotsContainer/SpecialSlotLabel
@onready var special_slots_bar = $BlackBox/Stats/StatsContainer/VitalsContainer/SpecialSlotsContainer/Bar/Numbers/SpecialSlotsBar
@onready var current_special_slots_label = $BlackBox/Stats/StatsContainer/VitalsContainer/SpecialSlotsContainer/Bar/Numbers/SpecialSlotsBar/HBoxContainer/CurrentSpecialSlotsLabel
@onready var max_special_slots_label = $BlackBox/Stats/StatsContainer/VitalsContainer/SpecialSlotsContainer/Bar/Numbers/SpecialSlotsBar/HBoxContainer/MaxSpecialSlotsLabel

@onready var xp_label = $BlackBox/Stats/StatsContainer/VitalsContainer/XPContainer/XPLabel
@onready var xp_bar = $BlackBox/Stats/StatsContainer/VitalsContainer/XPContainer/Bar/Numbers/XPBar
@onready var current_xp_label = $BlackBox/Stats/StatsContainer/VitalsContainer/XPContainer/Bar/Numbers/XPBar/XPNumbersContainer/CurrentXPLabel
@onready var max_xp_label = $BlackBox/Stats/StatsContainer/VitalsContainer/XPContainer/Bar/Numbers/XPBar/XPNumbersContainer/MaxXPLabel

@onready var class_label = $BlackBox/Stats/StatsContainer/VitalsContainer/ClassContainer/ClassLabel
@onready var level_label = $BlackBox/Stats/StatsContainer/VitalsContainer/LevelContainer/LevelLabel
@onready var main_label = $MainLabelContainer/ColorRect/MainLabel
@onready var color_rect = $MainLabelContainer/ColorRect
@onready var damage_label = $BlackBox/Stats/StatsContainer/VitalsContainer/DamageContainer/DamageLabel

#Buttons
@onready var hero_button = $BlackBox/CharacterBar/CharacterButtonsContainer/HeroButton
@onready var character_button_1 = $BlackBox/CharacterBar/CharacterButtonsContainer/CharacterButton1
@onready var character_button_2 = $BlackBox/CharacterBar/CharacterButtonsContainer/CharacterButton2
@onready var character_button_3 = $BlackBox/CharacterBar/CharacterButtonsContainer/CharacterButton3

#Values
@onready var character_damage_label = $BlackBox/Stats/StatsContainer/VitalsContainer/DamageContainer/CharacterDamageLabel
@onready var character_class_label = $BlackBox/Stats/StatsContainer/VitalsContainer/ClassContainer/CharacterClassLabel
@onready var strength_bonus = $BlackBox/Stats/StatsContainer/AbilitiesContainer/FirstRow/Strength/StrengthBonus
@onready var dexterity_bonus = $BlackBox/Stats/StatsContainer/AbilitiesContainer/FirstRow/Dexterity/DexterityBonus
@onready var endurance_bonus = $BlackBox/Stats/StatsContainer/AbilitiesContainer/FirstRow/Constitution/ConstitutionBonus
@onready var processing_bonus = $BlackBox/Stats/StatsContainer/AbilitiesContainer/SecondRow/Processing/ProcessingBonus
@onready var memory_bonus = $BlackBox/Stats/StatsContainer/AbilitiesContainer/SecondRow/Memory/MemoryBonus
@onready var charisma_bonus = $BlackBox/Stats/StatsContainer/AbilitiesContainer/SecondRow/Charisma/CharismaBonus


var current_teammate = null

func get_ready():
	if current_teammate == null:
		current_teammate = Global.hero_character
	crop_progress_bar()
	set_character_names()
	populate_character_sheet_data()
	color_rect.custom_minimum_size.x = main_label.size.x + 20

func crop_progress_bar():
	var labels_size: int = max(damage_label.size.x, class_label.size.x, health_label.size.x, special_slot_label.size.x, level_label.size.x, xp_label.size.x)
	for label in [damage_label, class_label, health_label, special_slot_label, level_label, xp_label]:
		label.custom_minimum_size.x = labels_size
	health_bar.custom_minimum_size.x = 485 - labels_size
	special_slots_bar.custom_minimum_size.x = 485 - labels_size
	xp_bar.custom_minimum_size.x = 485 - labels_size

func populate_bonds():
	pass

func _on_hero_button_pressed():
	if current_teammate != Global.hero_character:
		character_button_1.button_pressed = false
		character_button_2.button_pressed = false
		character_button_3.button_pressed = false
		current_teammate = Global.hero_character
		populate_character_sheet_data()
	else:
		hero_button.button_pressed = true


func _on_character_button_1_pressed():
	if current_teammate != Global.first_character:
		hero_button.button_pressed = false
		character_button_2.button_pressed = false
		character_button_3.button_pressed = false
		current_teammate = Global.first_character
		populate_character_sheet_data()
	else:
		character_button_1.button_pressed = true

func _on_character_button_2_pressed():
	if current_teammate != Global.second_character:
		hero_button.button_pressed = false
		character_button_1.button_pressed = false
		character_button_3.button_pressed = false
		current_teammate = Global.second_character
		populate_character_sheet_data()
	else:
		character_button_2.button_pressed = true


func _on_character_button_3_pressed():
	if current_teammate != Global.third_character:
		hero_button.button_pressed = false
		character_button_1.button_pressed = false
		character_button_2.button_pressed = false
		current_teammate = Global.third_character
		populate_character_sheet_data()
	else:
		character_button_3.button_pressed = true
	
func set_character_names():
	character_button_1.text = Global.first_character.follower_name
	character_button_2.text = Global.second_character.follower_name
	character_button_3.text = Global.third_character.follower_name
	
func populate_character_sheet_data():
	character_damage_label.text = "1d" + str(current_teammate.basic_damage)
	match current_teammate.character_class:
		Global.CharacterClass.PROTECTOR:
			character_class_label.text  = "cs_class_protector"
		Global.CharacterClass.PREACHER:
			character_class_label.text  = "cs_class_preacher"
		Global.CharacterClass.HACKER:
			character_class_label.text  = "cs_class_hacker"
		Global.CharacterClass.OPERATIVE:
			character_class_label.text  = "cs_class_operative"
		Global.CharacterClass.MILITANT:
			character_class_label.text  = "cs_class_militant"
		Global.CharacterClass.SCOUT:
			character_class_label.text  = "cs_class_scout"
		Global.CharacterClass.NONE:
			character_class_label.text  = "cs_class_none"
	
	strength_bonus.text = str(current_teammate.strength)
	dexterity_bonus.text = str(current_teammate.dexterity)
	endurance_bonus.text = str(current_teammate.endurance)
	processing_bonus.text = str(current_teammate.processing)
	memory_bonus.text = str(current_teammate.memory)
	charisma_bonus.text = str(current_teammate.charisma)

	current_health_label.text = str(current_teammate.current_health)
	health_bar.value = current_teammate.current_health
			
	health_bar.value = current_teammate.current_health
	max_health_label.text = str(current_teammate.max_health)
	health_bar.max_value = current_teammate.max_health
