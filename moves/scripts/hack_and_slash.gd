extends MoveResource
class_name HackAndSlash

#Necessary Variables And Constants
const MOVE_NAME: String = 'hack_and_slash_move.tres'
const DESCRIPTION: String = 'mv_desc_hack_and_slash'
const IS_HEALING: bool = false
const NEEDS_A_TARGET: bool = true

var damage_dice: Array = []
var damage_bonus: Array = []
var stage: int = 1

#Common vars for all stages
var roll_result: int
var total_damage: int
var local_agressor
var local_victim
var original_agressor_location: Vector3
var original_victim_location: Vector3

#Vars for the stage 0
var bonus_array: Array 
var estimates_array: Array 
var min_estimate: int
var max_estimate: int
var enemy_defence: int = 0

#Vars for the stage 
var attack_animation: String
var victim_react_animation: String
var running_animation: String
var attacker_idle_animation: String

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

func return_estimates(attacker, defender) -> Array:
	estimates_array = []
	
	if defender.enemy_stats.spray != null:
		enemy_defence += defender.enemy_stats.spray.damage_bonus
		
	if defender.enemy_stats.shield != null:
		enemy_defence += defender.enemy_stats.shield.damage_bonus	
	
	if attacker.melee.ignores_protection:
		min_estimate = 1 + attacker.melee.damage_bonus
		max_estimate = attacker.basic_damage + attacker.melee.damage_bonus
	else:
		min_estimate = max(0, (1 + attacker.melee.damage_bonus - max(0, (enemy_defence - attacker.melee.piercing))))
		max_estimate = max(0, (attacker.basic_damage + attacker.melee.damage_bonus - max(0, (enemy_defence - attacker.melee.piercing))))
	
	estimates_array.append(min_estimate)
	estimates_array.append(max_estimate)
	return estimates_array

func execute_the_move(agressor, victim, total_bonus: int):
	original_agressor_location = agressor.global_position
	original_victim_location = victim.global_position
	local_victim = victim
	local_agressor = agressor
	roll_result = 50
	
	#Calculate the standard 2d6 + modifiers
	var dice_one = randi_range(1,6)
	var dice_two = randi_range(1,6)
	roll_result = dice_one + dice_two + total_bonus
	####
	var damage_dice_rolled: int = 0
	var damage_dice_bonus: int = 0
	
	for die in damage_dice:
		var rolled = randi_range(1,die[1])
		damage_dice_rolled += rolled
		
	for bonus in damage_bonus:
		damage_dice_bonus += bonus
		
	var raw_damage: int = damage_dice_rolled + damage_dice_bonus
	
	if local_agressor.melee.ignores_protection:
		total_damage = raw_damage
	else:
		total_damage = max(0, raw_damage - enemy_defence)
	###
	stage = 1
	start_stage_one()

func start_stage_one():
	if stage == 1:
		match local_agressor.melee.type:
			0:
				running_animation = '1h_run_forward'
		#local_victim.model.animation_was_finished.connect(start_stage_two)
		local_victim.someone_is_in_melee_positon.connect(start_stage_two)
		local_agressor.model.victim_reaction_1h_ready.connect(start_stage_three)
		local_victim.model.animation_was_finished.connect(start_stage_four)
		local_agressor.arrived_at_the_main_spot.connect(start_stage_five)
		go_for_melee(running_animation, local_agressor, local_victim)
		Global.current_combat_scene.ui.visible = false
		Global.set_combat_cameras(local_agressor, local_victim)
		stage = 2

func start_stage_two():
	if stage == 2:
		match local_agressor.melee.type:
			0:
				attack_animation = "1h_melee_horizontal"
		local_agressor.is_moving = false
		local_agressor.animation_player.play(attack_animation)
		stage = 3

func start_stage_three():
	if stage == 3:
		match local_victim.enemy_stats.melee.type:
			0:
				victim_react_animation = "1h_react"
		local_victim.model.animation_player.play(victim_react_animation)
		stage = 4
		

func start_stage_four(animation_name):
	if stage == 4 and animation_name == victim_react_animation:
		Global.change_phantom_camera(Global.current_combat_scene.main_pcam)
		local_victim.model.animation_player.play(local_victim.idle_combat_animation)
		local_agressor.back_to_main_spot(running_animation)
		stage = 5

func start_stage_five():
	if stage == 5:
		Global.current_combat_scene.ui.visible = true 
		#Global.current_combat_scene.camera.current = true 
		Global.current_combat_scene.move_finished([roll_result, total_damage], local_victim, local_victim.int_id)
		local_victim.someone_is_in_melee_positon.disconnect(start_stage_two)
		local_agressor.model.victim_reaction_1h_ready.disconnect(start_stage_three)
		local_victim.model.animation_was_finished.disconnect(start_stage_four)
		local_agressor.arrived_at_the_main_spot.disconnect(start_stage_five)
