extends Control

const INVENTORY_ITEM_BUTTON = preload("res://game/scenes/inventory_item_button.tscn")

@onready var color_rect = $BlackBox/ColorRect
@onready var main_label = $BlackBox/ColorRect/MainLabel
@onready var items_listed = $BlackBox/ItemsContainer/ItemsContainer/ItemsListed

var debug_array: Array = []
var item

func _ready():
	item = load("res://game/inventory_items/maul.tres")
	debug_array.append(item)
	item = load("res://game/inventory_items/warhammer.tres")
	debug_array.append(item)
	print(len(debug_array))
	get_ready()

func get_ready():
	color_rect.custom_minimum_size.x = main_label.size.x + 20
	clear_items()
	for item in debug_array:
		var button_obj: InventoryItemButton = INVENTORY_ITEM_BUTTON.instantiate()
		button_obj.text = item.item_name
		button_obj.item_name = item.item_name
		button_obj.show_item_info.connect(on_show_item_info)
		items_listed.add_child(button_obj)

func clear_items():
	for n in items_listed.get_children():
		items_listed.remove_child(n)
		n.queue_free() 

func on_show_item_info(item_name):
	print(item_name)
