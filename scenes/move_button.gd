extends Button
class_name MoveButton

signal show_move(move_name: String, move_description: String)

var local_move_description: String
var local_move_name: String

func _on_pressed():
	show_move.emit(local_move_name, local_move_description)
