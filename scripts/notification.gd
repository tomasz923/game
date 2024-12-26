extends Control

signal pop_up_finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var text = $Background/Text

var labels_list: Array = []
var texts_list: Array = []
var is_moving: bool = false

func play_pop_up():
	is_moving = true
	while is_moving:
		visible = true
		if not texts_list.is_empty():
			text.text = texts_list.pop_at(0)
			animation_player.play("pop_up")
			await animation_player.animation_finished
		else:
			is_moving = false
			visible = false
