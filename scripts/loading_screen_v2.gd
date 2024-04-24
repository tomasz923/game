extends Control

var progress = []
var scene_load_status = 0

func _ready():
	ResourceLoader.load_threaded_request(Global.scene_being_loaded)

func _process(_delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(Global.scene_being_loaded, progress)
	$Countdown.text = str(floor(progress[0]*100)) + "%"
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get(Global.scene_being_loaded)
		get_tree().change_scene_to_packed(new_scene)
