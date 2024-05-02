extends Node

var is_initial_load_ready = false
var scene_being_loaded
#Player's position in the main world:
var mw_player_position:Vector3
#Player's position in the fight world:
var temp_player_position:Vector3
var current_scene:String 
var screenshot : Image
var save_files
var highest_save_number : int = 0

func take_screenshot():
	var viewport = get_viewport()
	var file_path = "res://saves/screenshot_resized.jpg"
	Global.screenshot = viewport.get_texture().get_image()
	Global.screenshot.resize(220, 120, Image.INTERPOLATE_LANCZOS)
	Global.screenshot.save_jpg(file_path, 0.8)

func save_game():
	var saved_game:SavedGame = SavedGame.new()
	var datetime = Time.get_datetime_dict_from_system()
	
	saved_game.mw_player_position = Global.mw_player_position
	saved_game.current_scene = Global.current_scene
	saved_game.formatted_datetime = "%04d-%02d-%02d %02d:%02d:%02d" % [datetime.year, datetime.month, datetime.day, datetime.hour, datetime.minute, datetime.second]
	saved_game.file_name = 'Fake Save'
	saved_game.adventure_mode = 'Exploration - Level'
	saved_game.level = 3
	saved_game.screenshot = Global.screenshot
	
	ResourceSaver.save(saved_game, "res://saves/savegame.tres")

func temp_debugging():
# Get all save files in the directory
	var dir_access = DirAccess.open("res://saves/")

	if dir_access:  # Check if directory was opened successfully
		save_files = dir_access.get_files()
		#dir_access.close()  # Close the directory access (important for resource management)
			# Filter only savegame*.tres files
		var savegame_tres_files = []
		for file in save_files:
			if file.ends_with(".tres") and file.find("savegame") != -1:
				savegame_tres_files.append(file)
		
		# Extract save numbers (assuming numbering starts from savegame1.tres)
		for file in savegame_tres_files:
			var number_string = file.split("savegame")[1].split(".")[0]  # Extract number part
			var save_number = int(number_string)  # Convert to integer
			highest_save_number = max(highest_save_number, save_number)
		print("The highest number is ", highest_save_number)  # Find highest number
	else:
		var dir = DirAccess.open("res://")
		var path = "res://saves"
		if dir.make_dir_recursive(path) == OK:
			print("Directory created successfully.")
		else:
			print("Failed to create directory.")



func load_game():
	var saved_game:SavedGame = load("res://saves/savegame.tres")
	var loading_screen = load("res://game/scenes/loading_screen_v2.tscn")
	Global.mw_player_position = saved_game.mw_player_position
	Global.current_scene = saved_game.current_scene
	Global.scene_being_loaded = Global.current_scene
	get_tree().change_scene_to_packed.bind(loading_screen).call_deferred()
#func reset_values():
	#mw_player_position = null
	##Player's position in the fight world:
	#temp_player_position = null
	#current_scene = null
