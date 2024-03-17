extends Control

var language_codes = ["EN", "PL", "DE", "ES"]
var top_option_buttons = []
var first_row_buttons = []
var fscreen_yes_button
var fscreen_no_button
var screens_list = [] #To be removed later
var current_option_screen = null
var current_window_size = 0
var resolutions: Dictionary = {"2560x1440":Vector2i(2560,1080),
								"1920x1080":Vector2i(1920,1080),
								"1366x768":Vector2i(1366,768),
								"1536x864":Vector2i(1536,864),
								"1280x720":Vector2i(1280,720),
								"1440x900":Vector2i(1440,900),
								"1600x900":Vector2i(1600,900),
								"1024x600":Vector2i(1024,600),
								"800x600": Vector2i(800,600)}

#var scaled_res_bilinear : Dictionary = {
	#str(round(get_window().get_size().x*2))+"x"+str(round(get_window().get_size().y*2)):2,
	#str(round(get_window().get_size().x*1.5))+"x"+str(round(get_window().get_size().y*1.5)):1.5,
	#str(round(get_window().get_size().x*1.33))+"x"+str(round(get_window().get_size().y*1.33)):1.33,
	#str(round(get_window().get_size().x*1))+"x"+str(round(get_window().get_size().y*1)):1,
	#str(round(get_window().get_size().x*0.85))+"x"+str(round(get_window().get_size().y*0.85)):0.85,
	#str(round(get_window().get_size().x*0.75))+"x"+str(round(get_window().get_size().y*0.75)):0.75,
	#str(round(get_window().get_size().x*0.67))+"x"+str(round(get_window().get_size().y*0.67)):0.67,
	#str(round(get_window().get_size().x*0.5))+"x"+str(round(get_window().get_size().y*0.5)):0.5
#}

@onready var display_resolution = $options/options_body_screen/options_screen_margins/main_hbox_screen/main_container/wsize_container/screen_options2/display_resolution
@onready var label_scale = $options/options_body_screen/options_screen_margins/main_hbox_screen/main_container/resolution_box/label_scale
@onready var scaling_option = $options/options_body_screen/options_screen_margins/main_hbox_screen/main_container/scaling_box/scaling_hbox/scaling_option
@onready var game_resolution = $options/options_body_screen/options_screen_margins/main_hbox_screen/main_container/resolution_box/resolution_hbox/game_resolution
@onready var frs_scaling = $options/options_body_screen/options_screen_margins/main_hbox_screen/main_container/resolution_box/resolution_hbox/frs_scaling


func _ready()	:
	TranslationServer.set_locale("EN")
	$options.visible = false
	$options/options_body_audio.visible= false
	$options/options_body_screen.visible = false
	label_scale.visible = false 
	frs_scaling.visible = false 
	game_resolution.visible = false
	add_resolutions()


func _physics_process(_delta):
	pass

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
	
	top_option_buttons = [get_node("options/options_margines/horizontal_container/audio_button"),
	get_node("options/options_margines/horizontal_container/controls_button"),
	get_node("options/options_margines/horizontal_container/screen_button"),
	get_node("options/options_margines/horizontal_container/graphics_button"),
	get_node("options/options_margines/horizontal_container/game_button")]
	
	screens_list = [get_node("options/options_body_audio"),
	get_node("options/options_body_controls"),
	get_node("options/options_body_screen"),
	get_node("options/options_body_graphics"),
	get_node("options/options_body_game")]
	

func updateUI():
	pass

func _on_back_button_pressed():
	$main_menu.visible = true
	$options.visible = false

# Options top bar ----------------------------------------------------------------------------------
func _on_button_toggled(i : int, buttons_list : Array):
	$button_pressed.play()
	# Untoggle all other buttons
	for other_button in buttons_list:
		if other_button != buttons_list[i]:
			other_button.button_pressed = false
	if buttons_list[i].button_pressed == true:
		if current_option_screen != null:
			current_option_screen.visible = false
		screens_list[i].visible = true
		current_option_screen = screens_list[i]
	else:
		screens_list[i].visible = false
		current_option_screen = null

#func _on_toggle_button_toggled(toggled_on):
	#if toggled_on == true:
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	#else:
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)

func add_resolutions():
	var ID = 0
	for r in resolutions:
		display_resolution.add_item(r, ID)
		ID += 1

##Audio Options ------------------------------------------------------------------------------------
func _on_audio_button_pressed():
	_on_button_toggled(0, top_option_buttons)
	
##Controls Options ---------------------------------------------------------------------------------
func _on_controls_button_pressed():
	_on_button_toggled(1, top_option_buttons)
#
##Screen Options -----------------------------------------------------------------------------------
func _on_screen_button_pressed():
	_on_button_toggled(2, top_option_buttons)
	var value = 100
	var resolution_scale = value/100.00
	var resolution_text = str(round(get_window().get_size().x*resolution_scale))+"x"+str(round(get_window().get_size().y*resolution_scale))
	label_scale.set_text(str(value)+"% - "+ resolution_text)

func _on_display_resolution_item_selected(index):
	var _window = get_window()
	var mode = _window.get_mode()
	current_window_size = resolutions.values()[index]
	
	if mode == Window.MODE_WINDOWED:
		change_window_size()

func centre_window():
	var centre_screen = DisplayServer.screen_get_position()+DisplayServer.screen_get_size()/2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(centre_screen-window_size/2)

func change_window_size(): 
	DisplayServer.window_set_size(current_window_size)
	get_window().set_size(current_window_size)
	centre_window()

func _on_display_settings_item_selected(index):
	match index:
		0: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			change_window_size()

func _on_game_resolution_value_changed(value):
	var resolution_scale = value/100.00
	print(value)
	var resolution_text = str(round(get_window().get_size().x*resolution_scale))+"x"+str(round(get_window().get_size().y*resolution_scale))
	
	label_scale.set_text(str(value)+"% - "+ resolution_text)
	get_viewport().set_scaling_3d_scale(resolution_scale)

func _on_scaling_option_item_selected(index):
	match index:
		0:
			label_scale.visible = false 
			frs_scaling.visible = false 
			game_resolution.visible = false
		1:
			label_scale.visible = true 
			frs_scaling.visible = false 
			game_resolution.visible = true
		2:
			label_scale.visible = true 
			frs_scaling.visible = true 
			game_resolution.visible = false

func _on_frs_scaling_item_selected(index):
	match index:
		0:
			_on_game_resolution_value_changed(50.00)
		1:
			_on_game_resolution_value_changed(59.00)
		2:
			_on_game_resolution_value_changed(67.00)
		3:
			_on_game_resolution_value_changed(77.00)
		
##Graphics Options ---------------------------------------------------------------------------------
func _on_graphics_button_pressed():
	_on_button_toggled(3, top_option_buttons)
	
## Gameplay Options
func _on_game_button_pressed():
	_on_button_toggled(4, top_option_buttons)







