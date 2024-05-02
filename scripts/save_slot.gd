extends Control

@export var save_slot : SavedGame 

@onready var screenshot_image = $VBoxContainer/Button/HBoxContainer/screenshot_image
@onready var save_name = $VBoxContainer/Button/HBoxContainer/Control/VBoxContainer/save_name
@onready var level_label = $VBoxContainer/Button/HBoxContainer/Control/VBoxContainer/level_label
@onready var date_label = $VBoxContainer/Button/HBoxContainer/Control/VBoxContainer/date_label

func _ready():
	screenshot_image.texture = save_slot.screenshot.create_texture()
	save_name.text = save_slot.file_name
	level_label.text = "%s - Level %s" % [save_slot.adventure_mode, save_slot.level]
	date_label.text = save_slot.formatted_datetime
