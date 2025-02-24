extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var tweenable = $Tweenable
@onready var label_3d = $Tweenable/Label3D

func show_damage(label_text):
	label_3d.text = str(label_text)
	animation_player.play("show_damage")

func show_status(status_name: String):
	label_3d.text = status_name
	animation_player.play("show_status")
