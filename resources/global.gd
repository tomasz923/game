extends Node

enum MoveType {
	DAMAGE, 
	HEAL, 
	OTHER
}
enum Characters {
	HERO, 
	JETT, 
	WREN,
	CASY,
	MOSS,
	SAGE,
	ONYX
}

var save_state: Dictionary = {
	#The player and the followers will use this variable.
	"current_exploration_speed":  3.5,
	"experience": 2,
	"level": 2,
}
# For easier access to UI nodes
var current_scene: Node3D
var current_combat_scene: CombatScene
# For easier access to the team for combat scenes and other nodes
# Allows for the player to move.
var allow_movement = false 
# -----------
var hero: Hero
var first_follower: Follower
var second_follower: Follower
var third_follower: Follower
# -----------
# So it knows if it should hide the cursor after leaving a menu
var cursors_visible_in_game = false
# Resource hold the same for all saves storing user preferences
var user_prefs: UserPreferences
# So it can be differentiated between enetering a scene vs loading it
var is_scene_being_loaded: bool = false
# Saved as a part of a save file
var screenshot: Image 
# For initail load of resolution, sound settings etc.
var is_initial_load_ready = false
# If th game cane be paused
var is_pausable: bool = true
#This variable checks if it is possible to save a game
var is_eligible_for_saving: bool = true
# To know how to understand pressed Escape
var current_ui_mode: String = "none"

#Combat 
var shuffled_allies: Array
var turn_order: int

#Variables for Player's choices
var state_var_dialogue: Dictionary = { 
	"talker": "ERROR",
	"has_met_demo": false, #test
	"name": "Anthony",
	"rolled_number": 0,
	"str": 1,
	"test_1": 1,
	"test_2": 1,
	'the_quest_is_active': false,
	'the_quest_is_done': false
}

var journal: Dictionary = {
	'q_test_quest' = {
		'status': 1, 
		'updates': ['qi_test_quest']
	},
	'q_test_quest_2' = {
		'status': 2, 
		'updates': ['qi_test_quest_2', '0']
	},
	'q_test_quest_3' = {
		'status': 3, 
		'updates': ['qi_test_quest_3', '4']
	}
}

#Dictionary for Moves and its Attribute
var roll_types: Dictionary = {
	"persuade": "str"
}
# ----------------------------- TO BE CHECKED
var is_rolling_dice_now: bool = false
#This variable holds a path to a fiel that is about to ba loaded. It changes when clciking on a save slot in a loading mode:
var save_file_being_loaded
#To mark current save slot of the quicksave
var quick_save_file_path
#When overwriting a save file, this variable will hold the path to the file that has be removed later:
var save_file_to_be_removed

#var current_scene: String 
var save_files
var highest_save_number:int = 0
var savegame_tres_files = []
var is_load_screen:bool
var saves_path = ("res://saves/")
var save_slot = preload("res://game/scenes/save_slot.tscn")
var is_about_to_load_game:bool #Whether the save slots are created for saving or loading; if saving - skip autosaves and quickloads
var last_save_file_path:String

#Dialogue
var dialogue_box = null #Path to the dialogue box in a local scene. Should be established at the ready.
var collider = null #The object which wich the Player's 3DRayCast is colliding so they can interact with.
var talker = null #The object that the Player is talking to.
var dice_box = null #Path to the dice box in a local scene. Should be established at the ready.
var pop_up = null #Path to the notification node in a local scene. Should be established at the ready.
var moves_menu = null #Path to the moves node in a local scene. Should be established at the ready.
var inventory = null
var just_finished_talking: bool = false


#Cameras for Dialogue
var current_pcam #in future - for saving current phantom camera
var main_cam = null
var talker_cam = null
var player_cam = null
var dice_rolls_data: Dictionary
var journal_entries_data: Dictionary

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		if current_ui_mode == "none" and is_pausable:  # Check if not already paused
			if allow_movement == true:
				allow_movement = false
				current_scene.hero.animation_player.play("idle")
			current_ui_mode = "main_menu"
			#current_scene.get_tree().set_pause(true)
			take_screenshot()
			current_scene.main_menu_ui._on_back_button_pressed(false)
			current_scene.main_menu_ui.visible = true
			switch_cursor_visibility(true)
		elif current_ui_mode == "main_menu":
			allow_movement = true
			current_ui_mode = "none"
			#current_scene.get_tree().set_pause(false)
			switch_cursor_visibility(false)
			current_scene.main_menu_ui.visible = false

	#Journal Statuses:
	#	0 - HIDDEN
	#	1 - ACTIVE
	#	2 - DONE
	#	3 - FAILED
	#	4 - OTHER

func read_dice_rolls():
	var file = "res://assets/json/dice_variables.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	#print('JSON as string: ', json_as_text)
	dice_rolls_data = JSON.parse_string(json_as_text)

