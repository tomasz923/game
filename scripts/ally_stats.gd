extends MachineStats
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

@export_category("Ally Stats")
@export var character_class: CharacterClass = CharacterClass.NONE
@export var ally_name: String = "ERROR: Name not found"
@export var strength: int
@export var dexterity: int
@export var endurance: int
@export var charisma: int
@export var processing: int
@export var memory: int
var aggro: int

var initial_stats = {
	Global.Characters.HERO: [1, 1, 1, 1, 1, 1],
	Global.Characters.CASY: [0, -1, 0, 1, 1, 2],
	Global.Characters.JETT: [0, 2, 1, 0, 1, -1],
	Global.Characters.WREN: [2, 0, 1, -1, 0, 1],
	Global.Characters.SAGE: [1, 0, -1, 1, 2, 0],
	Global.Characters.ONYX: [1, 1, 2, 0, -1, 0],
	Global.Characters.MOSS: [-1, 1, 0, 2, 0, 1]
}

func initiate(character):
	max_health = 69 # Default value
	strength = initial_stats[character][0]
	dexterity = initial_stats[character][1]
	endurance = initial_stats[character][2]
	charisma = initial_stats[character][3]
	processing = initial_stats[character][4]
	memory = initial_stats[character][5]
	match character:
		Global.Characters.HERO: ally_name = "HERO"
		Global.Characters.CASY: ally_name = "CASY"
		Global.Characters.WREN: ally_name = "WREN"
		Global.Characters.JETT: ally_name = "JETT"
		Global.Characters.MOSS: ally_name = "MOSS"
		Global.Characters.ONYX: ally_name = "ONYX"
		Global.Characters.SAGE: ally_name = "SAGE"
	match endurance:
		3: max_health = 25
		2: max_health = 23
		1: max_health = 20
		0: max_health = 16
		-1: max_health = 12
	current_health = max_health
