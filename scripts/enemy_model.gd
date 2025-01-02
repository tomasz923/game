extends Node3D

signal animation_was_finished(anim_name: String)
signal victim_reaction_1h_ready(anim_name: String)

@onready var animation_player = $AnimationPlayer
@onready var back_container = $Armature/Skeleton3D/BackBone/BackContainer
@onready var hips_container = $Armature/Skeleton3D/HipsBone/HipsContainer
@onready var right_hand_container = $Armature/Skeleton3D/RightHandBone/RightHandContainer


func _on_animation_player_animation_finished(anim_name):
	animation_was_finished.emit(anim_name)

func victim_reaction_1h():
	victim_reaction_1h_ready.emit()
