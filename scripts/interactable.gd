extends CollisionObject3D
class_name Interactable

@onready var label = $Label
@onready var animation_player = $visuals/model/AnimationPlayer
@onready var talker_cam = $TalkerCam

@export var label_content = "null"
@export var interaction_animation: String
@export var is_a_character: bool
@export var is_talking: bool = false
@export var script_file: JSON

func _ready():
	label.text = label_content
	add_to_group("labeled_objects")
	#label.visible = false


#func look_at_player():
	## Get the current rotation
	#var start_rotation = global_rotation
	## Make the object look at the player immediately (to calculate target rotation)
	#look_at(Global.player_position)
	## Store the target rotation
	#var target_rotation = global_rotation
	## Reset to start rotation
	#global_rotation = start_rotation
	## Create a tween to smoothly rotate to the target
	##tween.stop_all()  # Stop any existing tweens
	#var tween = create_tween()
	#tween.tween_property(self, "global_rotation", target_rotation, 1).set_trans(Tween.TRANS_LINEAR)

func interaction():
	if is_a_character:
		look_at(Global.player_position)

func show_label():
	label.visible = true

func hide_label():
	label.visible = false
