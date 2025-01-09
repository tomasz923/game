extends Control

signal option_was_chosen(choice_index: int)


@onready var title = $Title
@onready var options_container = $Background/TextAndOptionsContainer/OptionsContainer
@onready var description = $Background/TextAndOptionsContainer/Description


const CHOICE_BUTTON = preload("res://game/scenes/choice_button.tscn")

func prepare_window(title_aux: String, description_aux: String, choice_array: Array, only_one: bool = true):
	description.text = description_aux
	title.text = title_aux
	
	for n in options_container.get_children():
		options_container.remove_child(n)
		n.queue_free()
	
	if only_one:
		for i in len(choice_array):
			var button_obj: ChoiceButton = CHOICE_BUTTON.instantiate()
			button_obj.alignment = HORIZONTAL_ALIGNMENT_CENTER
			button_obj.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			button_obj.choice_index =  i
			button_obj.text = choice_array[i]
			button_obj.choice_selected.connect(_on_choice_selected)
			options_container.add_child(button_obj)
	visible = true

func _on_choice_selected(choice_index: int):
	option_was_chosen.emit(choice_index)
	visible = false
