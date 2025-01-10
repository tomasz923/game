extends Node3D

signal animation_was_finished(anim_name: String)
signal melee_reaction_ready(is_evading: bool)
signal tween_backward()
signal tween_forward()

@onready var animation_player = $decoy/AnimationPlayer
@onready var back_container = $decoy/Armature/Skeleton3D/BackBone/BackContainer
@onready var hips_container = $decoy/Armature/Skeleton3D/HipsBone/HipsContainer
@onready var right_hand_container = $decoy/Armature/Skeleton3D/RightHandBone/RightHandContainer
var melee_victim_reaction_count: int = 0

func _on_animation_player_animation_finished(anim_name):
	animation_was_finished.emit(anim_name)

func melee_victim_reaction():
	var _signal: bool = false
	melee_victim_reaction_count += 1
	if melee_victim_reaction_count == 3:
		melee_victim_reaction_count = 1
	if melee_victim_reaction_count == 1:
		_signal = true
	melee_reaction_ready.emit(_signal)

func send_tween_backward():
	tween_backward.emit()

func send_tween_forward():
	tween_forward.emit()
