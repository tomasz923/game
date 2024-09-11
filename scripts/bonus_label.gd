class_name BonusLabel
extends Label

#var red_font_color = '#dc6250'
#var yellow_font_color: String = '#eeb24a'
#var green_font_color = '#55927f'

var red_font = preload("res://game/resources/bonus_numbers_label_red.tres")
var green_font = preload("res://game/resources/bonus_numbers_label_green.tres")
var regular_font = preload("res://game/resources/bonus_numbers_label.tres")
	
func bonus_number():
	horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	if "+" in text:
		set("label_settings", green_font)
	elif "-" in text:
		set("label_settings/font_color", red_font)
	else:
		set("label_settings", regular_font)

func bonus_description():
	set("label_settings", regular_font)
	horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
