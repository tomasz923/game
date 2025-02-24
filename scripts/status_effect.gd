extends Resource
class_name StatusEffect

var is_timed: bool
var moves_left: int
var status_node: StatusWindow
var was_initiated: bool = false
var expired: bool = false

func approach_the_ally(agressor: Enemy, victim: Ally):
	agressor.observee = victim.global_position
	agressor.is_observing = true
	agressor.animation_player.play(agressor.melee_running_animation)
	agressor.hexagon_animation_player.play("RESET")
	victim.hexagon_animation_player.play("RESET")
	agressor.is_moving = true
	agressor.destination = victim.marker_3d.global_position
	victim.agressor_int_id = agressor.int_id
	agressor.update_target_position(agressor.destination)
	await agressor.melee_area.someone_is_in_melee_positon

func get_target() -> Ally:
	var max_aggro: int = 0
	var possible_targets: Array = []
	for ally in Global.shuffled_allies:
		if ally.stats.aggro > max_aggro and ally.stats.current_health > 0:
			max_aggro = ally.stats.aggro
	for ally in Global.shuffled_allies:
		if ally.stats.aggro == max_aggro and ally.stats.current_health > 0:
			possible_targets.append(ally)
	return possible_targets.pick_random() 

func get_protection(victim) -> int:
	var victim_defence: int = 0
	if victim.stats.spray != null:
		victim_defence += victim.enemy_stats.spray.damage_bonus
	if victim.stats.shield != null:
		victim_defence += victim.enemy_stats.shield.damage_bonus
	return victim_defence
