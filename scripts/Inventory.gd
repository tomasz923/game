extends Control

const INVENTORY_ITEM_BUTTON = preload("res://game/scenes/inventory_item_button.tscn")

@onready var color_rect = $BlackBox/ColorRect
@onready var main_label = $BlackBox/ColorRect/MainLabel
@onready var items_listed = $BlackBox/ItemsContainer/ItemsListed
@onready var description = $BlackBox/Description

#Labels And Values
@onready var item_name_label = $BlackBox/Description/ItemNameLabel
@onready var extra_description = $BlackBox/Description/ExtraDescription
@onready var first_label = $BlackBox/Description/DescriptionContainer/ActualDescriptionContainer/HBoxContainer/LabelsContainer/FirstLabel
@onready var second_label = $BlackBox/Description/DescriptionContainer/ActualDescriptionContainer/HBoxContainer/LabelsContainer/SecondLabel
@onready var third_label = $BlackBox/Description/DescriptionContainer/ActualDescriptionContainer/HBoxContainer/LabelsContainer/ThirdLabel
@onready var fourth_label = $BlackBox/Description/DescriptionContainer/ActualDescriptionContainer/HBoxContainer/LabelsContainer/FourthLabel
@onready var first_value = $BlackBox/Description/DescriptionContainer/ActualDescriptionContainer/HBoxContainer/ValuesContainer/FirstValue
@onready var second_value = $BlackBox/Description/DescriptionContainer/ActualDescriptionContainer/HBoxContainer/ValuesContainer/SecondValue
@onready var third_value = $BlackBox/Description/DescriptionContainer/ActualDescriptionContainer/HBoxContainer/ValuesContainer/ThirdValue
@onready var fourth_value = $BlackBox/Description/DescriptionContainer/ActualDescriptionContainer/HBoxContainer/ValuesContainer/FourthValue
@onready var warning = $BlackBox/Description/Warning
@onready var equip_button = $BlackBox/Description/Buttons/InteractionButtonsContainer/EquipButton

#Character Buttons
@onready var hero_button = $BlackBox/CharacterBar/CharacterButtonsContainer/HeroButton
@onready var character_button_1 = $BlackBox/CharacterBar/CharacterButtonsContainer/CharacterButton1
@onready var character_button_2 = $BlackBox/CharacterBar/CharacterButtonsContainer/CharacterButton2
@onready var character_button_3 = $BlackBox/CharacterBar/CharacterButtonsContainer/CharacterButton3

var debug_array: Array = []
var item: InventoryItem
var current_teammate = null

var current_item: InventoryItem
var current_item_is_in_inventory: bool
var current_item_position: int

func _ready():
	item = load("res://game/inventory_items/maul.tres")
	debug_array.append(item)
	debug_array.append(item)

func get_ready():
	if current_teammate == null:
		current_teammate = Global.hero_character
	color_rect.custom_minimum_size.x = main_label.size.x + 20
	clear_items()
	set_character_names()
	description.visible = false
	
	var equppied_items_num: int = 0
	var equppied_items: Array = [current_teammate.melee, current_teammate.ranged, current_teammate.shield, current_teammate.protection]
	for array_item in equppied_items:
		if array_item != null:
			var button_obj: InventoryItemButton = INVENTORY_ITEM_BUTTON.instantiate()
			button_obj.text = array_item.item_name
			button_obj.inventory_item = array_item
			button_obj.array_position = equppied_items_num
			button_obj.is_not_equipped = false
			button_obj.show_item_info.connect(on_show_item_info)
			items_listed.add_child(button_obj)
			equppied_items_num += 1
	
	var debug_array_num: int = 0
	for array_item in debug_array:
		var button_obj: InventoryItemButton = INVENTORY_ITEM_BUTTON.instantiate()
		button_obj.text = array_item.item_name
		button_obj.inventory_item = array_item
		button_obj.array_position = debug_array_num
		button_obj.is_not_equipped = true
		button_obj.show_item_info.connect(on_show_item_info)
		items_listed.add_child(button_obj)
		debug_array_num += 1

func set_character_names():
	character_button_1.text = Global.first_character.follower_name
	character_button_2.text = Global.second_character.follower_name
	character_button_3.text = Global.third_character.follower_name

func clear_items():
	for n in items_listed.get_children():
		items_listed.remove_child(n)
		n.queue_free() 

func generate_perks_list(_label: Label, _perks_item: InventoryItem):
	pass

