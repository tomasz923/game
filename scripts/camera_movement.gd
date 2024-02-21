extends Camera3D

var zoom_speed = 1
var min_fov = 60
var max_fov = 100

func _input(event): 
	if event is InputEventMouseButton: 
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			fov -= zoom_speed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			fov += zoom_speed
		fov = clamp(fov, min_fov, max_fov)
