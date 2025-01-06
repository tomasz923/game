extends Control

signal option_was_chosen(choice_index: int)


@onready var text = $Background/TextAndOptionsContainer/Text
@onready var options_container = $Background/TextAndOptionsContainer/OptionsContainer
@onready var title = $Title

const CHOICE_BUTTON = preload("res://game/scenes/choice_button.tscn")

func prepare_window(title: String, text: String, choice_array: Array, only_one: bool = true):
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

#Seperare signal for many choices
#When clicked it should check if it's in the array. If yes, remove it. If no, add it.
#When ready, click on OK and send the array as a signal
#after adding options, add invisible rectangular or something and then OK button (don't expand it)
