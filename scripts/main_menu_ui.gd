extends Control
#NEW
var current_options_screen: Control
var current_options_button: Button
#OLD
var language_codes = ["EN", "PL"]
var current_window_size = 0
var resolutions: Dictionary = {"2560x1440":Vector2i(2560,1080),
								"1920x1080":Vector2i(1920,1080),
								"1600x900":Vector2i(1600,900),
								"1536x864":Vector2i(1536,864),
								"1440x900":Vector2i(1440,900),
								"1366x768":Vector2i(1366,768),
								"1280x720":Vector2i(1280,720),
								"1024x600":Vector2i(1024,600),
								"800x600": Vector2i(800,600)}
#NEW
@onready var blur: ColorRect = $Blur
@onready var background: ColorRect = $Background
@onready var button_pressed: AudioStreamPlayer = $ButtonPressed
@onready var return_buttons_container: VBoxContainer = $ReturnButtonsContainer
@onready var back_button: Button = $ReturnButtonsContainer/BackButton
@onready var reset_button: Button = $ReturnButtonsContainer/ResetButton
@onready var options_node: Control = $OptionsNode
@onready var audio_button: Button = $OptionsNode/SettingsContainer/AudioButton
@onready var controls_button: Button = $OptionsNode/SettingsContainer/ControlsButton
@onready var screen_button: Button = $OptionsNode/SettingsContainer/ScreenButton
@onready var graphics_button: Button = $OptionsNode/SettingsContainer/GraphicsButton
@onready var game_button: Button = $OptionsNode/SettingsContainer/GameButton
@onready var options_audio_node: Control = $OptionsNode/OptionsAudioNode
@onready var master_slider: HSlider = $OptionsNode/OptionsAudioNode/OptionsAudioContainer/RightColumnAudio/MasterSlider
@onready var music_slider: HSlider = $OptionsNode/OptionsAudioNode/OptionsAudioContainer/RightColumnAudio/MusicSlider
@onready var ui_slider: HSlider = $OptionsNode/OptionsAudioNode/OptionsAudioContainer/RightColumnAudio/UISlider
@onready var sfx_slider: HSlider = $OptionsNode/OptionsAudioNode/OptionsAudioContainer/RightColumnAudio/SFXSlider
@onready var voice_slider: HSlider = $OptionsNode/OptionsAudioNode/OptionsAudioContainer/RightColumnAudio/VoiceSlider
@onready var options_controls_node: Control = $OptionsNode/OptionsControlsNode
@onready var mouse_sens_slider: HSlider = $OptionsNode/OptionsControlsNode/OptionsControlsContainer/RightColumnControls/MouseSensSlider
@onready var options_screen_node: Control = $OptionsNode/OptionsScreenNode
@onready var display_settings: OptionButton = $OptionsNode/OptionsScreenNode/OptionsScreenContainer/ScreenRightColumn/DisplaySettings
@onready var display_resolution: OptionButton = $OptionsNode/OptionsScreenNode/OptionsScreenContainer/ScreenRightColumn/DisplayResolution
@onready var scaling_label: Label = $OptionsNode/OptionsGraphicsNode/OptionsGraphicsContainer/GraphicsLeftColumn/ScalingLabel
@onready var scaling_option: OptionButton = $OptionsNode/OptionsGraphicsNode/OptionsGraphicsContainer/GraphicsRightCOlumn/ScalingOption
@onready var display_screen_settings: OptionButton = $OptionsNode/OptionsScreenNode/OptionsScreenContainer/ScreenRightColumn/DisplayScreenSettings
@onready var v_sync_settings: OptionButton = $OptionsNode/OptionsScreenNode/OptionsScreenContainer/ScreenRightColumn/VSyncSettings
@onready var options_graphics_node: Control = $OptionsNode/OptionsGraphicsNode
@onready var game_resolution_scale: HSlider = $OptionsNode/OptionsGraphicsNode/OptionsGraphicsContainer/GraphicsRightCOlumn/ResolutionContainer/GameResolutionScale
@onready var frs_scaling: OptionButton = $OptionsNode/OptionsGraphicsNode/OptionsGraphicsContainer/GraphicsRightCOlumn/ResolutionContainer/FRSScaling
@onready var anti_aliasing_options: OptionButton = $OptionsNode/OptionsGraphicsNode/OptionsGraphicsContainer/GraphicsRightCOlumn/AntiAliasingOptions
@onready var options_game_node: Control = $OptionsNode/OptionsGameNode
@onready var language_options: OptionButton = $OptionsNode/OptionsGameNode/OptionsGameContainer/GameRightColumn/LanguageOptions
@onready var main_menu_node: Control = $MainMenuNode
@onready var load_game_node: Control = $LoadGameNode

