extends Resource
class_name MoveResource

func sort_modifiers(array: Array) -> Array:
	# Sort the array using sort_custom
	array.sort_custom(func(a, b):
		return a[1] < b[1]
	)
	return array

func go_for_melee(agressor: CharacterBody3D, victim: CharacterBody3D):
	agressor.animation_player.play(agressor.melee_running_animation)
	agressor.hexagon_animation_player.play("RESET")
	victim.hexagon_animation_player.play("RESET")
	agressor.is_moving = true
	agressor.destination = victim.marker_3d.global_position
	victim.melee_area.agressor_int_id = agressor.int_id
	agressor.update_target_position(agressor.destination)

func set_dice(dice_one: int, dice_two: int, roll_result: int):
		Global.current_combat_scene.left_die.combat_result(dice_one)
		Global.current_combat_scene.right_die.combat_result(dice_two)
		Global.current_combat_scene.show_the_dice(roll_result)

func get_protection(stats: MachineStats) -> int:
	var var_container: int = 0
	if stats.spray != null:
		var_container += stats.enemy_stats.spray.damage_bonus
	if stats.shield != null:
		var_container += stats.enemy_stats.shield.damage_bonus
	return var_container
	
