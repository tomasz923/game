extends Resource
class_name MoveResource

func sort_modifiers(array: Array) -> Array:
	# Sort the array using sort_custom
	array.sort_custom(func(a, b):
		return a[1] < b[1]
	)
	
	return array

func go_for_melee(run_animation_name: String, agressor: CharacterBody3D, victim: CharacterBody3D):
	agressor.animation_player.play(run_animation_name)
	agressor.hexagon_animation_player.play("RESET")
	agressor.is_moving = true
	agressor.destination = victim.global_position
	victim.agressor_int_id = agressor.int_id
	agressor.update_target_position(agressor.destination)

func set_dice(dice_one: int, dice_two: int, roll_result: int, all_in: bool = true):
		Global.current_combat_scene.left_die.combat_result(dice_one)
		Global.current_combat_scene.right_die.combat_result(dice_two)
		if all_in:
			Global.current_combat_scene.show_the_dice(roll_result)
		else:
			Global.current_combat_scene.color_the_dice(roll_result)

func get_protection(target) -> int:
	var var_container: int = 0
	if target.spray != null:
		var_container += target.enemy_stats.spray.damage_bonus
	if target.shield != null:
		var_container += target.enemy_stats.shield.damage_bonus
	return var_container
