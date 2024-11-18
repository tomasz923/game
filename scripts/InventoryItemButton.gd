extends Button
class_name InventoryItemButton

signal show_item_info(inventory_item: InventoryItem, is_not_equipped: bool, array_position: int)

var inventory_item: InventoryItem
var is_not_equipped: bool
var array_position: int

func _on_pressed():
	show_item_info.emit(inventory_item, is_not_equipped, array_position)
