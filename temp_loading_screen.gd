extends Control

var progress = []
var scene_load_status = 0

func _ready():
	ResourceLoader.load_threaded_request("res://game/scenes/loading_screen_v2.tscn")

func _process(_delta):
	scene_load_status = ResourceLoader.load_threaded_get_status("res://game/scenes/loading_screen_v2.tscn", progress)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get("res://game/scenes/loading_screen_v2.tscn")
		get_tree().change_scene_to_packed(new_scene)
