extends MoveResource
class_name HackAndSlash

#Necessary Variables And Constants
const MOVE_NAME: String = 'hack_and_slash_move.tres'
const DESCRIPTION: String = 'mv_desc_hack_and_slash'
const IS_HEALING: bool = false
const NEEDS_A_TARGET: bool = true

var damage_dice: Array = []
var damage_bonus: Array = []
var dice_one: int
var dice_two: int
var stage: int = 1

#Common vars for all stages
var roll_result: int
var total_attack_damage: int
var total_counterattack_damage: int
var local_agressor
var local_victim
var original_agressor_location: Vector3
var original_victim_location: Vector3

# To reduce the number of functions, current_counterattack_variable was created.
# It takes the value of random result on the failure
# and deal_more_dmg_on_succ
var deal_more_dmg_on_succ: int
var random_result: int
var current_counterattack_variable: int

#Vars for the stage 0
var bonus_array: Array 
var estimates_array: Array 
var min_estimate: int
var max_estimate: int
var victim_defence: int 
var agressor_defence: int 

#Vars for the stage 
var agressor_animation: String
var victim_animation: String
var running_animation: String
var attacker_idle_animation: String
var the_victim_died: bool


func check_requirements() -> bool:
	var returned_value: bool
	if Global.shuffled_allies[Global.turn_order].melee != null:
		returned_value = true
	else:
		returned_value = false
	return returned_value
	
func return_roll_modifiers() -> Array:
	bonus_array = []
	
	if Global.shuffled_allies[Global.turn_order].melee.precise:
		bonus_array.append(["cs_dex_long", Global.shuffled_allies[Global.turn_order].dexterity])
	else:
		bonus_array.append(["cs_str_long", Global.shuffled_allies[Global.turn_order].strength])
		
	bonus_array.sort_custom(func(a, b):
		return a[1] < b[1]
	)
	return bonus_array

func return_damage_modifiers(enemy, executioner) -> Array:
	var damage_array = []
	var enemy_prot = []
	damage_dice = []
	
	#Prepare are dice for damage to be rolled
	damage_dice.append(['mvp_dmg_basic_dmg', executioner.basic_damage])
	
	#Add the damage bonuses
	if executioner.melee.damage_bonus > 0:
		damage_bonus.append(['mvp_weapon_dmg', executioner.melee.damage_bonus])
	
	#Adding Ignored Protevtion first
	if Global.shuffled_allies[Global.turn_order].melee.ignores_protection:
		damage_array.append(['mvp_dmg_ignored_prot', '++'])
	
	#Adding dice next
	damage_dice.sort_custom(func(a, b):
		return a[1] < b[1]
	)
	for die in damage_dice:
		var num: String = '+1k' + str(die[1])
		damage_array.append([die[0], num])
		
	#Adding bonsues next
	damage_bonus.sort_custom(func(a, b):
		return a[1] < b[1]
	)
	for bonus in damage_bonus:
		var num: String 
		if bonus[1] > 0:
			num = '+' + str(bonus[1])
		damage_array.append([bonus[0], num])

	#Adding enemy's protection next
	if enemy.enemy_stats.spray != null:
		var num = '-' + str(enemy.enemy_stats.spray.damage_bonus)
		enemy_prot.append(['mvp_dmg_enemy_spray', num])
	if enemy.enemy_stats.shield != null:
		var num = '-' + str(enemy.enemy_stats.shield.damage_bonus)
		enemy_prot.append(['mvp_dmg_enemy_shield', num])
	for protection in enemy_prot:
		damage_array.append([protection[0], protection[1]])

	return damage_array

func return_estimates(agressor, victim) -> Array:
	estimates_array = []
	
	victim_defence = get_protection(victim.enemy_stats)
	agressor_defence = get_protection(agressor)
	
	if agressor.melee.ignores_protection:
		min_estimate = 1 + agressor.melee.damage_bonus
		max_estimate = agressor.basic_damage + agressor.melee.damage_bonus
	else:
		min_estimate = max(0, (1 + agressor.melee.damage_bonus - max(0, (victim_defence - agressor.melee.piercing))))
		max_estimate = max(0, (agressor.basic_damage + agressor.melee.damage_bonus - max(0, (victim_defence - agressor.melee.piercing))))
	
	estimates_array.append(min_estimate)
	estimates_array.append(max_estimate)
	return estimates_array

func execute_the_move(agressor, victim, total_bonus: int):
	Global.current_combat_scene.clickable_enemy_window_node.visible = false
	original_agressor_location = agressor.global_position
	original_victim_location = victim.global_position
	local_victim = victim
	local_agressor = agressor
	roll_result = 50
	
	#Calculate the standard 2d6 + modifiers
	dice_one = randi_range(1,6)
	dice_two = randi_range(1,6)
	roll_result = dice_one + dice_two + total_bonus
	print("hack n slash debug: the roll is: " + str(roll_result))
	stage = 1
	start_stage_one()

func calculate_damage():
	var damage_dice_rolled: int = 0
	var damage_dice_bonus: int = 0
	
	for die in damage_dice:
		var rolled = randi_range(1,die[1])
		damage_dice_rolled += rolled
		
	for bonus in damage_bonus:
		damage_dice_bonus += bonus
		
	var raw_damage: int = damage_dice_rolled + damage_dice_bonus
	
	if local_agressor.melee.ignores_protection:
		total_attack_damage = raw_damage
	else:
		total_attack_damage = max(0, raw_damage - victim_defence)
	
	local_victim.current_health -= total_attack_damage
	if local_victim.current_health <= 0:
		the_victim_died = true

func calculate_counterattack_damage():
	var raw_damage: int = randi_range(1, local_victim.enemy_stats.basic_damage) + local_victim.enemy_stats.melee.damage_bonus
	