func on_show_item_info(inventory_item: InventoryItem, is_not_equipped: bool, array_position: int):
	description.visible = true
	current_item = inventory_item
	current_item_is_in_inventory = is_not_equipped
	current_item_position = array_position
	item_name_label.text = inventory_item.item_name
	extra_description.text = inventory_item.item_description
	
	if is_not_equipped:
		equip_button.visible = true
	else:
		equip_button.visible = false
	
	match inventory_item.type:
		0:
			first_label.visible = true
			first_value.visible = true
			first_label.text = "inv_extra_damage_label"
			first_value.text = str(inventory_item.damage_bonus)
			
			if !inventory_item.ignores_protection:
				second_label.visible = true
				second_value.visible = true
				second_label.text = "inv_piercing_label"
				if inventory_item.piercing > 0:
					second_value.text = "+" + str(inventory_item.piercing)
				else:
					second_value.text = "0"
			else:
				second_label.visible = false
				second_value.visible = false
			
			third_label.visible = true
			third_value.visible = true
			third_label.text = "inv_other_label"
			generate_perks_list(third_value, inventory_item)
			
			fourth_label.visible = false
			fourth_value.visible = false
		1:
			first_label.visible = true
			first_value.visible = true
			first_label.text = "inv_extra_damage_label"
			first_value.text = str(inventory_item.damage_bonus)
			
			if !inventory_item.ignores_protection:
				second_label.visible = true
				second_value.visible = true
				second_label.text = "inv_piercing_label"
				if inventory_item.piercing > 0:
					second_value.text = "+" + str(inventory_item.piercing)
				else:
					second_value.text = "0"
			else:
				second_label.visible = false
				second_value.visible = false
			
			third_label.visible = true
			third_value.visible = true
			third_label.text = "inv_other_label"
			generate_perks_list(third_value, inventory_item)
			
			fourth_label.visible = false
			fourth_value.visible = false
		2:
			first_label.visible = true
			first_value.visible = true
			first_label.text = "inv_extra_damage_label"
			first_value.text = str(inventory_item.damage_bonus)
			
			if !inventory_item.ignores_protection:
				second_label.visible = true
				second_value.visible = true
				second_label.text = "inv_piercing_label"
				if inventory_item.piercing > 0:
					second_value.text = "+" + str(inventory_item.piercing)
				else:
					second_value.text = "0"
			else:
				second_label.visible = false
				second_value.visible = false
			
			third_label.visible = true
			third_value.visible = true
			third_label.text = "inv_ammo_label"
			third_value.text = str(inventory_item.ammo)
			
			fourth_label.visible = true
			fourth_value.visible = true
			fourth_label.text = "inv_other_label"
			generate_perks_list(fourth_value, inventory_item)
		3:
			first_label.visible = true
			first_value.visible = true
			first_label.text = "inv_protection_label"
			first_value.text = str(inventory_item.damage_bonus)
			
			second_label.visible = false
			second_value.visible = false
			
			third_label.visible = false
			third_value.visible = false
			
			fourth_label.visible = false
			fourth_value.visible = false
		4:
			first_label.visible = true
			first_value.visible = true
			first_label.text = "inv_protection_label"
			first_value.text = str(inventory_item.damage_bonus)
			
			second_label.visible = false
			second_value.visible = false
			
			third_label.visible = false
			third_value.visible = false
			
			fourth_label.visible = false
			fourth_value.visible = false
		5:
			first_label.visible = false
			first_value.visible = false
			
			second_label.visible = false
			second_value.visible = false
			
			third_label.visible = false
			third_value.visible = false
			
			fourth_label.visible = false
			fourth_value.visible = false

func _on_equip_button_pressed():
	var removed_melee
	var removed_ranged
	var removed_shield
	var removed_protection
	match current_item.type:
		0:
			if current_teammate.melee != null:
				removed_melee = current_teammate.melee
				
			current_teammate.melee = debug_array.pop_at(current_item_position)

			if removed_melee != null:
				debug_array.append(removed_melee)
		1:
			if current_teammate.melee != null:
				removed_melee = current_teammate.melee
			if current_teammate.ranged != null:
				removed_ranged = current_teammate.ranged
				current_teammate.ranged = null
			
			current_teammate.melee = debug_array.pop_at(current_item_position)
			
			if removed_melee != null:
				debug_array.append(removed_melee)
			if removed_ranged != null:
				debug_array.append(removed_ranged)
				
	current_teammate.change_equipment()
	get_ready()

func _on_hero_button_pressed():
	if current_teammate != Global.hero_character:
		character_button_1.button_pressed = false
		character_button_2.button_pressed = false
		character_button_3.button_pressed = false
		current_teammate = Global.hero_character
		get_ready()
	else:
		hero_button.button_pressed = true

func _on_character_button_1_pressed():
	if current_teammate != Global.first_character:
		hero_button.button_pressed = false
		character_button_2.button_pressed = false
		character_button_3.button_pressed = false
		current_teammate = Global.first_character
		get_ready()
	else:
		character_button_1.button_pressed = true

func _on_character_button_2_pressed():
	if current_teammate != Global.second_character:
		hero_button.button_pressed = false
		character_button_1.button_pressed = false
		character_button_3.button_pressed = false
		current_teammate = Global.second_character
		get_ready()
	else:
		character_button_2.button_pressed = true

func _on_character_button_3_pressed():
	if current_teammate != Global.third_character:
		hero_button.button_pressed = false
		character_button_1.button_pressed = false
		character_button_2.button_pressed = false
		current_teammate = Global.third_character
		get_ready()
	else:
		character_button_3.button_pressed = true
