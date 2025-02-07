extends Resource
class_name AllyStats

enum CharacterClass {
	PREACHER, #0
	PROTECTOR, #1
	HACKER, #2
	OPERATIVE, #3
	MILITANT, #4
	SCOUT, #5
	NONE
}
enum SecondBar {
	NONE, #0
	MEMORY, #1
	PROCESSING_CORES #2
}

@export_category("General")
@export var character_class: CharacterClass = CharacterClass.NONE
@export var ally_name: String = "ERROR: Name not found"
@export var max_health: int
@export var current_health: int
@export var character: Global.Characters
@export_range(4, 20, 2) var basic_damage: int = 4

@export_category("Items")
@export var melee: InventoryItem = preload("res://game/inventory_items/warhammer.tres")
@export var ranged: InventoryItem 
@export var shield: InventoryItem
@export var spray: InventoryItem

@export_category("Statistics")
@export var strength: int
@export var dexterity: int
@export var endurance: int
@export var charisma: int
@export var processing: int
@export var memory: int

var initial_stats = {
	Global.Characters.HERO: [1, 1, 1, 1, 1, 1],
	Global.Characters.CASY: [0, -1, 0, 1, 1, 2],
	Global.Characters.JETT: [0, 2, 1, 0, 1, -1],
	Global.Characters.WREN: [2, 0, 1, -1, 0, 1]
	##TODO: Add the rest
}

func calculate_max_health():
	var max_health: int = 0 # Default value
	match endurance:
		3: max_health = 25
		2: max_health = 23
		1: max_health = 20
		0: max_health = 16
		-1: max_health = 12
	match character:
		Global.Characters.HERO: ally_name = "HERO"
		Global.Characters.CASY: ally_name = "CASY"
		Global.Characters.WREN: ally_name = "WREN"
		Global.Characters.JETT: ally_name = "JETT"
		Global.Characters.MOSS: ally_name = "MOSS"
		Global.Characters.ONYX: ally_name = "ONYX"
		Global.Characters.SAGE: ally_name = "SAGE"

func initiate():
	var abilities: Array = [strength, dexterity, endurance, charisma, processing, memory]
	for i in len(abilities):
		abilities[i] = initial_stats[character][i]
