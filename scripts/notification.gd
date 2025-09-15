extends Control
class_name Notification

@onready var animation_player: AnimationPlayer = $AnimationPlayer
#@onready var label = $Background/Text
@onready var title: Label = $Background/Container/Title
@onready var description: Label = $Background/Container/Description

var labels_list: Array = []
var texts_list: Array = []
var is_moving: bool = false

func play_pop_up():
	is_moving = true
	while is_moving:
		visible = true
		if not labels_list.is_empty():
			description.text = texts_list.pop_at(0)
			title.text = labels_list.pop_at(0)
			animation_player.play("pop_up")
			await animation_player.animation_finished
		else:
			is_moving = false
			visible = false
