extends Button
class_name InventoryItemButton

signal show_item_info(quest_name: String)

var item_name: String = 'Null'
var item_description: String = 'Null'
var weight: int = 0
var damage_bonus: int = 0
var puncture: int = 0
var value: int = 999
var can_be_sold: bool = true

func _on_pressed():
	show_item_info.emit(item_name)
