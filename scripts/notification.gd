extends Control

signal pop_up_finished

@onready var pop_up: Control = $PopUp
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var text: Label = $PopUp/BlackPanel/Text
@onready var label: Button = $PopUp/Label

var labels_list: Array = []
var texts_list: Array = []
var is_moving: bool = false

func play_pop_up():
	is_moving = true
	while is_moving:
		visible = true
		if not labels_list.is_empty():
			text.text = texts_list.pop_at(0)
			label.text = labels_list.pop_at(0)
			animation_player.play("pop_up")
			await animation_player.animation_finished
		else:
			is_moving = false
			visible = false
