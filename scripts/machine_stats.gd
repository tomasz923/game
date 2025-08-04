extends Resource
class_name MachineStats

@export var character_name: String = "ERROR: Name not found"
@export var portrait: Texture
@export var max_health: int
@export var current_health: int
@export_range(4, 20, 2) var basic_damage: int = 4

@export_category("Items")
@export var melee_weapon: Weapon = preload("res://assets/temp/weapon_1h_wrench.tres")
@export var ranged_weapon: Weapon
@export var shield: PackedScene
@export var protection: PackedScene
