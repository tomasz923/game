extends Button

signal target_was_chosen(target_id: int)
signal target_was_highlighted(target_id: int)
signal target_was_abandoned(target_id: int)

var target_int_id: int

func _on_pressed():
	target_was_chosen.emit(target_int_id)

func _on_mouse_entered():
	if !disabled:
		target_was_highlighted.emit(target_int_id)

func _on_mouse_exited():
	if !disabled:
		target_was_abandoned.emit(target_int_id)
