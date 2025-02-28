extends StatusEffect
class_name SePreparingToAttack

const STATUS_NAME: String = "se_preparing_to_attack"
const PICTURE: CompressedTexture2D = preload("res://assets/textures/ui/clock_debug.png")

var victim: Ally
var agressor: Enemy

func initiate_status(status_window: StatusWindow, owner: Enemy):
	agressor = owner
	was_initiated = true
	is_timed = true
	moves_left = 3
	status_node = status_window
	status_node.picture.texture = PICTURE
	status_node.number.text = str(moves_left)
	status_node.animation_player.play("show_status")

func check_status():
	moves_left -= 1
	status_node.number.text = str(moves_left)
	if moves_left == 1:
		status_node.animation_player.play("about_to_expire")
		return true
	elif moves_left == 0:
		await attack()
		return true
	else:
		return true

func attack():
	victim = get_target()
	
	var raw_damage = randi_range(1, agressor.stats.basic_damage) + randi_range(1, agressor.stats.basic_damage)
	var damage = max(1, raw_damage - get_protection(victim))
	
	approach_the_ally(agressor, victim)
	await agressor.melee_area.someone_is_in_melee_positon
	agressor.is_moving = false
	agressor.animation_player.play(agressor.melee_animation)
	victim.stats.current_health -= damage
	Global.current_combat_scene.statuses_and_damage.append(["damage", victim, damage])
	await agressor.model.melee_reaction_ready
	await agressor.model.melee_reaction_ready
	if victim.stats.current_health < 1:
		victim.model.animation_player.play(victim.melee_death_animation)
		victim.set_collision_layer(0)
		victim.set_collision_mask(0)
	else:
		victim.model.animation_player.play(victim.melee_reaction)
	await agressor.animation_player.animation_finished
	agressor.back_to_main_spot()
	Global.change_phantom_camera(Global.current_combat_scene.main_pcam)
	Global.current_combat_scene.floating_texts()
	await agressor.arrived_at_the_main_spot
	agressor.melee_area.victim_int_id = 69
	agressor.melee_area.is_attacking = false
	#check_is_done.emit()
	status_node.queue_free()
	expired = true
