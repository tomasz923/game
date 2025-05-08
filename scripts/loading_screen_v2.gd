extends Control

var scene_load_status: int = 0
var progress: Array = []

func _ready():
	ResourceLoader.load_threaded_request(Global.next_scene)

func _process(_delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(Global.next_scene, progress)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get(Global.next_scene)
		get_tree().change_scene_to_packed(new_scene)
