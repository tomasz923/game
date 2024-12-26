extends MoveResource
class_name HackAndSlash

@export var move_name: String = 'hack_and_slash_move.tres'
@export var description: String = 'mv_desc_hack_and_slash'
@export var move_type: Global.MoveType
var passed_requirements: bool = false

var bonus_array: Array 

func check_requirements():
	if Global.shuffled_allies[Global.turn_order].melee != null:
		passed_requirements = true
		deal_damage()

func execute_the_move(target_int_id: int):
	pass

func return_modifiers() -> Array:
	bonus_array = []
	
	if Global.shuffled_allies[Global.turn_order].melee.precise:
		bonus_array.append(["cs_dex_long", Global.shuffled_allies[Global.turn_order].dexterity])
	else:
		bonus_array.append(["cs_str_long", Global.shuffled_allies[Global.turn_order].strength])
		
	return bonus_array
