extends Resource
class_name InventoryItem

enum ItemType {
	Weapon_1H, #0
	Weapon_2H, #1
	Bow, #2
	Shield, #3
	Protection, #4
	Other #5
}

@export var item_name: String = 'missing_name' 
@export var item_description: String = 'missing_description' 
@export var type: ItemType = 5
@export_range(1, 3) var weight: int
@export var damage_bonus: int = 0
@export var puncture: int = 0
@export var value: int = 0
@export var can_be_sold: bool = true
@export var model_scene: Resource
