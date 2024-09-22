extends Button

@export var colored_theme: Theme
var normal_theme: Theme = preload("res://game/resources/chances.tres")

func get_colored():
	theme = colored_theme

func get_normal():
	theme = normal_theme 
