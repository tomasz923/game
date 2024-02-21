extends Control



func _on_continue_pressed():
	$ColorRect/MarginContainer/VBoxContainer/button_pressed.play()

func _on_new_game_pressed():
	$ColorRect/MarginContainer/VBoxContainer/button_pressed.play()
	LoadManager.load_scene("res://game/scenes/world.tscn")

func _on_exit_pressed():
	$ColorRect/MarginContainer/VBoxContainer/button_pressed.play()
	get_tree().quit()

func _on_options_pressed():
	$ColorRect/MarginContainer/VBoxContainer/button_pressed.play()
