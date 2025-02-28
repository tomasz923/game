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
var the_victim_died: bool = false
var the_ally_died: bool = false


func check_requirements() -> bool:
	var returned_value: bool
	if Global.shuffled_allies[Global.turn_order].melee != null:
		returned_value = true
	else:
		returned_value = false
	return returned_value
	
func return_roll_modifiers() -> Array:
	bonus_array = []
	
	if Global.shuffled_allies[Global.turn_order].stats.melee.precise:
		bonus_array.append(["cs_dex_long", Global.shuffled_allies[Global.turn_order].stats.dexterity])
	else:
		bonus_array.append(["cs_str_long", Global.shuffled_allies[Global.turn_order].stats.strength])
		
	bonus_array.sort_custom(func(a, b):
		return a[1] < b[1]
	)
	return bonus_array

func return_damage_modifiers(enemy, executioner) -> Array:
	var damage_array = []
	var enemy_prot = []
	damage_dice = []
	
	#Prepare are dice for damage to be rolled
	damage_dice.append(['mvp_dmg_basic_dmg', executioner.stats.basic_damage])
	
	#Add the damage bonuses
	if executioner.stats.melee.damage_bonus > 0:
		damage_bonus.append(['mvp_weapon_dmg', executioner.stats.melee.damage_bonus])
	
	#Adding Ignored Protevtion first
	if Global.shuffled_allies[Global.turn_order].stats.melee.ignores_protection:
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
	if enemy.stats.spray != null:
		var num = '-' + str(enemy.stats.spray.damage_bonus)
		enemy_prot.append(['mvp_dmg_enemy_spray', num])
	if enemy.stats.shield != null:
		var num = '-' + str(enemy.stats.shield.damage_bonus)
		enemy_prot.append(['mvp_dmg_enemy_shield', num])
	for protection in enemy_prot:
		damage_array.append([protection[0], protection[1]])

	return damage_array

func return_estimates(agressor, victim) -> Array:
	estimates_array = []
	
	victim_defence = get_protection(victim.stats)
	agressor_defence = get_protection(agressor.stats)
	
	if agressor.stats.melee.ignores_protection:
		min_estimate = 1 + agressor.stats.melee.damage_bonus
		max_estimate = agressor.stats.basic_damage + agressor.stats.melee.damage_bonus
	else:
		min_estimate = max(0, (1 + agressor.stats.melee.damage_bonus - max(0, (victim_defence - agressor.stats.melee.piercing))))
		max_estimate = max(0, (agressor.stats.basic_damage + agressor.stats.melee.damage_bonus - max(0, (victim_defence - agressor.stats.melee.piercing))))
	
	estimates_array.append(min_estimate)
	estimates_array.append(max_estimate)
	return estimates_array

func execute_the_move(agressor, victim, total_bonus: int):
	Global.current_combat_scene.clickable_enemy_window_node.visible = false
	original_agressor_location = agressor.global_position
	original_victim_location = victim.global_position
	local_victim = victim
	local_agressor = agressor
	roll_result = 69
	
	#Calculate the standard 2d6 + modifiers
	dice_one = randi_range(1,6)
	dice_two = randi_range(1,6)
	roll_result = dice_one + dice_two + total_bonus
	stage = 1
	start_stage_one()

func calculate_attack_damage():
	var damage_dice_rolled: int = 0
	var damage_dice_bonus: int = 0
	var total_attack_damage: int
	
	for die in damage_dice:
		var rolled = randi_range(1, die[1])
		damage_dice_rolled += rolled
		
	for bonus in damage_bonus:
		damage_dice_bonus += bonus
		
	var raw_damage: int = damage_dice_rolled + damage_dice_bonus
	
	if local_agressor.stats.melee.ignores_protection:
		total_attack_damage = raw_damage
	else:
		total_attack_damage = max(1, raw_damage - victim_defence)
	
	local_victim.stats.current_health -= total_attack_damage
	if local_victim.stats.current_health <= 0:
		the_victim_died = true
		local_agressor.stats.aggro += 1
		
	Global.current_combat_scene.statuses_and_damage.append(["damage", local_victim, total_attack_damage])

func calculate_counterattack_damage():
	var raw_damage: int = randi_range(1, local_victim.stats.basic_damage) + local_victim.stats.melee.damage_bonus
	var total_counterattack_damage: int
	if local_agressor.stats.melee.ignores_protection:
		total_counterattack_damage = raw_damage
	else:
		total_counterattack_damage = max(1, raw_damage - agressor_defence)
	
	local_agressor.stats.current_health -= total_counterattack_damage
	if local_agressor.stats.current_health <= 0:
		the_ally_died = true
	Global.current_combat_scene.statuses_and_damage.append(["damage", local_agressor, total_counterattack_damage])

func start_stage_one():
	if stage == 1:
		the_victim_died = false
		the_ally_died = false
		random_result = 1 #randi_range(0, 1)
		Global.get_spots(local_victim)
		Global.get_spots(local_agressor, "main")
		local_victim.melee_area.someone_is_in_melee_positon.connect(start_stage_two)
		local_agressor.model.melee_reaction_ready.connect(start_stage_three)
		local_victim.model.animation_was_finished.connect(start_stage_four)
		local_victim.look_at(local_agressor.global_position)
		local_victim.observee = local_agressor.global_position
		local_victim.is_observing = true
		go_for_melee(local_agressor, local_victim)
		Global.current_combat_scene.ui.visible = false
		Global.set_melee_cameras(local_victim, local_agressor)
		Global.switch_cursor_visibility(false)
		stage = 2

