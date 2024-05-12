extends Node3D

@onready var player = $Pausable/player

func _ready():
	if Global.temp_player_position != null: 
		player.global_position = Global.temp_player_position
	var parent_node = get_parent()
	Global.current_scene = "res://game/scenes/fightSceneOne.tscn"

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
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


func take_players_positions():
	Global.player_position = $map/player.global_position

func  loading_game_locally():
	print("TEMP: Successful load from fight.tsc")
	get_tree().paused = false
	Global.load_game()

func continue_game():
	get_tree().call_group('cameras', 'unblur')
	$ui_elements.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false

func new_game():
	pass