#OLD
#@onready var parent_node = get_parent()
#@onready var display_settings = $options/options_body_screen/options_screen_margins/main_hbox_screen/second_main_container/fscreen_options/display_settings
#@onready var display_resolution = $options/options_body_screen/options_screen_margins/main_hbox_screen/second_main_container/screen_options/display_resolution
#@onready var label_scale = $options/options_body_graphics/options_graphics_margines/options_graphics_hbox/first_vbox_graphics/resolution_box/label_scale
#@onready var scaling_option = $options/options_body_graphics/options_graphics_margines/options_graphics_hbox/second_vbox_graphics/scaling_hbox/scaling_option
#@onready var game_resolution = $options/options_body_graphics/options_graphics_margines/options_graphics_hbox/second_vbox_graphics/resolution_hbox/game_resolution_vbox/game_resolution
#@onready var frs_scaling = $options/options_body_graphics/options_graphics_margines/options_graphics_hbox/second_vbox_graphics/resolution_hbox/game_resolution_vbox/frs_scaling
#@onready var display_screen_settings = $options/options_body_screen/options_screen_margins/main_hbox_screen/second_main_container/display_screen_hbox/display_screen_settings
#@onready var vsync_settings = $options/options_body_screen/options_screen_margins/main_hbox_screen/second_main_container/vsync_options/vsync_settings
#@onready var language_option = $options/options_body_game/options_game_margines/options_game_hbox/second_vbox_game/language_option
#@onready var aa_option = $options/options_body_graphics/options_graphics_margines/options_graphics_hbox/second_vbox_graphics/aa_hbox/aa_option
#@onready var mouse_sens_slider = $options/options_body_controls/options_controls_margines/options_controls_hbox/second_vbox_controls/mouse_hbox/mouse_sens_slider
#@onready var master_slider = $options/options_body_audio/options_audio_margins/options_audio_hbox/second_vbox_audio/master_slider
#@onready var music_slider = $options/options_body_audio/options_audio_margins/options_audio_hbox/second_vbox_audio/music_slider
#@onready var ui_slider = $options/options_body_audio/options_audio_margins/options_audio_hbox/second_vbox_audio/ui_slider
#@onready var sfx_slider = $options/options_body_audio/options_audio_margins/options_audio_hbox/second_vbox_audio/sfx_slider
#@onready var voice_slider = $options/options_body_audio/options_audio_margins/options_audio_hbox/second_vbox_audio/voice_slider
@onready var save_slots_container: VBoxContainer = $LoadGameNode/ScrollContainer/SaveSlotsContainer
@onready var new_save_slot_button: Button = $LoadGameNode/ScrollContainer/SaveSlotsContainer/NewSaveSlotButton
#@onready var save_game = $main_menu/MarginContainer/main_menu/SaveGame


func _ready():
	#Global.read_last_mod()
	#if not Global.is_initial_load_ready:
	Global.user_prefs = UserPreferences.load_or_create()
	#Global.sort_save_slots()	
	add_resolutions()
	add_screens()
	
#TODO what is this shit?
	if Global.is_initial_load_ready:
		#print('Everything was already loaded')
		set_values()
	else:
		#Global.temp_debugging()
		load_settings()
		#print('Successul load')
		Global.is_initial_load_ready = true

func loading_game_from_menu():
	if get_parent().name == 'root':
		Global.load_game()
	else:
		get_tree().call_group('main_menu', 'loading_game_locally')

#MAIN OPTIONS
func _on_continue_pressed():
	button_pressed.play()

func _on_save_game_pressed():
	new_save_slot_button.visible = true
	Global.is_about_to_load_game = false
	Global.collect_save_files()
	Global.load_save_slots(save_slots_container)
	$load_game.visible = true
	main_menu_node.visible = false
	#new_save_slot_button.visible = true
	#get_tree().call_group('main_menu', 'take_players_positions')
	#Global.save_game(save_slots_container)

func _on_new_save_slot_button_pressed():
	Global.save_game(save_slots_container)
	_on_back_button_pressed()
	get_tree().call_group('main_menu', 'continue_game')

