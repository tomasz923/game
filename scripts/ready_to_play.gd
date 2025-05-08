extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var any_button_was_pressed: bool = false

func _input(event):
	if !any_button_was_pressed and event.is_pressed():
		any_button_was_pressed = true
		animation_player.play("hide")
		await animation_player.animation_finished
		Global.allow_movement = true
		Global.is_pausable = true
		visible = false
