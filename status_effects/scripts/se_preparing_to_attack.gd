extends StatusEffect
class_name SePreparingToAttack

signal attack_is_done

const STATUS_NAME: String = "se_preparing_to_attack"
const PICTURE: CompressedTexture2D = preload("res://assets/textures/ui/clock_debug.png")

var victim: Ally
var agressor: Enemy

func initiate_status(status_window: StatusWindow, owner: Enemy):
	agressor = owner
	was_initiated = true
	is_timed = true
	moves_left = 2
	status_node = status_window
	status_node.picture.texture = PICTURE
	status_node.number.text = str(moves_left)
	status_node.animation_player.play("show_status")

func check_status():
	moves_left -= 1
	status_node.number.text = str(moves_left)
	if moves_left == 1:
		status_node.animation_player.play("about_to_expire")
	elif moves_left == 0:
		attack()
		await attack_is_done

func attack():
	victim = get_target()
	
	var raw_damage = randi_range(1, agressor.stats.basic_damage) + randi_range(1, agressor.stats.basic_damage)
	var damage = max(1, raw_damage - get_protection(victim))
	
	approach_the_ally(agressor, victim)
	
	agressor.is_moving = false
	agressor.animation_player.play(agressor.melee_animation)
	await agressor.model.melee_reaction_ready
	await agressor.model.melee_reaction_ready
	if victim.stats.current_health < 1:
		victim.model.animation_player.play(victim.melee_death_animation)
	else:
		victim.model.animation_player.play(victim.melee_reaction)
	await agressor.animation_player.animation_finished
	agressor.back_to_main_spot()
	Global.change_phantom_camera(Global.current_combat_scene.main_pcam)
	await agressor.arrived_at_the_main_spot
	attack_is_done.emit()
	status_node.queue_free()
