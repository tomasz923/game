extends Node3D

@onready var player = $map/player
@onready var journal = $Journal

func _ready():
	Global.current_scene = "res://game/scenes/world.tscn"
	Global.dialogue_box = $DialogueBox
	Global.dice_box = $DiceBox
	#Setting Cams
	Global.allow_movement = true
	Global.collider = null
	Global.player_cam = player.player_cam
	Global.main_cam = player.main_cam
	Global.read_dice_rolls()

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel") and !Global.conversation_mode and !Global.journal_mode:
		if not get_tree().paused:  # Check if not already paused
			#get_tree().call_group('cameras', 'blur')
			get_tree().paused = true
			Global.take_screenshot()
			$ui_elements.show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:  # Unpause if already paused
			#get_tree().call_group('cameras', 'unblur')			
			get_tree().call_group('main_menu', '_on_back_button_pressed')
			$ui_elements.hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_tree().paused = false
	elif Input.is_action_just_pressed("ui_cancel") and Global.journal_mode:
		journal.visible = false
	
	if Input.is_action_just_pressed("quicksave") and Global.is_eligible_for_saving:
		Global.take_screenshot()
		Global.quick_save()
	
	if Input.is_action_just_pressed("quickload") and Global.quick_save_file_path != null:
		Global.save_file_being_loaded = Global.quick_save_file_path
		Global.load_game()
	
	if Input.is_action_just_pressed("journal"):
		pass

func  loading_game_locally():
	get_tree().paused = false
	Global.load_game()

func take_players_positions():
	Global.mw_player_position = $map/player.global_position

func continue_game():
	#get_tree().call_group('cameras', 'unblur')
	get_tree().call_group('main_menu', '_on_back_button_pressed')
	$ui_elements.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false

func new_game():
	pass
