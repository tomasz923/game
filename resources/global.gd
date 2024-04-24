extends Node

var is_initial_load_ready = false
var scene_being_loaded
var player_position:Vector3


func save_game():
	var saved_game:SavedGame = SavedGame.new()
	saved_game.player_position = player_position
	
