extends Node3D

signal animation_was_finished(anim_name: String)
signal melee_reaction_ready()

@onready var animation_player = $decoy/AnimationPlayer
@onready var back_container = $decoy/Armature/Skeleton3D/BackBone/BackContainer
@onready var hips_container = $decoy/Armature/Skeleton3D/HipsBone/HipsContainer
@onready var right_hand_container = $decoy/Armature/Skeleton3D/RightHandBone/RightHandContainer

func _on_animation_player_animation_finished(anim_name):
	animation_was_finished.emit(anim_name)

func melee_victim_reaction():
	melee_reaction_ready.emit()