func start_stage_one():
	if stage == 1:
		the_victim_died = false
		random_result = randi_range(0, 1)
		Global.get_spots(local_victim)
		Global.get_spots(local_agressor, "main")
		match local_agressor.melee.type:
			0:
				running_animation = '1h_run_forward'
		#local_victim.model.animation_was_finished.connect(start_stage_two)
		local_victim.someone_is_in_melee_positon.connect(start_stage_two)
		local_agressor.model.melee_reaction_ready.connect(start_stage_three)
		local_victim.model.animation_was_finished.connect(start_stage_four)
		#local_victim.look_at_spot(local_agressor.global_position)
		#local_agressor.look_at_spot(local_victim.global_position)
		local_victim.observee = local_agressor.global_position
		local_victim.is_observing = true
		go_for_melee(running_animation, local_agressor, local_victim)
		Global.current_combat_scene.ui.visible = false
		Global.set_combat_cameras(local_agressor, local_victim)
		stage = 2

func start_stage_two():
	if stage == 2:
		match local_agressor.melee.type:
			0:
				agressor_animation = "1h_melee_horizontal"
		local_agressor.is_moving = false
		local_agressor.animation_player.play(agressor_animation)
		local_victim.someone_is_in_melee_positon.disconnect(start_stage_two)
		stage = 3

func start_stage_three(is_evading):
	if stage == 3:
		if roll_result > 9 and !is_evading:
			print("hack and slash debug: victory")
			Global.current_combat_scene.stop_animations(true)
			set_dice(dice_one, dice_two, roll_result, false)
			Global.current_combat_scene.popup_window.option_was_chosen.connect(start_stage_three_success)
			Global.current_combat_scene.popup_window.prepare_window("mvp_extra_dmg_hns_pop_label", "mvp_extra_dmg_hns_pop_text", ["mvp_extra_dmg_hns_pop_yes", "mvp_extra_dmg_hns_pop_no"])
			local_agressor.model.melee_reaction_ready.disconnect(start_stage_three)
		#elif roll_result < 7:
		elif roll_result < 7 and is_evading:
			print("hack and slash debug: failure")
			local_victim.model.animation_player.play("dodge_backward")
			# next steps
		#elif:
			#print("hack and slash debug: partial")
			#start_stage_three_partial_success()
			#local_agressor.model.melee_reaction_ready.disconnect(start_stage_three)

func start_stage_three_success(choice: int):
	deal_more_dmg_on_succ = choice
	Global.current_combat_scene.popup_window.option_was_chosen.disconnect(start_stage_three_success)
	Global.current_combat_scene.stop_animations(false)
	match choice:
		0:
			damage_dice.append(['mvp_dmg_basic_dmg', 6])
		1:
			pass
	calculate_damage()
	match local_victim.enemy_stats.melee.type:
		0:
			if the_victim_died:
				victim_animation = "1h_bow_death"
			else:
				victim_animation = "1h_react"
	Global.current_combat_scene.slow_motion()
	Global.current_combat_scene.show_the_dice(roll_result)
	local_victim.model.animation_player.play(victim_animation)
	stage = 4

func start_stage_three_partial_success():
	set_dice(dice_one, dice_two, roll_result, true)
	victim_animation = "dodge_forward"
	Global.current_combat_scene.slow_motion()
	stage = 4

func start_stage_four(animation_name):
	if stage == 4 and animation_name == victim_animation:
		local_victim.model.melee_reaction_ready.connect(start_stage_four_aux_counterattack)
		# TODO: Add correct attack animation of the victim that depends on the inventory:
		local_victim.model.animation_player.play("1h_melee_horizontal")
		current_counterattack_variable = deal_more_dmg_on_succ
		if roll_result > 9:
			current_counterattack_variable = deal_more_dmg_on_succ
		else:
			current_counterattack_variable = random_result
		
func start_stage_four_aux_counterattack(_is_evading):
	if !_is_evading and current_counterattack_variable == 0:
		# TODO: Finish this for ohter weapons (in progress)
		match local_victim.enemy_stats.melee.type:
			0:
				agressor_animation = "1h_react"
		local_agressor.model.animation_player.play(agressor_animation)
		local_victim.model.melee_reaction_ready.disconnect(start_stage_four_aux_counterattack)
		local_agressor.model.animation_was_finished.connect(start_stage_five)
		stage = 5
	if _is_evading and current_counterattack_variable != 0:
		agressor_animation = "dodge_backward"
		Global.get_spots(local_agressor, "back")
		local_agressor.model.animation_player.play(agressor_animation)
		local_victim.model.melee_reaction_ready.disconnect(start_stage_four_aux_counterattack)
		local_agressor.model.animation_was_finished.connect(start_stage_five)
		stage = 5

func start_stage_five(animation_name):
	if stage == 5 and (roll_result > 9 or (roll_result < 10 and animation_name == agressor_animation)):
		Global.change_phantom_camera(Global.current_combat_scene.main_pcam)
		if !the_victim_died:
			local_victim.model.animation_player.play(local_victim.idle_combat_animation)
		local_agressor.back_to_main_spot(running_animation)
		local_victim.observee = local_victim.vista_point
		local_agressor.arrived_at_the_main_spot.connect(start_stage_six)
		#local_agressor.model.animation_was_finished.disconnect(start_stage_five)
		stage = 6

func start_stage_six():
	if stage == 6:
		Global.current_combat_scene.ui.visible = true 
		Global.current_combat_scene.clickable_enemy_window_node.visible = true
		Global.current_combat_scene.move_finished([roll_result, total_attack_damage], local_victim, local_victim.int_id)
		local_victim.model.animation_was_finished.disconnect(start_stage_four)
		local_agressor.arrived_at_the_main_spot.disconnect(start_stage_six)
