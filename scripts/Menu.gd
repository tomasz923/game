extends Control

var language_codes = ["EN", "PL", "DE", "ES"]

func _ready()	:
	TranslationServer.set_locale("EN")
	$options.visible = false

#func _physics_process(delta):
	#print(TranslationServer.get_locale())

func _on_continue_pressed():
	$button_pressed.play()
	var current_local = TranslationServer.get_locale()
	if current_local == "EN":
		TranslationServer.set_locale("PL")
	else:
		TranslationServer.set_locale("EN")
	
func _on_new_game_pressed():
	$button_pressed.play()
	LoadManager.load_scene("res://game/scenes/world.tscn")

func _on_exit_pressed():
	$button_pressed.play()
	get_tree().quit()

func _on_options_pressed():
	$button_pressed.play()
	$main_menu.visible = false
	$options.visible = true

func updateUI():
	pass

func _on_back_button_pressed():
	$main_menu.visible = true
	$options.visible = false

