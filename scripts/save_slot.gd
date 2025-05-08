extends Control

@export var save_slot : SavedGame 
@export var save_file_path : String

@onready var screenshot: TextureRect = $Button/SaveFileContainer/Screenshot
@onready var class_label: Label = $Button/SaveFileData/SaveFileDetails/CharacterInfoContainer/ClassLabel
@onready var space_label: Label = $Button/SaveFileData/SaveFileDetails/CharacterInfoContainer/SpaceLabel
@onready var cs_level_label: Label = $Button/SaveFileData/SaveFileDetails/CharacterInfoContainer/CSLevelLabel
@onready var level_label: Label = $Button/SaveFileData/SaveFileDetails/CharacterInfoContainer/LevelLabel
@onready var datetime_label: Label = $Button/SaveFileData/SaveFileDetails/DatetimeLabel

func _ready():
	var screenshot_texture = ImageTexture.create_from_image(save_slot.screenshot)
	print()
	var year: String = str(save_slot.datetime["year"])
	var month: String = str(save_slot.datetime["month"])
	var day: String = str(save_slot.datetime["day"])
	var hour: String = str(save_slot.datetime["hour"])
	var minute: String = str(save_slot.datetime["minute"])
	screenshot.texture = screenshot_texture
	class_label.text = "TESTING"
	level_label.text = str(save_slot.save_state["level"])
	datetime_label.text = year + "-" + month + '-' + day + " " + hour + ":" + minute
	#time_spent.text = str(save_slot.time_spent_playing)
	#level_label.text = "%s - Level %s" % [save_slot.adventure_mode, save_slot.level]
	#game_map_label.text = save_slot.formatted_datetime

func _on_button_pressed():
	if Global.is_about_to_load_game:
		Global.save_file_being_loaded = save_file_path
		get_tree().call_group('ui_elements', 'loading_game_from_menu')
	else:
		Global.save_file_to_be_removed = save_file_path
