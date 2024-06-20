extends Control


@onready var label = $label
@onready var text = $text


@export var yes_function:String
@export var no_function:String

#func _ready():
	#label.text = label_content
	#text.text = text_conent
	

func _on_yes_button_pressed():
	print(yes_function)
