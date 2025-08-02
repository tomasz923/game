extends InventoryItem
class_name Weapon

enum ItemType {
	WEAPON_1H, 
	WEAPON_2H,
	BOW
}

@export var weapon_type: ItemType
@export var damage_bonus: int = 0
@export var piercing: bool = false
