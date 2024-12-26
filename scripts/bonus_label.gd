class_name BonusLabel
extends Label

#var red_font_color = '#dc6250'
#var yellow_font_color: String = '#eeb24a'
#var green_font_color = '#55927f'

const BONUS_NUMBERS_LABEL = preload("res://game/resources/bonus_numbers_label.tres")
const BONUS_NUMBERS_LABEL_RED = preload("res://game/resources/bonus_numbers_label_red.tres")
const BONUS_NUMBERS_LABEL_GREEN = preload("res://game/resources/bonus_numbers_label_green.tres")
const MVP_BONUS_NUMBERS_LABEL = preload("res://game/resources/mvp_bonus_numbers_label.tres")
const MVP_BONUS_NUMBERS_LABEL_GREEN = preload("res://game/resources/mvp_bonus_numbers_label_green.tres")
const MVP_BONUS_NUMBERS_LABEL_RED = preload("res://game/resources/mvp_bonus_numbers_label_red.tres")

func bonus_number(is_in_moves_panel: bool = false):
	horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	if is_in_moves_panel:
		if "+" in text:
			set("label_settings", MVP_BONUS_NUMBERS_LABEL_GREEN)
		elif "-" in text:
			set("label_settings", MVP_BONUS_NUMBERS_LABEL_RED)
		else:
			set("label_settings", MVP_BONUS_NUMBERS_LABEL)
	else:
		if "+" in text:
			set("label_settings", BONUS_NUMBERS_LABEL_GREEN)
		elif "-" in text:
			set("label_settings", BONUS_NUMBERS_LABEL_RED)
		else:
			set("label_settings", BONUS_NUMBERS_LABEL)

func bonus_description(is_in_moves_panel: bool = false):
	if is_in_moves_panel:
		set("label_settings", MVP_BONUS_NUMBERS_LABEL)
		horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	else:
		set("label_settings", BONUS_NUMBERS_LABEL)
		horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
