class_name ChoiceButton extends Button

#Dialogue Choices
@onready var choice_index: int 

signal choice_selected(choice_index)

func _on_pressed():
	choice_selected.emit(choice_index)