func start_stage_two():
	if stage == 2:
		local_agressor.is_moving = false
		local_agressor.animation_player.play(local_agressor.melee_animation)
		local_victim.melee_area.someone_is_in_melee_positon.disconnect(start_stage_two)
		stage = 3

func start_stage_three(is_evading):
	if stage == 3:
		if roll_result > 6 and !is_evading:
			local_agressor.model.melee_reaction_ready.disconnect(start_stage_three)
			set_dice(dice_one, dice_two, roll_result, false)
			if roll_result > 9:
				Global.switch_cursor_visibility(true)
				Global.current_combat_scene.stop_animations(true)
				Global.current_combat_scene.popup_window.option_was_chosen.connect(start_stage_three_success)
				Global.current_combat_scene.popup_window.prepare_window("mvp_extra_dmg_hns_pop_label", "mvp_extra_dmg_hns_pop_text", ["mvp_extra_dmg_hns_pop_yes", "mvp_extra_dmg_hns_pop_no"])
			else:
				start_stage_three_partial_success()
		elif roll_result < 7 and is_evading:
			local_agressor.model.melee_reaction_ready.disconnect(start_stage_three)
			local_victim.model.animation_player.play("dodge_backward")
			set_dice(dice_one, dice_two, roll_result, false)
			start_stage_three_fail()

func start_stage_three_success(choice: int):
	Global.switch_cursor_visibility(false)
	deal_more_dmg_on_succ = choice
	Global.current_combat_scene.popup_window.option_was_chosen.disconnect(start_stage_three_success)
	Global.current_combat_scene.stop_animations(false)
	match choice:
		0:
			damage_dice.append(['mvp_dmg_basic_dmg', 6])
		1:
			pass
	calculate_attack_damage()
	#Global.current_combat_scene.slow_motion()
	Global.current_combat_scene.show_the_dice(roll_result)
	if local_victim.stats.current_health < 1:
		local_victim.model.animation_player.play(local_victim.melee_death_animation)
		local_agressor.model.animation_was_finished.connect(start_stage_five)
		stage = 5
	else:
		local_victim.model.animation_player.play(local_victim.melee_reaction)
		stage = 4

func start_stage_three_partial_success():
	set_dice(dice_one, dice_two, roll_result, true)
	calculate_attack_damage()
	#Global.current_combat_scene.slow_motion()
	if local_victim.stats.current_health < 1:
		local_victim.model.animation_player.play(local_victim.melee_death_animation)
		local_agressor.model.animation_was_finished.connect(start_stage_five)
		stage = 5
	else:
		local_victim.model.animation_player.play(local_victim.melee_reaction)
		stage = 4

func start_stage_three_fail():
	Global.current_combat_scene.show_the_dice(roll_result)
	#Global.current_combat_scene.slow_motion()
	stage = 4

func start_stage_four(animation_name):
	if stage == 4 and animation_name == local_victim.melee_reaction:
		local_victim.model.melee_reaction_ready.connect(start_stage_four_aux_counterattack)
		local_victim.model.animation_player.play(local_victim.melee_animation)
		if roll_result > 9:
			current_counterattack_variable = deal_more_dmg_on_succ
		else:
			current_counterattack_variable = 0
	elif stage == 4 and animation_name == "dodge_forward":
		local_victim.model.melee_reaction_ready.connect(start_stage_four_aux_counterattack)
		local_victim.model.animation_player.play(local_victim.melee_animation)
		current_counterattack_variable = random_result
		
func start_stage_four_aux_counterattack(_is_evading):
	if !_is_evading and current_counterattack_variable == 0:
		stage = 5
		calculate_counterattack_damage()
		local_victim.model.melee_reaction_ready.disconnect(start_stage_four_aux_counterattack)
		if the_ally_died:
			local_agressor.model.animation_player.play(local_agressor.melee_death_animation)
			local_agressor.set_collision_layer(0)
			local_agressor.set_collision_mask(0)
			start_stage_five(null)
		else:
			local_agressor.model.animation_player.play(local_victim.melee_reaction)
			local_agressor.model.animation_was_finished.connect(start_stage_five)
		
	if _is_evading and current_counterattack_variable != 0:
		agressor_animation = "dodge_backward"
		Global.get_spots(local_agressor, "back")
		local_agressor.model.animation_player.play(agressor_animation)
		local_victim.model.melee_reaction_ready.disconnect(start_stage_four_aux_counterattack)
		local_agressor.model.animation_was_finished.connect(start_stage_five)
		if roll_result < 7:
			local_victim.status_effects.append(SePreparingToAttack.new())
		stage = 5

func start_stage_five(anim_name):
	if stage == 5:
		stage = 6
		if !the_ally_died:
			local_agressor.model.animation_was_finished.disconnect(start_stage_five)
		Global.change_phantom_camera(Global.current_combat_scene.main_pcam)
		Global.current_combat_scene.floating_texts()
		if !the_victim_died:
			local_victim.model.animation_player.queue(local_victim.idle_melee_animation)
			local_victim.observee = local_victim.vista_point
		if !the_ally_died:
			local_agressor.back_to_main_spot()
			local_agressor.arrived_at_the_main_spot.connect(start_stage_six)
		else:
			start_stage_six()

func start_stage_six():
	if stage == 6:
		Global.current_combat_scene.check_for_victory()
		local_victim.agressor_int_id = 69
		local_victim.model.animation_was_finished.disconnect(start_stage_four)
		if !the_ally_died:
			local_agressor.arrived_at_the_main_spot.disconnect(start_stage_six)