func read_journ_entries():
	var file = "res://assets/json/journal_entries.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	#print('JSON as string: ', json_as_text)
	journal_entries_data = JSON.parse_string(json_as_text)

func take_screenshot():
	var viewport = get_viewport()
	var file_path = "res://saves/screenshot_resized.jpg"
	Global.screenshot = viewport.get_texture().get_image()
	Global.screenshot.resize(220, 120, Image.INTERPOLATE_LANCZOS)
	Global.screenshot.save_jpg(file_path, 0.8)

func save_game(vbox_container):
	var saved_game: SavedGame = SavedGame.new()
	var datetime = Time.get_datetime_dict_from_system()
	var current_save_file = saves_path + 'slot_' + str(Time.get_unix_time_from_datetime_dict(datetime)) + "_savegame" + str(highest_save_number+1) + ".tres"
	last_save_file_path = current_save_file
	
	#saved_game.current_scene = current_scene
	saved_game.formatted_datetime = "%04d-%02d-%02d %02d:%02d:%02d" % [datetime.year, datetime.month, datetime.day, datetime.hour, datetime.minute, datetime.second]
	saved_game.file_name = 'Fake Save '+str(highest_save_number+1)
	saved_game.adventure_mode = 'Exploration - Level'
	saved_game.level = 3
	saved_game.screenshot = screenshot
	saved_game.state_var_dialogue = state_var_dialogue
	
	ResourceSaver.save(saved_game, current_save_file)
	highest_save_number += 1
	
	#If it is a new file:
	var slot_instance = save_slot.instantiate()
	slot_instance.save_slot =  saved_game
	slot_instance.save_file_path = current_save_file
	vbox_container.add_child(slot_instance)
	vbox_container.move_child(slot_instance, 1)

func overwrite_save_game(vbox_container):
	var saved_game:SavedGame = SavedGame.new()
	var datetime = Time.get_datetime_dict_from_system()
	var current_save_file = saves_path + 'slot_' + str(Time.get_unix_time_from_datetime_dict(datetime)) + "_savegame" + str(highest_save_number+1) + ".tres"
	last_save_file_path = current_save_file
	
	#saved_game.current_scene = current_scene
	saved_game.formatted_datetime = "%04d-%02d-%02d %02d:%02d:%02d" % [datetime.year, datetime.month, datetime.day, datetime.hour, datetime.minute, datetime.second]
	saved_game.file_name = 'Fake Save '+str(highest_save_number+1)
	saved_game.adventure_mode = 'Exploration - Level'
	saved_game.level = 3
	saved_game.screenshot = screenshot
	saved_game.state_var_dialogue = state_var_dialogue
	
	ResourceSaver.save(saved_game, current_save_file)
	highest_save_number += 1
	
	#If it is a new file:
	var slot_instance = save_slot.instantiate()
	slot_instance.save_slot =  saved_game
	slot_instance.save_file_path = current_save_file
	vbox_container.add_child(slot_instance)
	vbox_container.move_child(slot_instance, 1)

func quick_save():
	if quick_save_file_path != null:
		DirAccess.remove_absolute(quick_save_file_path)
	var saved_game:SavedGame = SavedGame.new()
	var datetime = Time.get_datetime_dict_from_system()
	var current_save_file = saves_path + 'slot_' + str(Time.get_unix_time_from_datetime_dict(datetime)) + "_quicksave.tres"
	quick_save_file_path = current_save_file
	last_save_file_path = current_save_file
	
	# Make sure it is the same in all types of saves
	#saved_game.current_scene = current_scene
	saved_game.formatted_datetime = "%04d-%02d-%02d %02d:%02d:%02d" % [datetime.year, datetime.month, datetime.day, datetime.hour, datetime.minute, datetime.second]
	saved_game.file_name = 'Quick Save'
	saved_game.adventure_mode = 'Exploration - Level'
	saved_game.level = 3
	saved_game.screenshot = screenshot
	saved_game.state_var_dialogue = state_var_dialogue

	ResourceSaver.save(saved_game, current_save_file)

func auto_save():
	var saved_game:SavedGame = SavedGame.new()
	var datetime = Time.get_datetime_dict_from_system()
	var current_save_file = saves_path + 'slot_' + str(Time.get_unix_time_from_datetime_dict(datetime)) + "_autosave.tres"
	
	# Make sure it is the same in all types of saves
	#saved_game.current_scene = current_scene
	saved_game.formatted_datetime = "%04d-%02d-%02d %02d:%02d:%02d" % [datetime.year, datetime.month, datetime.day, datetime.hour, datetime.minute, datetime.second]
	saved_game.file_name = 'AutoSave'
	saved_game.adventure_mode = 'Exploration - Level'
	saved_game.level = 3
	saved_game.screenshot = screenshot
	saved_game.state_var_dialogue = state_var_dialogue

	ResourceSaver.save(saved_game, current_save_file)
	
