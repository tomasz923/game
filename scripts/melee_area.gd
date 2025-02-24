extends Area3D

signal someone_is_in_melee_positon

var agressor_int_id: int = 69
var victim_int_id: int = 69
var is_attacking: bool = false
var area_owner: Enemy

func _on_body_entered(body: Node3D) -> void:
	if !is_attacking and body is Ally:
		if body.int_id == agressor_int_id:
			someone_is_in_melee_positon.emit()
			body.is_moving = false
	elif is_attacking and body is Ally:
		if body.int_id == victim_int_id:
			someone_is_in_melee_positon.emit()
