extends Resource
class_name InventoryItem

enum ItemType {
	WEAPON_1H, #0
	WEAPON_2H, #1
	BOW, #2
	SHIELD, #3
	PROTECTION, #4
	OTHER #5
}


@export_category("Item Deatils")
@export var item_name: String = 'missing_name' 
@export var item_description: String = 'missing_description' 
@export var type: ItemType = ItemType.OTHER 
@export_range(1, 3) var weight: int
@export var damage_bonus: int = 0
@export var piercing: int = 0
@export var ammo: int = 0
@export var value: int = 0
@export var can_be_sold: bool = true
@export var model_scene: Resource

@export_category("Item Perks")
@export var forceful: bool
@export var ignores_protection: bool
@export var messy: bool
@export var precise: bool
@export var relaod: bool
@export var stun: bool