func _on_new_game_pressed() -> void:
	button_pressed.play()
	if get_parent().name == 'root':
		Global.scene_being_loaded = "res://game/scenes/world.tscn"
		var loading_screen = load("res://game/scenes/loading_screen_v2.tscn")
		get_tree().change_scene_to_packed.bind(loading_screen).call_deferred()
	else:
		#print('fuck off')
		pass

func _on_load_game_pressed():
	return_buttons_container.visible = true
	new_save_slot_button.visible = false
	Global.is_about_to_load_game = true
	Global.collect_save_files()
	Global.load_save_slots(save_slots_container)
	load_game_node.visible = true
	main_menu_node.visible = false

func _on_exit_pressed():
	button_pressed.play()
	get_tree().quit()

# SETTINGS 
func _on_options_pressed():
	button_pressed.play()
	return_buttons_container.visible = true
	main_menu_node.visible = false
	options_node.visible = true

func options_node_changed(button_toggled: Button, screen_chosen: Control):
	button_pressed.play()
	if current_options_button != null:
		current_options_button.set_pressed(false)
		current_options_screen.visible = false
	current_options_button = button_toggled
	current_options_screen = screen_chosen
	button_toggled.set_pressed(true)
	screen_chosen.visible = true

func _on_audio_button_pressed():
	options_node_changed(audio_button, options_audio_node)

func _on_back_button_pressed():
	button_pressed.play()
	return_buttons_container.visible = false
	main_menu_node.visible = true
	options_node.visible = false
	load_game_node.visible = false

func _on_reset_button_pressed():
	Global.user_prefs.display_resolution_selected = 1
	Global.user_prefs.display_settings_selected = 0
	Global.user_prefs.vsync_settings_selected = 0
	Global.user_prefs.current_screen_selected = 0
	Global.user_prefs.scaling_item_selected = 3
	Global.user_prefs.game_resolution_value_selected = 100
	Global.user_prefs.scaling_option_item_selected = 0
	Global.user_prefs.chosen_language = 0
	Global.user_prefs.save()
	load_settings()

func load_settings():
	#Screen Selected
	#Omit if on SteamDeck 2DO
	var window = get_window()
	if Global.user_prefs.current_screen_selected + 1 > DisplayServer.get_screen_count():
		window.set_mode(Window.MODE_WINDOWED)
		window.set_current_screen(0)
		display_screen_settings.select(0)
	else:
		window.set_mode(Window.MODE_WINDOWED)
		window.set_current_screen(Global.user_prefs.current_screen_selected)
		display_screen_settings.select(Global.user_prefs.current_screen_selected)
		
	#Resolution
	#Omit on SteamDeck 2DO
	display_resolution.select(Global.user_prefs.display_resolution_selected)
	var _window = get_window()
	current_window_size = resolutions.values()[Global.user_prefs.display_resolution_selected]
		
	#Fullscreen
	#Omit on SteamDeck 2DO
	display_settings.select(Global.user_prefs.display_settings_selected)
	match Global.user_prefs.display_settings_selected:
		0: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			change_window_size()
	
	#V-Sync
	v_sync_settings.select(Global.user_prefs.vsync_settings_selected)
	#print(DisplayServer.get_screen_count())
	match Global.user_prefs.vsync_settings_selected:
		0:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		1:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	#Scaling Load
	scaling_option.select(Global.user_prefs.scaling_option_item_selected)
	match Global.user_prefs.scaling_option_item_selected:
		0:
			get_viewport().set_scaling_3d_mode(Viewport.SCALING_3D_MODE_BILINEAR)
			frs_scaling.visible = false 
			game_resolution_scale.visible = true
			game_resolution_scale.value = Global.user_prefs.game_resolution_value_selected
			_on_game_resolution_value_changed(Global.user_prefs.game_resolution_value_selected)
		1:
			get_viewport().set_scaling_3d_mode(Viewport.SCALING_3D_MODE_FSR2)
			frs_scaling.visible = true 
			game_resolution_scale.visible = false
			frs_scaling.select(Global.user_prefs.scaling_item_selected)
			_on_frs_scaling_item_selected(Global.user_prefs.scaling_item_selected)
			
	#Language
	language_options.select(Global.user_prefs.chosen_language)
	match Global.user_prefs.chosen_language:
		0:
			TranslationServer.set_locale("EN")
		1:
			TranslationServer.set_locale("PL")
	
	# AA
	anti_aliasing_options.select(Global.user_prefs.aa_option_selected)
	match Global.user_prefs.aa_option_selected:
		0:
			get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
			get_viewport().use_taa = false
		1:
			get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
			get_viewport().use_taa = false
		2:
			get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
			get_viewport().use_taa = true
	
	# Mouse Sensitivity
	mouse_sens_slider.value = Global.user_prefs.mouse_sensitivity
	
	# Audio
	master_slider.value = Global.user_prefs.master_volume
	voice_slider.value = Global.user_prefs.voice_volume
	sfx_slider.value = Global.user_prefs.sfx_volume
	ui_slider.value = Global.user_prefs.ui_volume
	music_slider.value = Global.user_prefs.music_volume
	
	_on_master_slider_value_changed(Global.user_prefs.master_volume)
	_on_voice_slider_value_changed(Global.user_prefs.voice_volume)
	_on_sfx_slider_value_changed(Global.user_prefs.sfx_volume)
	_on_ui_slider_value_changed(Global.user_prefs.ui_volume)
	_on_music_slider_value_changed(Global.user_prefs.music_volume)
	
