extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var tweenable = $Tweenable
@onready var label_3d = $Tweenable/Label3D

func show_damage(label_text):
	var number_tween = get_tree().create_tween()
	var end_pos = Vector3(randf_range(-0.8, 0.8), 3, 0) 
	var tween_length = 3.0
	label_3d.text = str(label_text)
	number_tween.tween_property(tweenable, "position", end_pos, tween_length).from(Vector3(0,2,0))
	animation_player.play("show_damage")

func show_status(status_name: String):
	var number_tween = get_tree().create_tween()
	var end_pos = Vector3(randf_range(-0.8, 0.8), 3, 0) 
	var tween_length = 3.0
	label_3d.text = status_name
	number_tween.tween_property(tweenable, "position", end_pos, tween_length).from(Vector3(0,2,0))
	animation_player.play("show_status")
