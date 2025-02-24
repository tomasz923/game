extends StatusEffect
class_name SePreparingToAttack

signal attack_is_done

const STATUS_NAME: String = "se_preparing_to_attack"
const PICTURE: CompressedTexture2D = preload("res://assets/textures/ui/clock_debug.png")

var victim: Ally
var agressor: Enemy

func initiate_status(enemy_window: StatusWindow, owner: Enemy):
	agressor = owner
	was_initiated = true
	is_timed = true
	moves_left = 4
	status_node = enemy_window
	print("debug se_pre " + str(enemy_window))
	status_node.picture.texture = PICTURE
	status_node.number.text = str(moves_left)
	status_node.animation_player.play("show_status")

func check_status():
	print("se_prep_at CHECKED")
	moves_left -= 1
	status_node.number.text = str(moves_left)
	if moves_left == 1:
		status_node.animation_player.play("about_to_expire")
	elif moves_left == 0:
		attack()
		await attack_is_done

func attack():
	var max_aggro: int = 0
	var possible_targets: Array = []
	
	for ally in Global.shuffled_allies:
		if ally.stats.aggro > max_aggro:
			max_aggro = ally.stats.aggro
	for ally in Global.shuffled_allies:
		if ally.stats.aggro == max_aggro:
			possible_targets.append(ally)
	
	var random_enemy_int: int = randi_range(0, len(possible_targets)-1)
	var chosen_target: Ally = possible_targets[random_enemy_int]
	
	Global.get_spots(victim)
	Global.get_spots(agressor, "main")
	#victim.someone_is_in_melee_positon.connect(start_stage_two)
	#agressor.model.melee_reaction_ready.connect(start_stage_three)
	#victim.model.animation_was_finished.connect(start_stage_four)
	victim.observee = agressor.global_position
	victim.is_observing = true
	go_for_melee(agressor, victim)

func go_for_melee(agressor: Enemy, victim: Ally):
	agressor.animation_player.play(agressor.melee_running_animation)
	agressor.hexagon_animation_player.play("RESET")
	victim.hexagon_animation_player.play("RESET")
	agressor.is_moving = true
	agressor.destination = victim.marker_3d.global_position
	victim.agressor_int_id = agressor.int_id
	agressor.update_target_position(agressor.destination)
