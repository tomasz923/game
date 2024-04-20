extends Node3D

var is_paused = false

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().call_group('cameras', 'blur')
		get_tree().paused = true
		$pause.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

		
func _on_button_pressed():
	get_tree().call_group('cameras', 'unblur')
	get_tree().paused = false
	$pause.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_exit_pressed():
	get_tree().quit()
