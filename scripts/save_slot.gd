extends Control

@export var save_slot : SavedGame 
@export var save_file_path : String

@onready var screenshot_image = $VBoxContainer/Button/HBoxContainer/screenshot_image
@onready var save_name = $VBoxContainer/Button/HBoxContainer/Control/VBoxContainer/save_name
@onready var level_label = $VBoxContainer/Button/HBoxContainer/Control/VBoxContainer/level_label
@onready var date_label = $VBoxContainer/Button/HBoxContainer/Control/VBoxContainer/date_label


func _ready():
	var screenshot_texture = ImageTexture.create_from_image(save_slot.screenshot)
	screenshot_image.texture = screenshot_texture
	save_name.text = save_slot.file_name
	level_label.text = "%s - Level %s" % [save_slot.adventure_mode, save_slot.level]
	date_label.text = save_slot.formatted_datetime
	
	#self.add_to_group("root_node")

func _on_button_pressed():
	if Global.is_about_to_load_game:
		Global.save_file_being_loaded = save_file_path
		get_tree().call_group('ui_elements', 'loading_game_from_menu')
	else:
		Global.save_file_to_be_removed = save_file_path
