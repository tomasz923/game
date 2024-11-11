extends Node3D

@onready var player = $map/player
@onready var journal = $Journal
@onready var character_sheet = $CharacterSheet
@onready var ray_cast_3d = $RayCast3D
@onready var blue_guy_3 = $blue_guy3
@onready var blue_guy = $blue_guy
@onready var moves = $Moves
@onready var debug_lbael = $DEBUG/DebugLbael

func _ready():
	Global.current_scene = "res://game/scenes/world.tscn"
	Global.moves_menu = $Moves
	Global.dialogue_box = $DialogueBox
	Global.dice_box = $DiceBox
	Global.pop_up = $Notification
	#Setting Cams
	Global.allow_movement = true
	Global.collider = null
	Global.player_cam = player.player_cam
	Global.main_cam = player.main_cam
	Global.read_dice_rolls()

func _process(delta):
	check_distance()
	debug_lbael.text = 'DEBUG: Current just_finished_talking value: ' + str(Global.just_finished_talking)

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		if Global.current_ui_mode == "none" and Global.pausable:  # Check if not already paused
			#get_tree().call_group('cameras', 'blur')
			Global.current_ui_mode = "main_menu"
			get_tree().paused = true
			Global.take_screenshot()
			$ui_elements.show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			print('DEBUG: ', ray_cast_3d.get_collision_point())
			blue_guy_3.position = ray_cast_3d.get_collision_point()
		elif Global.current_ui_mode == "main_menu":  # Unpause if already paused
			#get_tree().call_group('cameras', 'unblur')			
			get_tree().call_group('main_menu', '_on_back_button_pressed')
			$ui_elements.hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_tree().paused = false
			Global.current_ui_mode = "none"
		elif Input.is_action_just_pressed("ui_cancel") and Global.current_ui_mode == "journal":
			journal.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_tree().paused = false
			Global.current_ui_mode = "none"
		elif Input.is_action_just_pressed("ui_cancel") and Global.current_ui_mode == "character_sheet":
			character_sheet.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_tree().paused = false
			Global.current_ui_mode = "none"
		elif Input.is_action_just_pressed("ui_cancel") and Global.current_ui_mode == "moves":
			moves.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_tree().paused = false
			Global.current_ui_mode = "none"
	
	if Input.is_action_just_pressed("quicksave") and Global.is_eligible_for_saving:
		Global.take_screenshot()
		Global.quick_save()
	
	if Input.is_action_just_pressed("quickload") and Global.quick_save_file_path != null:
		Global.save_file_being_loaded = Global.quick_save_file_path
		Global.load_game()
	
	if Input.is_action_just_pressed("journal") and Global.pausable:
		if Global.current_ui_mode == "none":  # Check if not already paused
			Global.current_ui_mode = "journal"
			get_tree().paused = true
			journal.visible = true
			journal.get_ready()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Global.current_ui_mode == "journal":
			Global.current_ui_mode = "none"
			get_tree().paused = false
			journal.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			pass
	
	if Input.is_action_just_pressed("character_sheet") and Global.pausable:
		if Global.current_ui_mode == "none":  # Check if not already paused
			Global.current_ui_mode = "character_sheet"
			get_tree().paused = true
			character_sheet.visible = true
			character_sheet.get_ready()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Global.current_ui_mode == "character_sheet":
			Global.current_ui_mode = "none"
			get_tree().paused = false
			character_sheet.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			pass
			
	if Input.is_action_just_pressed("moves") and Global.pausable:
		if Global.current_ui_mode == "none":  # Check if not already paused
			Global.current_ui_mode = "moves"
			get_tree().paused = true
			moves.visible = true
			moves.get_ready()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Global.current_ui_mode == "moves":
			Global.current_ui_mode = "none"
			get_tree().paused = false
			moves.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			pass
	
func loading_game_locally():
	get_tree().paused = false
	Global.load_game()

func take_players_positions():
	Global.mw_player_position = $map/player.global_position

func continue_game():
	get_tree().call_group('main_menu', '_on_back_utton_pressed')
	$ui_elements.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false

func new_game():
	pass

func check_distance():
	if blue_guy_3.is_moving == true or blue_guy.is_moving == true:
		var bg3_ps1_dist = blue_guy_3.global_transform.origin.distance_to(player.follower_position_one.global_transform.origin)
		var bg3_ps3_dist = blue_guy_3.global_transform.origin.distance_to(player.follower_position_three.global_transform.origin)
		var bg1_ps1_dist = blue_guy.global_transform.origin.distance_to(player.follower_position_one.global_transform.origin)
		var bg1_ps3_dist = blue_guy.global_transform.origin.distance_to(player.follower_position_three.global_transform.origin)
		var min_dist = min(bg3_ps1_dist, bg3_ps3_dist, bg1_ps1_dist, bg1_ps3_dist)
		
		if bg3_ps1_dist == min_dist:
			blue_guy_3.FollowerNumber = 0
			blue_guy.FollowerNumber = 2
		elif bg3_ps3_dist == min_dist:
			blue_guy_3.FollowerNumber = 2
			blue_guy.FollowerNumber = 0
		elif bg1_ps1_dist == min_dist:
			blue_guy_3.FollowerNumber = 2
			blue_guy.FollowerNumber = 0
		else:
			blue_guy_3.FollowerNumber = 0
			blue_guy.FollowerNumber = 2		
