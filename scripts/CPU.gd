extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Assuming Engine.get_frames_per_second() is still available
	set_text(str(OS.get_static_memory_usage()/1048576))
