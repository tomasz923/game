extends Node3D
class_name GameMap

@export var game_map_name: String = 'protoype_game_map'

#@onready var journal = $Journal
#@onready var character_sheet = $CharacterSheet
#@onready var moves = $Moves
#@onready var inventory = $Inventory

# Obligatory Variables
@onready var hero: Hero = $Hero
@onready var follower_one: Follower = $FollowerOne
@onready var follower_two: Follower = $FollowerTwo
@onready var follower_three: Follower = $FollowerThree
@onready var screen_transiton: Control = $ScreenTransiton
@onready var main_menu_ui: Control = $MainMenuUI

func _ready():
	Global.current_scene = self
	#Global.moves_menu = $Moves
	#Global.dialogue_box = $DialogueBox
	#Global.dice_box = $DiceBox
	#Global.inventory = $Inventory
	#Global.pop_up = $Notification
	#Assigning characters
	#Global.hero = $Hero
	#Global.first_follower = $FollowerOne
	#Global.second_follower = $FollowerTwo
	#Global.third_follower = $FollowerThree
	#Setting Cams
	Global.allow_movement = true
	Global.collider = null
	Global.read_dice_rolls()

func _process(_delta):
	check_distance()

#func _input(_event):
	#if Input.is_action_just_pressed("ui_cancel"):
		#if Global.current_ui_mode == "none" and Global.pausable:  # Check if not already paused
			##get_tree().call_group('cameras', 'blur')
			#Global.current_ui_mode = "main_menu"
			#get_tree().paused = true
			#Global.take_screenshot()
			#$ui_elements.show()
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		#elif Global.current_ui_mode == "main_menu":  # Unpause if already paused
			#get_tree().call_group('main_menu', '_on_back_button_pressed')
			#$ui_elements.hide()
			#if not Global.cursors_visible_in_game:
				#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			#get_tree().paused = false
			#Global.current_ui_mode = "none"
		#elif Input.is_action_just_pressed("ui_cancel") and Global.current_ui_mode == "journal":
			#journal.visible = false
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			#get_tree().paused = false
			#Global.current_ui_mode = "none"
		#elif Input.is_action_just_pressed("ui_cancel") and Global.current_ui_mode == "character_sheet":
			#character_sheet.visible = false
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			#get_tree().paused = false
			#Global.current_ui_mode = "none"
		#elif Input.is_action_just_pressed("ui_cancel") and Global.current_ui_mode == "moves":
			#moves.visible = false
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			#get_tree().paused = false
			#Global.current_ui_mode = "none"
		#elif Input.is_action_just_pressed("ui_cancel") and Global.current_ui_mode == "inventory":
			#inventory.visible = false
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			#get_tree().paused = false
			#Global.current_ui_mode = "none"
	#
	#if Input.is_action_just_pressed("quicksave") and Global.is_eligible_for_saving:
		#Global.take_screenshot()
		#Global.quick_save()
	#
	#if Input.is_action_just_pressed("quickload") and Global.quick_save_file_path != null:
		#Global.save_file_being_loaded = Global.quick_save_file_path
		#Global.load_game()
	#
	#if Input.is_action_just_pressed("journal") and Global.pausable:
		#if Global.current_ui_mode == "none":  # Check if not already paused
			#Global.current_ui_mode = "journal"
			#get_tree().paused = true
			#journal.visible = true
			#journal.get_ready()
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		#elif Global.current_ui_mode == "journal":
			#Global.current_ui_mode = "none"
			#get_tree().paused = false
			#journal.visible = false
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		#else:
			#pass
	#
	#if Input.is_action_just_pressed("character_sheet") and Global.pausable:
		#if Global.current_ui_mode == "none":  # Check if not already paused
			#Global.current_ui_mode = "character_sheet"
			#get_tree().paused = true
			#character_sheet.visible = true
			#character_sheet.get_ready()
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		#elif Global.current_ui_mode == "character_sheet":
			#Global.current_ui_mode = "none"
			#get_tree().paused = false
			#character_sheet.visible = false
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		#else:
			#pass
			#
	#if Input.is_action_just_pressed("moves") and Global.pausable:
		#if Global.current_ui_mode == "none":  # Check if not already paused
			#Global.current_ui_mode = "moves"
			#get_tree().paused = true
			#moves.visible = true
			#moves.get_ready()
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		#elif Global.current_ui_mode == "moves":
			#Global.current_ui_mode = "none"
			#get_tree().paused = false
			#moves.visible = false
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		#else:
			#pass
	#
	#if Input.is_action_just_pressed("inventory") and Global.pausable:
		#if Global.current_ui_mode == "none":  # Check if not already paused
			#Global.current_ui_mode = "inventory"
			#get_tree().paused = true
			#inventory.visible = true
			#inventory.get_ready()
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		#elif Global.current_ui_mode == "inventory":
			#Global.current_ui_mode = "none"
			#get_tree().paused = false
			#inventory.visible = false
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		#else:
			#pass
	
func loading_game_locally():
	get_tree().paused = false
	Global.load_game()

func continue_game():
	get_tree().call_group('main_menu', '_on_back_utton_pressed')
	$ui_elements.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false

func check_distance():
	if follower_three.is_moving == true or follower_one.is_moving == true:
		var bg3_ps1_dist = follower_three.global_transform.origin.distance_to(hero.follower_position_one.global_transform.origin)
		var bg3_ps3_dist = follower_three.global_transform.origin.distance_to(hero.follower_position_three.global_transform.origin)
		var bg1_ps1_dist = follower_one.global_transform.origin.distance_to(hero.follower_position_one.global_transform.origin)
		var bg1_ps3_dist = follower_one.global_transform.origin.distance_to(hero.follower_position_three.global_transform.origin)
		var min_dist = min(bg3_ps1_dist, bg3_ps3_dist, bg1_ps1_dist, bg1_ps3_dist)
		
		if bg3_ps1_dist == min_dist:
			follower_three.follower_number = follower_three.FollowerOrder.FIRST
			follower_one.follower_number = follower_one.FollowerOrder.THIRD
		elif bg3_ps3_dist == min_dist:
			follower_three.follower_number = follower_three.FollowerOrder.THIRD
			follower_one.follower_number = follower_one.FollowerOrder.FIRST
		elif bg1_ps1_dist == min_dist:
			follower_three.follower_number = follower_three.FollowerOrder.THIRD
			follower_one.follower_number = follower_one.FollowerOrder.FIRST
		else:
			follower_three.follower_number = follower_three.FollowerOrder.FIRST
			follower_one.follower_number = follower_one.FollowerOrder.THIRD

func return_to_exploration():
	follower_one.global_position = hero.spawn_point_one.get_collision_point()
	follower_two.global_position = hero.spawn_point_two.get_collision_point()
	follower_three.global_position = hero.spawn_point_three.get_collision_point()
	Global.change_phantom_camera(hero.exploration_pcam, 0.0)
	var team = [hero, follower_one, follower_two, follower_three]
	for teammate in team:
		# If dead, it will reset their collision objects after combat ended:
		if teammate is Hero:
			teammate.set_collision_layer(1)
			teammate.set_collision_mask(3)
		else:
			teammate.set_collision_layer(2)
			teammate.set_collision_mask(2051)
		teammate.is_in_combat = false
		teammate.change_equipment(teammate.stats)
		teammate.hexagon_animation_player.play("RESET")
		teammate.model.hips_container.visible = true
		teammate.model.right_hand_container.visible = false
