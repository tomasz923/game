extends Node3D

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		if not get_tree().paused:  # Check if not already paused
			get_tree().call_group('cameras', 'blur')
			get_tree().paused = true
			$ui_elements.show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:  # Unpause if already paused
			get_tree().call_group('cameras', 'unblur')
			$ui_elements.hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_tree().paused = false


func take_players_positions():
	Global.player_position = $map/player.global_position


func continue_game():
	get_tree().call_group('cameras', 'unblur')
	$ui_elements.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
