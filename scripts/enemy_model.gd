extends Node3D

signal animation_was_finished(anim_name: String)
signal melee_reaction_ready(is_evading: bool)
signal tween_backward()
signal tween_forward()
signal weapon_unsheathed()

@onready var animation_player: AnimationPlayer = $decoy/AnimationPlayer
@onready var right_hand_container: Node3D = $decoy/Armature/Skeleton3D/RightHandBone/RightHandContainer
@onready var hips_container: Node3D = $decoy/Armature/Skeleton3D/HipsBone/HipsContainer
@onready var back_container: Node3D = $decoy/Armature/Skeleton3D/BackBone/BackContainer
@onready var floating_number: Node3D = $decoy/Armature/Skeleton3D/HeadBone/FloatingTextsNode/FloatingNumber
@onready var floating_text: Node3D = $decoy/Armature/Skeleton3D/HeadBone/FloatingTextsNode/FloatingText
@onready var floating_texts_node: Node3D = $decoy/Armature/Skeleton3D/HeadBone/FloatingTextsNode

var melee_victim_reaction_count: int = 0

func _on_animation_player_animation_finished(anim_name):
	animation_was_finished.emit(anim_name)

# 0.4 & 0.9 AT 1H_MELEE_HORIZONTAL
func melee_victim_reaction():
	var _signal: bool = false
	melee_victim_reaction_count += 1
	if melee_victim_reaction_count == 3:
		melee_victim_reaction_count = 1
	if melee_victim_reaction_count == 1:
		_signal = true
	melee_reaction_ready.emit(_signal)
	
# 0.04 AT DODGE_BACKWARD
func send_tween_backward():
	tween_backward.emit()
	
# 0.04 AT DODGE_FORWARD
func send_tween_forward():
	tween_forward.emit()
	
func switch_1h_sheath():
	if hips_container.visible == false:
		hips_container.visible = true
		right_hand_container.visible = false
	else:
		hips_container.visible = false
		right_hand_container.visible = true

func emit_weapon_unsheathed():
	weapon_unsheathed.emit()
