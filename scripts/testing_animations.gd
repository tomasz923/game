extends Node3D

@onready var animation_player = $model/AnimationPlayer
var is_correct: bool = true
var animation_list: Array
var animations_set: Array = [
	"1h_bow_death",
	"1h_idle",
	"1h_melee_horizontal",
	"1h_react",
	"blocking",
	"bow_attack",
	"bow_idle",
	"bow_react",
	"bow_ready",
	"dodge_backward",
	"dodge_forward",
	"idle",
	"run",
	"shield_death",
	"using_spells",
	"walk",
	"1h_run_back",
	"1h_run_forward"
]

func _ready():
	print_all_animations()
	
func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("interact") and is_correct:
		play_animations()

func print_all_animations():
	animation_list = animation_player.get_animation_list()
	for anim_name in animation_list:
		if not anim_name in animations_set:
			print("Error: Animation from the list not founs in the set : ", anim_name)
			is_correct = false
	for anim_name in animations_set:
		if not anim_name in animation_list:
			print("Error: Animation from the set not found here:", anim_name)
			is_correct = false
	if is_correct:
		print('All checks done.')
	else:
		print('Errors detected. Running animations not possible.')

func play_animations():
	for animation_name in animation_list:
		# Play the animation
		animation_player.play(animation_name)
		# Wait for the animation to finish
		await animation_player.animation_finished

#func check_animations_set(a_name):

#func check_animation_list(a_name):
	
