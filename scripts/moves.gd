extends Control

@onready var basic_moves_listed = $BlackBox/Moves/MovesContainer/BasicMoves/BasicMovesListed
@onready var move_description_label = $BlackBox/Description/DescriptionContainer/MoveDescriptionLabel
@onready var move_name_label = $BlackBox/Description/DescriptionContainer/Divider/LabelContainer/MoveNameLabel
@onready var color_rect = $MainLabelContainer/ColorRect
@onready var main_label = $MainLabelContainer/ColorRect/MainLabel
@onready var description = $BlackBox/Description

const MOVE_BUTTON = preload("res://game/scenes/move_button.tscn")
const LOCKED_MOVE_BUTTON = preload("res://game/resources/locked_move_button.tres")
const UNLOCKED_MOVE_BUTTON = preload("res://game/resources/unlocked_move_button.tres")

var moves_dict: Dictionary = {
	'basic_moves': {
		'mv_name_melee_attack': {
			'is_active_move': true,
			'icon': "res://assets/textures/move_icons/sword_icon_temp.png",
			'description': 'mv_desc_melee_attack'
		},
		'mv_name_melee_attack_2': {
			'is_active_move': true,
			'icon': "res://assets/textures/move_icons/sword_icon_temp.png",
			'description': 'mv_desc_melee_attack'
		},
		'mv_name_melee_attack_3': {
			'is_active_move': false,
			'icon': "res://assets/textures/move_icons/sword_icon_temp.png",
			'description': 'mv_desc_melee_attack'
		}
	}
}

func get_ready():
	clear()
	color_rect.custom_minimum_size.x = main_label.size.x + 20
	Global.moves_menu = $"."
	for move in moves_dict['basic_moves']:
		if moves_dict['basic_moves'][move]['is_active_move']:
			var move_button: MoveButton = MOVE_BUTTON.instantiate()
			move_button.local_move_name = move 
			move_button.local_move_description = moves_dict['basic_moves'][move]['description']
			move_button.icon = load(moves_dict['basic_moves'][move]['icon'])
			move_button.show_move.connect(on_show_move)
			#button_obj.show_quest_updates.connect(on_show_quest_updates)
			basic_moves_listed.add_child(move_button)

func on_show_move(move_name: String, move_description: String):
	description.visible = true
	move_name_label.text = move_name
	move_description_label.text = move_description

func clear():
	description.visible = false
	for n in basic_moves_listed.get_children():
		basic_moves_listed.remove_child(n)
		n.queue_free() 
