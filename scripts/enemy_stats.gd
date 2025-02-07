extends Resource
class_name EnemyStats

enum EnemyType {
	DECOY
}

@export_category("General")
@export var enemy_class: EnemyType = EnemyType.DECOY
@export var max_health: int
@export var curent_health: int
@export var enemy_name: String
@export_range(4, 20, 2) var basic_damage: int = 4

@export_category("Items")
@export var melee: InventoryItem
@export var ranged: InventoryItem
@export var shield: InventoryItem
@export var spray: InventoryItem
