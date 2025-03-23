extends Control

@export var save_slot : SavedGame 
@export var save_file_path : String

@onready var screenshot: TextureRect = $VBoxContainer/Button/HBoxContainer/Screenshot
@onready var time_spent: Label = $Button/SaveFileContainer/SaveFileData/TimeSpent
@onready var level_label: Label = $VBoxContainer/Button/HBoxContainer/Control/VBoxContainer/CharacterInfoContainer/LevelLabel
@onready var game_map_label: Label = $VBoxContainer/Button/HBoxContainer/Control/VBoxContainer/GameMapLabel

func _ready():
	var screenshot_texture = ImageTexture.create_from_image(save_slot.screenshot)
	screenshot.texture = screenshot_texture
	time_spent.text = str(save_slot.time_spent_playing)
	level_label.text = "%s - Level %s" % [save_slot.adventure_mode, save_slot.level]
	game_map_label.text = save_slot.formatted_datetime

func _on_button_pressed():
	if Global.is_about_to_load_game:
		Global.save_file_being_loaded = save_file_path
		get_tree().call_group('ui_elements', 'loading_game_from_menu')
	else:
		Global.save_file_to_be_removed = save_file_path