func set_values():
	#Screen Selected
	#Omit if on SteamDeck 2DO
	if Global.user_prefs.current_screen_selected + 1 > DisplayServer.get_screen_count():
		display_screen_settings.select(0)
	else:
		display_screen_settings.select(Global.user_prefs.current_screen_selected)
		
	#Resolution
	#Omit on SteamDeck 2DO
	display_resolution.select(Global.user_prefs.display_resolution_selected)
	var _window = get_window()
	current_window_size = resolutions.values()[Global.user_prefs.display_resolution_selected]
		
	#Fullscreen
	#Omit on SteamDeck 2DO
	display_settings.select(Global.user_prefs.display_settings_selected)
	
	#V-Sync
	v_sync_settings.select(Global.user_prefs.vsync_settings_selected)
	
	#Scaling Load
	scaling_option.select(Global.user_prefs.scaling_option_item_selected)
	
	#Language
	language_options.select(Global.user_prefs.chosen_language)
	
	# AA
	anti_aliasing_options.select(Global.user_prefs.aa_option_selected)
	
	# Mouse Sensitivity
	mouse_sens_slider.value = Global.user_prefs.mouse_sensitivity
	
	# Audio
	master_slider.value = Global.user_prefs.master_volume
	voice_slider.value = Global.user_prefs.voice_volume
	sfx_slider.value = Global.user_prefs.sfx_volume
	ui_slider.value = Global.user_prefs.ui_volume
	music_slider.value = Global.user_prefs.music_volume

	
# Options top bar ----------------------------------------------------------------------------------
#func _on_button_toggled(i : int, buttons_list : Array):
	#$button_pressed.play()
	## Untoggle all other buttons
	#for other_button in buttons_list:
		#if other_button != buttons_list[i]:
			#other_button.button_pressed = false
	#if buttons_list[i].button_pressed == true:
		#if current_option_screen != null:
			#current_option_screen.visible = false
		#screens_list[i].visible = true
		#current_option_screen = screens_list[i]
	#else:
		#screens_list[i].visible = false
		#current_option_screen = null

func add_resolutions():
	var ID = 0
	for r in resolutions:
		display_resolution.add_item(r, ID)
		ID += 1


func _on_master_slider_value_changed(value):
	var bus_index = AudioServer.get_bus_index('Master')
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	Global.user_prefs.master_volume = value
	Global.user_prefs.save()

func _on_music_slider_value_changed(value):
	var bus_index = AudioServer.get_bus_index('Music')
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	Global.user_prefs.music_volume = value
	Global.user_prefs.save()

func _on_ui_slider_value_changed(value):
	var bus_index = AudioServer.get_bus_index('UI')
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	Global.user_prefs.ui_volume = value
	Global.user_prefs.save()

func _on_sfx_slider_value_changed(value):
	var bus_index = AudioServer.get_bus_index('SFX')
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	Global.user_prefs.sfx_volume = value
	Global.user_prefs.save()

func _on_voice_slider_value_changed(value):
	var bus_index = AudioServer.get_bus_index('Voice')
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	Global.user_prefs.voice_volume = value
	Global.user_prefs.save()
##Controls Options ---------------------------------------------------------------------------------
func _on_controls_button_pressed():
	options_node_changed(controls_button, options_controls_node)

