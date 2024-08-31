extends Node

@export var json_file: JSON
@onready var state = {
	"show_two" = false
}
@onready var dialogue_handler: EzDialogue = $EzDialogue

func _ready():
	dialogue_handler.start_dialogue(json_file, state)
