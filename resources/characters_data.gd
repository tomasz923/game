extends Resource
class_name CharactersData
#
enum CharacterClass {
	TEMPLAR, #0
	CLERIC, #1
	HACKER, #2
	ROGUE, #3
	TANK, #4
	RANGER #5
}

enum SecondBar {
	MEMORY, #0
	PROCESSING_CORES #1
}

@export_category("General")
@export var second_bar_type: SecondBar
@export var character_class: CharacterClass
@export var bonds: Array = []

@export_category("Equipment")
@export var melee: InventoryItem
@export var ranged: InventoryItem
@export var shield: InventoryItem
@export var protection: InventoryItem

@export_category("Attributes")
@export var strength: int = 0
@export var dexterity: int = 0
@export var endurance: int = 0
@export var processing: int = 0
@export var memory: int = 0
@export var charisma: int = 0

@export_category("Attributes")
@export var statuses: Array = []