func _on_mouse_sens_slider_value_changed(value):
	Global.user_prefs.mouse_sensitivity = value
	Global.user_prefs.save()
##Screen Options -----------------------------------------------------------------------------------
func _on_screen_button_pressed():
	options_node_changed(screen_button, options_screen_node)

func _on_display_resolution_item_selected(index):
	var _window = get_window()
	var mode = _window.get_mode()
	current_window_size = resolutions.values()[index]
	
	if Global.user_prefs:
		Global.user_prefs.display_resolution_selected = index
		Global.user_prefs.save()
	
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
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			Global.user_prefs.display_settings_selected = 0 
			Global.user_prefs.save()
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			Global.user_prefs.display_settings_selected = 1
			Global.user_prefs.save()
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			Global.user_prefs.display_settings_selected = 2
			Global.user_prefs.save()
			change_window_size()

func _on_vsync_settings_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			Global.user_prefs.vsync_settings_selected = 0
			Global.user_prefs.save()
		1:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			Global.user_prefs.vsync_settings_selected = 0
			Global.user_prefs.save()

func add_screens():
	var screens = DisplayServer.get_screen_count()
	
	for s in screens:
		display_screen_settings.add_item(str(s+1))

func _on_display_screen_settings_item_selected(index):
	var window = get_window()
	Global.user_prefs.current_screen_selected = index
	Global.user_prefs.save()
	#Needs to change once we have saved settings variables, so it returns to be unwindowed.
	
	window.set_mode(Window.MODE_WINDOWED)
	window.set_current_screen(index)
	
	if Global.user_prefs.display_settings_selected != 2:
		_on_display_settings_item_selected(Global.user_prefs.display_settings_selected)

##Graphics Options ---------------------------------------------------------------------------------
func _on_aa_option_item_selected(index):
	Global.user_prefs.aa_option_selected = index
	Global.user_prefs.save()
	match index:
		0:
			get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
			get_viewport().use_taa = false
		1:
			get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
			get_viewport().use_taa = false
		2:
			get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
			get_viewport().use_taa = true

func _on_graphics_button_pressed():
	options_node_changed(graphics_button, options_graphics_node)
	var value = Global.user_prefs.game_resolution_value_selected
	var resolution_scale = value/100.00
	var resolution_text = str(round(get_window().get_size().x*resolution_scale))+"x"+str(round(get_window().get_size().y*resolution_scale))
	scaling_label.set_text(str(value)+"% - "+ resolution_text)

func _on_game_resolution_value_changed(value):
	Global.user_prefs.game_resolution_value_selected = value
	Global.user_prefs.save()
	var resolution_scale = value/100.00
	var resolution_text = str(round(get_window().get_size().x*resolution_scale))+"x"+str(round(get_window().get_size().y*resolution_scale))
	
	scaling_label.set_text(str(value)+"% - "+ resolution_text)
	get_viewport().set_scaling_3d_scale(resolution_scale)

func _on_scaling_option_item_selected(index):
	Global.user_prefs.scaling_option_item_selected = index
	Global.user_prefs.save()
	match index:
		0:
			get_viewport().set_scaling_3d_mode(Viewport.SCALING_3D_MODE_BILINEAR)
			scaling_label.visible = true 
			frs_scaling.visible = false 
			game_resolution_scale.visible = true
			game_resolution_scale.value = 100
			_on_game_resolution_value_changed(100)
		1:
			get_viewport().set_scaling_3d_mode(Viewport.SCALING_3D_MODE_FSR2)
			scaling_label.visible = true 
			frs_scaling.visible = true 
			game_resolution_scale.visible = false
			frs_scaling.select(3)
			_on_frs_scaling_item_selected(3)

func _on_frs_scaling_item_selected(index):
	Global.user_prefs.scaling_item_selected = index
	Global.user_prefs.save()
	match index:
		0:
			_on_game_resolution_value_changed(50.00)
		1:
			_on_game_resolution_value_changed(59.00)
		2:
			_on_game_resolution_value_changed(67.00)
		3:
			_on_game_resolution_value_changed(77.00)

## Gameplay Options
func _on_game_button_pressed():
	options_node_changed(game_button, options_game_node)

func _on_language_option_item_selected(index):
	Global.user_prefs.chosen_language = index 
	Global.user_prefs.save()
	match index:
		0:
			TranslationServer.set_locale("EN")
		1:
			TranslationServer.set_locale("PL")
