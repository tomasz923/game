extends Area3D

signal someone_is_in_melee_positon

var agressor_int_id: int = 69

func _on_body_entered(body: Node3D) -> void:
	if body is Machine:
		if body.is_in_combat == true and body.int_id == agressor_int_id:
			someone_is_in_melee_positon.emit()
			body.is_moving = false
