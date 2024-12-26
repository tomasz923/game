extends Label

#FPS
const TIMER_LIMIT = 2.0
var timer = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer > TIMER_LIMIT: # Prints every 2 seconds
		timer = 0.0
		set_text("FPS: " + str(Engine.get_frames_per_second()))
