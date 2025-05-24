extends Resource
class_name MachineStats

@export var character_name: String = "ERROR: Name not found"
@export var portrait: Texture
@export var max_health: int
@export var current_health: int
@export_range(4, 20, 2) var basic_damage: int = 4

@export_category("Items")
@export var melee: InventoryItem = preload("res://game/inventory_items/warhammer.tres")
@export var ranged: InventoryItem
@export var shield: InventoryItem
@export var spray: InventoryItem
