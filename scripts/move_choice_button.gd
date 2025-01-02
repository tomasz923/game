extends Button
class_name MoveChoiceButton 

signal forward_move_data(move: Resource, bonus_array: Array)

var total_bonus: int
var modifiers: Array
var move: Resource
var bonus_array: Array

func _on_pressed():
	bonus_array = move.return_roll_modifiers()
	forward_move_data.emit(move, bonus_array)
