extends Resource
class_name EnemyStats

@export_category("General")
@export var enemy_class: Global.EnemyType
@export var max_health: int
@export var enemy_name: String
@export_range(4, 20, 2) var basic_damage: int = 4

@export_category("Items")
@export var melee: InventoryItem
@export var ranged: InventoryItem
@export var shield: InventoryItem
@export var spray: InventoryItem
