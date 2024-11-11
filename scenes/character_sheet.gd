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

func get_ready():
	crop_progress_bar()
	color_rect.custom_minimum_size.x = main_label.size.x + 20
	

func crop_progress_bar():
	var labels_size: int = max(class_label.size.x, health_label.size.x, special_slot_label.size.x, level_label.size.x, xp_label.size.x)
	print('DEBUG: Max label size is: ', labels_size)
	for label in [class_label, health_label, special_slot_label, level_label, xp_label]:
		label.custom_minimum_size.x = labels_size
	health_bar.custom_minimum_size.x = 485 - labels_size
	special_slots_bar.custom_minimum_size.x = 485 - labels_size
	xp_bar.custom_minimum_size.x = 485 - labels_size

func populate_bonds():
	pass
