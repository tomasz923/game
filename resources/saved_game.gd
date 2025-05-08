class_name SavedGame
extends Resource

enum SaveTypes {
	NORMAL, 
	AUTOSAVE, 
	QUICKSAVE
}

# File Settings
@export var timestamp: int
@export var datetime: Dictionary
@export var save_type: SaveTypes 
@export var file_num: int = 1
@export var screenshot: Image

# Dictionaries
var state_var_dialogue: Dictionary
var journal: Dictionary
var save_state: Dictionary

# Combat 
var shuffled_allies: Array
var turn_order: int

# Global Variables
var current_scene: Node3D
var current_combat_scene: CombatScene
var cursors_visible_in_game: bool = false
var is_scene_being_loaded: bool = false
var is_pausable: bool = true
var is_eligible_for_saving: bool = true