func collect_save_files():
# Get all save files in the directory
	var dir_access = DirAccess.open("res://saves/")
	if dir_access:  # Check if directory was opened successfully
		save_files = dir_access.get_files()
		#dir_access.close()  # Close the directory access (important for resource management)
			# Filter only savegame*.tres files
		savegame_tres_files = []
		for file in save_files:
			if file.ends_with(".tres") and file.find("save") != -1:
				savegame_tres_files.append(file)
				#var save_number = int(file.save_file_number)  # Convert to integer
				#save_file_number = max(save_file_number, save_number)
		
		savegame_tres_files.reverse()
		#print("Here we go:")
		#print(savegame_tres_files)
		
		# Extract save numbers (assuming numbering starts from savegame1.tres)
		for file in savegame_tres_files:
			if file.ends_with(".tres") and file.find("savegame") != -1:
				var number_string = file.split("savegame")[1].split(".")[0]  # Extract number part
				var save_number = int(number_string)  # Convert to integer
				highest_save_number = max(highest_save_number, save_number)

func load_save_slots(vbox_container):
	var autosave_files_num = 0
	
	#Removing all nodes in the vbox container except the "new save button" (so removing all save slots)
	for n in vbox_container.get_children():
		if n.name != 'NewSaveSlotBackground':
			vbox_container.remove_child(n)
			n.queue_free() 
		
	for file in savegame_tres_files:
	 #Check if file starts with "savegame" and ends with ".tres"
		if file.begins_with("slot") and file.ends_with(".tres"):
			if file.ends_with("_quicksave.tres"):
				quick_save_file_path = "res://saves/" + file
				#print("Here is the quicksave file:" + quick_save_file_path)
			if file.ends_with("_autosave.tres"):
				autosave_files_num += 1
				#print("Number of autosave files: " + str(autosave_files_num))
				if autosave_files_num > 4:
					#print("TEMP: This file should have been removed: " + "res://saves/" + file)
					DirAccess.remove_absolute("res://saves/" + file)
					continue  
			# Load the save slot scene
			if is_about_to_load_game == true or (is_about_to_load_game == false and not (file.ends_with("_autosave.tres") or file.ends_with("_quicksave.tres"))):
				var slot_instance = save_slot.instantiate()
				var save_slot_path = saves_path + file
				var loaded_saved_slot = load(save_slot_path) as SavedGame
				slot_instance.save_slot =  loaded_saved_slot
				slot_instance.save_file_path = save_slot_path
				vbox_container.add_child(slot_instance)
				#slot_instance.name = str(FileAccess.get_modified_time(save_slot_path))
				#print("The new node's name is: ", slot_instance.name)
		if not save_slot:
			print("Error: Could not load save slot scene:", file)
		continue

func load_game():
	var saved_game:SavedGame = load(save_file_being_loaded)
	var loading_screen = load("res://game/scenes/loading_screen_v2.tscn")
	Global.mw_player_position = saved_game.mw_player_position
	#Global.current_scene = saved_game.current_scene
	Global.scene_being_loaded = Global.current_scene
	get_tree().change_scene_to_packed.bind(loading_screen).call_deferred()

func read_team_data(character):
	#TODO
	character.change_equipment()
	character.get_max_health()

#Enemy, Follower and Player functions
func change_phantom_camera(new_pcam: PhantomCamera3D, tween_duration: float = 0.0):
	new_pcam.set_tween_duration(tween_duration)
	var old_cam = Global.current_pcam
	Global.current_pcam = new_pcam
	Global.current_pcam.set_priority(30)
	old_cam.set_priority(0)
	Global.current_pcam.set_priority(20)

func set_melee_cameras(source: CharacterBody3D, target: CharacterBody3D):
	var new_pcam: PhantomCamera3D
	var to_the_left = source.combat_pcam_left.global_transform.origin.distance_to(target.global_position)
	var to_the_right = source.combat_pcam_right.global_transform.origin.distance_to(target.global_position)
	var minimum_camera_distance = max(to_the_left, to_the_right)
	if to_the_left == minimum_camera_distance:
		new_pcam = source.combat_pcam_left
	else:
		new_pcam = source.combat_pcam_right
	source.combat_pcam_target = target.staring_point.global_position
	Global.change_phantom_camera(new_pcam)

func get_spots(target: CharacterBody3D, position: String = "both"):
	match position:
		"back":
			target.back_spot = target.evade_position_ray.get_collision_point()
		"main":
			target.main_spot = target.global_position
		"both":
			target.main_spot = target.global_position
			target.back_spot = target.evade_position_ray.get_collision_point()

func switch_cursor_visibility(make_visible: bool):
	if make_visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.cursors_visible_in_game = true
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		Global.cursors_visible_in_game = false
