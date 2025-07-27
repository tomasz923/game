extends MachineStats
class_name AllyStats

enum SecondBar {
	NONE, #0
	MEMORY, #1
	PROCESSING_CORES #2
}

@export var character_class: String
@export var slots_and_cores: int = 2
@export var strength: int
@export var dexterity: int
@export var endurance: int
@export var charisma: int
@export var processing: int
@export var memory: int
var aggro: int

@export_category("Character Sheet")
@export var status_effects: Array[StatusEffect] = []
@export var bonds: Array[StatusEffect] = []
@export var backstory: Array[StatusEffect] = []

#func initiate(character):
	#max_health = 69 # Default value
	#match endurance:
		#3: max_health = 25
		#2: max_health = 23
		#1: max_health = 20
		#0: max_health = 16
		#-1: max_health = 12
	#current_health = max_health
