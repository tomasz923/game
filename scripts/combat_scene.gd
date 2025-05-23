extends Node3D
class_name CombatScene

signal combat_was_triggerred(combat_name: String)
signal all_status_effects_checked()

@export_category("General")
@export var combat_title: String
@export var combat_description: String
# is_a_trap is not used anywhere for now.
@export var is_a_trap: bool = false
@export var has_3d_zone: bool = true
@export var collision_dome_radius: float = 6.0

@export_category("Rewards")
@export var supplies: int = 0
@export var credits: int = 0
@export var items: Array[InventoryItem] = []
var experience: int = 0

# The make mixing 3D models and skills easier, these are seperated into two files and mereged
# later on during spawn_enemies()
@export_category("Enemy Models")
@export var first_enemy_model: PackedScene
@export var second_enemy_model: PackedScene
@export var third_enemy_model: PackedScene
@export var fourth_enemy_model: PackedScene
@export var fifth_enemy_model: PackedScene
@export var sixth_enemy_model: PackedScene

@export_category("Enemy Statistics")
@export var first_enemy_stats: EnemyStats
@export var second_enemy_stats: EnemyStats
@export var third_enemy_stats: EnemyStats
@export var fourth_enemy_stats: EnemyStats
@export var fifth_enemy_stats: EnemyStats
@export var sixth_enemy_stats: EnemyStats

# CLICKABLE WINDOWS
@onready var blacks: Control = $Blacks
@onready var clickable_enemy_windows_container = $ClickableEnemyWindowNode/ClickableEnemyWindowsContainer
@onready var clickable_enemy_window_node = $ClickableEnemyWindowNode
const CLICKABLE_WINDOW = preload("res://game/scenes/clickable_window.tscn")
const STATUS_WINDOW = preload("res://game/status_window.tscn")

# AREA 3D
@onready var danger_zone = $DangerZone
@onready var collision_dome = $DangerZone/CollisionDome
@onready var main_pcam = $MainPcam

# FRIENDLY RAYS
@onready var friendly_first_ray = $Allies/FriendlyFirstRay
@onready var friendly_second_ray = $Allies/FriendlySecondRay
@onready var friendly_third_ray = $Allies/FriendlyThirdRay
@onready var friendly_fourth_ray = $Allies/FriendlyFourthRay
const NEW_ENEMY_SCENE = preload("res://game/scenes/enemy.tscn")

var friendly_rays: Array = []
var all_allies: Array = []

# ENEMY POSITIONS
@onready var even_enemy_rays = $EvenEnemyRays
@onready var odd_enemy_rays = $OddEnemyRays
@onready var enemies_in_combat = $EnemiesInCombat
@onready var enemy_vistas = $EnemyVistas
@onready var allies_vistas = $AlliesVistas

# UI
@onready var allies_ui = $UI/Allies
@onready var enemies_ui = $UI/Enemies
@onready var ui = $UI
@onready var moves_panel = $UI/MovesPanel
const CHARACTER_COMBAT_WINDOW = preload("res://game/scenes/ally_combat_window.tscn")
const ENEMY_COMBAT_WINDOW = preload("res://game/scenes/enemy_combat_window.tscn")
const MOVE_CHOICE_BUTTON = preload("res://game/scenes/move_choice_button.tscn")
const BONUS_LABEL = preload("res://game/scenes/move_bonus_label.tscn")

# COMABT PIPELINE
var all_machines: Array = []
var current_move
var looking_for_target: bool = true
var total_bonus: int = 0
var enemy_num: int = 0
var allies_skipped: int = 0
# An element of the statuses_and_damage has to look like this 
# [type: String, machine: Machine, value: int]
var statuses_and_damage: Array = [] 

# DICE AND POP UP WINDOWS
@onready var popup_window = $PopupWindow
@onready var left_die: Control = $Dice/LeftDie
@onready var right_die: Control = $Dice/RightDie
@onready var dice = $Dice
var prob_table: Array = [
	[2, 2.78],
	[3, 5.56],
	[4, 8.33],
	[5, 11.11],
	[6, 13.89],
	[7, 16.66],
	[8, 13.89],
	[9, 11.11],
	[10, 8.33],
	[11, 5.56],
	[12, 2.78]
]

@export_category("Moves")
#Basic Moves (temporary)
@export var basic_moves_array: Array[Resource]

func _ready():
	# The array with friendly rays has to be created at the initiation, so other functions can work.
	friendly_rays = [friendly_first_ray, friendly_second_ray, friendly_third_ray, friendly_fourth_ray]
	collision_dome.shape.radius = collision_dome_radius
	if !is_a_trap:
		danger_zone.visible = false

func trigger_combat():
	Global.current_scene.screen_transiton.the_screen_is_covered.connect(start_combat)
	Global.current_scene.screen_transiton.start_combat(combat_title, combat_description)
	Global.allow_movement = false

func start_combat():
	# So if the player enters the combat while altering visuals roation by A, S or D, it looks correct in combat now:
	Global.current_scene.hero.visuals.rotation = Vector3(0, 0, 0)
	Global.allow_movement = false
	Global.change_phantom_camera(main_pcam, 0.0)
	Global.turn_order = -1
	Global.current_combat_scene = self
	ui.visible = true
	clickable_enemy_window_node.visible = true
	all_allies = [
		Global.current_scene.hero, 
		Global.current_scene.follower_one, 
		Global.current_scene.follower_two, 
		Global.current_scene.follower_three
		]
	assign_allied_slots()
	spawn_enemies()
	initiate_next_turn()

func assign_allied_slots():
	var ally_window
	var vista_points: Array = []
	Global.shuffled_allies = all_allies
	Global.shuffled_allies.shuffle()
	
	for marker in allies_vistas.get_children():
		vista_points.append(marker)
		
	for i in len(all_allies):
		all_allies[i].arrived()
		var current_ray = friendly_rays[i]
		all_allies[i].main_spot = current_ray.get_collision_point()
		all_allies[i].int_id = i
		all_allies[i].stats.aggro = 0
		all_allies[i].vista_point = vista_points[i].global_position
		all_allies[i].get_in_combat(all_allies[i].stats)
		
		ally_window = CHARACTER_COMBAT_WINDOW.instantiate()
		ally_window.name = "view_" + str(i)
		allies_ui.add_child(ally_window)
		
		var node_to_change = get_node("UI/Allies/" + "view_" + str(i))
		node_to_change.name_label.text = all_allies[i].stats.ally_name
		node_to_change.health_value.text = str(all_allies[i].stats.current_health)
		node_to_change.health_bar.value = all_allies[i].stats.current_health * 100
		node_to_change.health_bar.max_value = all_allies[i].stats.max_health * 100
		if all_allies[i].stats.spray == null:
			node_to_change.protection_value.text = "0"
		else:
			node_to_change.protection_value.text = str(all_allies[i].stats.spray)

func _on_danger_zone_body_entered(body):
	if body is Hero:
		Global.allow_movement = false
		get_tree().call_group("Ally", "unsheath_weapon")
		await body.model.weapon_unsheathed
		trigger_combat()

func spawn_enemies():
	var enemy_statistics: Array = [first_enemy_stats, second_enemy_stats, third_enemy_stats, fourth_enemy_stats, fifth_enemy_stats, sixth_enemy_stats]
	var enemy_models: Array = [first_enemy_model, second_enemy_model, third_enemy_model, fourth_enemy_model, fifth_enemy_model, sixth_enemy_model]
	var clickable_windows_ids: Array = []
	var vista_points: Array = []
	var rays_node
	var rays: Array = []
	
	for enemy in enemy_statistics:
		if enemy != null:
			enemy_num += 1
	
	if enemy_num % 2 == 0:
		enemy_vistas.position.z = 0
		rays_node = even_enemy_rays
		remove_child(odd_enemy_rays)
		odd_enemy_rays.queue_free() 
	else:
		enemy_vistas.position.z = -1
		rays_node = odd_enemy_rays
		remove_child(even_enemy_rays)
		even_enemy_rays.queue_free() 
	
	for marker in enemy_vistas.get_children():
		vista_points.append(marker)
		
	for i in enemy_num:
		if i % 2 == 0:
			clickable_windows_ids.append(i)
		else:
			clickable_windows_ids.push_front(i)
	
	for ray in rays_node.get_children():
		rays.append(ray)
	
	for i in enemy_num:
		var new_enemy = NEW_ENEMY_SCENE.instantiate()
		var current_ray = rays[i]
		var enemy_window
		var clickable_window
		var enemy_defence: int = 0
		
		new_enemy.name = "enemy_" + str(i)
		new_enemy.enemy_stats = enemy_statistics[i]
		new_enemy.enemy_model = enemy_models[i]
		new_enemy.vista_point = vista_points[i].global_position
		new_enemy.int_id = i
		
		enemies_in_combat.add_child(new_enemy)
		var node_to_change = get_node("EnemiesInCombat/" + "enemy_" + str(i))
		node_to_change.global_position = current_ray.get_collision_point()
		node_to_change.main_spot = current_ray.get_collision_point()
		#print("BEFORE")
		#print(node_to_change.get_rotation())
		#print(node_to_change.visuals.get_rotation())
		node_to_change.get_ready()
		#node_to_change.is_observing = true
		#node_to_change.observee = csg_box_3d.global_position
		#print("AFTER")
		#print(node_to_change.get_rotation())
		#print(node_to_change.visuals.get_rotation())
		#print(node_to_change.model.get_rotation())
		#print("-------------------------------------------------------")

		
		#Calculate Enemy Protection
		if new_enemy.stats.spray != null:
			enemy_defence += new_enemy.stats.spray.damage_bonus
		
		if new_enemy.stats.shield != null:
			enemy_defence += new_enemy.stats.shield.damage_bonus
		
		#Create UI elements
		enemy_window = ENEMY_COMBAT_WINDOW.instantiate()
		enemy_window.name = "view_" + str(i)
		enemies_ui.add_child(enemy_window)
		
		node_to_change = get_node("UI/Enemies/" + "view_" + str(i))
		if i % 2 != 0:
			enemies_ui.move_child(node_to_change, 0)
		#else:
			#clickable_windows_ids.push_front(i)
		node_to_change.name_label.text = enemy_statistics[i].enemy_name.capitalize()
		node_to_change.health_value.text = str(enemy_statistics[i].current_health)
		node_to_change.health_bar.max_value = enemy_statistics[i].max_health * 100
		node_to_change.health_bar.value = enemy_statistics[i].current_health * 100
		node_to_change.protection_value.text = str(enemy_defence)
		
		clickable_window = CLICKABLE_WINDOW.instantiate()
		clickable_window.target_int_id = clickable_windows_ids[i]
		clickable_window.text = str(clickable_windows_ids[i])
		clickable_window.name = 'enemy_window_' + str(clickable_windows_ids[i])
		clickable_window.target_was_highlighted.connect(_on_enemy_was_highlighted)
		clickable_window.target_was_abandoned.connect(_on_enemy_was_abandoned)
		clickable_window.target_was_chosen.connect(_on_target_was_chosen)
		clickable_enemy_windows_container.add_child(clickable_window)
		

func initiate_next_turn():
	#Declaring variables
	var character_window_to_change
	
	#Changes to the ending character before moving on
	Global.shuffled_allies[Global.turn_order].hexagon.visible = false
	if Global.turn_order > -1:
		character_window_to_change = get_node("UI/Allies/" + "view_" + str(Global.turn_order))
		character_window_to_change.active_triangle.visible = false
		
	#Changing number of the current turn
	if Global.turn_order > 2:
		Global.turn_order = 0
	else:
		Global.turn_order += 1
	
	# Check if the player lost
	while Global.shuffled_allies[Global.turn_order].stats.current_health < 1:
		allies_skipped += 1
		
		if allies_skipped > 4:
			Global.current_scene.screen_transiton.game_over()
			return
		
		if Global.turn_order > 2:
			Global.turn_order = 0
		else:
			Global.turn_order += 1
			
	allies_skipped = 0
	#Changes to the current character
	character_window_to_change = get_node("UI/Allies/" + "view_" + str(Global.turn_order))
	character_window_to_change.active_triangle.visible = true
	Global.shuffled_allies[Global.turn_order].hexagon.visible = true ###
	Global.shuffled_allies[Global.turn_order].hexagon_animation_player.play("hexagon_pulsating") ###
	
	# Clear the old moves
	for n in moves_panel.even.get_children():
		moves_panel.even.remove_child(n)
		n.queue_free() 
	for n in moves_panel.odd.get_children():
		moves_panel.odd.remove_child(n)
		n.queue_free() 

	# Load the moves
	var even_or_odd: int = 0
	for move in basic_moves_array:
		var new_move_choice = MOVE_CHOICE_BUTTON.instantiate()
		new_move_choice.move = move
		new_move_choice.text = move.MOVE_NAME
		new_move_choice.forward_move_data.connect(_on_forward_move_data)
		even_or_odd += 1
		if even_or_odd % 2 == 0:
			moves_panel.even.add_child(new_move_choice)
		else:
			moves_panel.odd.add_child(new_move_choice)
	return true

func _on_forward_move_data(move: Resource, bonus_array: Array):
	var new_container
	var success_prob: float = 0.0
	var failure_prob: float = 0.0
	var complication_prob: float = 0.0
	total_bonus = 0
	
	current_move = move
	if Global.user_prefs.mvp_right_panel_visible:
		moves_panel._on_show_right_panel_button_pressed()
	if Global.user_prefs.mvp_left_panel_visible:
		moves_panel._on_show_left_panel_button_pressed()
	moves_panel.scroll_container.visible = false
	moves_panel.move_info.visible = true
	moves_panel.choose_move_label.visible = false
	moves_panel.buttons_container.visible = true
	moves_panel.moves_name.text = move.MOVE_NAME
	moves_panel.description.text = move.DESCRIPTION
	
	for bonus in bonus_array:
		if bonus[1] != 0:
			new_container = HBoxContainer.new()
			new_container.alignment = BoxContainer.ALIGNMENT_CENTER
			create_bonus_number(bonus[1], new_container)
			create_bonus_description(bonus[0], new_container)
			moves_panel.bonuses.add_child(new_container)
	
	for bonus in bonus_array:
		total_bonus += bonus[1]
	
	for row in prob_table:
		if row[0] + total_bonus > 9:
			success_prob += row[1]
		elif row[0] + total_bonus < 7:
			failure_prob += row[1]
		else:
			complication_prob += row[1]
	
	moves_panel.show_chances(failure_prob, complication_prob, success_prob, total_bonus)

func create_bonus_number(number: int, container: HBoxContainer):
	var bonus_label: BonusLabel = BONUS_LABEL.instantiate()
	if int(number) > 0:
		bonus_label.text = "+" + str(number)
	else:
		bonus_label.text = str(number)
	bonus_label.bonus_number(true)
	#bonus_label.add_theme_font_size_override("font_size", 8)
	container.add_child(bonus_label)

func create_bonus_damage(number: String, container: HBoxContainer):
	var bonus_label: BonusLabel = BONUS_LABEL.instantiate()
	bonus_label.text = number
	bonus_label.bonus_number(true)
	#bonus_label.add_theme_font_size_override("font_size", 8)
	container.add_child(bonus_label)

func create_bonus_description(description: String, container: HBoxContainer):
	var bonus_label: BonusLabel = BONUS_LABEL.instantiate()
	bonus_label.text = description
	bonus_label.bonus_description(true)
	#bonus_label.add_theme_font_size_override("font_size", 8)
	container.add_child(bonus_label)

func _on_enemy_was_highlighted(target_int_id):
	if current_move != null and looking_for_target and current_move.NEEDS_A_TARGET:
		var enemy = get_node("EnemiesInCombat/" + "enemy_" + str(target_int_id))
		var window = get_node("UI/Enemies/" + "view_" + str(target_int_id))
		enemy.hexagon_animation_player.play("hexagon_pulsating")
		window.active_triangle.visible = true
		Global.shuffled_allies[Global.turn_order].hexagon_animation_player.play("RESET")
		show_estimated_dmg_or_heal(enemy)
		
		var damage_modifiers = current_move.return_damage_modifiers(enemy, Global.shuffled_allies[Global.turn_order])
		for modifier in damage_modifiers:
			var new_container = HBoxContainer.new()
			new_container.alignment = BoxContainer.ALIGNMENT_CENTER
			create_bonus_damage(modifier[1], new_container)
			create_bonus_description(modifier[0], new_container)
			moves_panel.damages.add_child(new_container)

func _on_enemy_was_abandoned(target_int_id):
	if current_move != null and current_move.NEEDS_A_TARGET:
		var enemy = get_node("EnemiesInCombat/" + "enemy_" + str(target_int_id))
		var window = get_node("UI/Enemies/" + "view_" + str(target_int_id))
		enemy.hexagon_animation_player.play("RESET")
		window.active_triangle.visible = false
		Global.shuffled_allies[Global.turn_order].hexagon_animation_player.play("hexagon_pulsating")
		hide_estimated_dmg_or_heal()
		

func _on_target_was_chosen(target_int_id):
	if current_move != null and current_move.NEEDS_A_TARGET:
		var enemy = get_node("EnemiesInCombat/" + "enemy_" + str(target_int_id))
		current_move.execute_the_move(Global.shuffled_allies[Global.turn_order], enemy, total_bonus)
		looking_for_target = false

func show_estimated_dmg_or_heal(target):
	var estimates_array: Array
	moves_panel.extra_move_info_damage.visible = true
	if current_move.IS_HEALING:
		moves_panel.expected_damage_string.text = 'mvp_exp_heal_label'
	else:
		moves_panel.expected_damage_string.text = 'mvp_exp_dmg_label'
	
	estimates_array = current_move.return_estimates(Global.shuffled_allies[Global.turn_order], target)
	moves_panel.expected_damage_value.text = str(estimates_array[0]) + ' - ' + str(estimates_array[1])

func hide_estimated_dmg_or_heal():
	moves_panel.clear_damages()
	moves_panel.extra_move_info_damage.visible = false

func move_finished():
	await check_status_effects()
	Global.switch_cursor_visibility(true)
	ui.visible = true 
	clickable_enemy_window_node.visible = true
	update_combat_windows()
	# Check if any data was changed:
	for ally in Global.shuffled_allies:
		var window = get_node("UI/Allies/" + "view_" + str(ally.int_id))
		window.aggro_value.text = str(ally.stats.aggro)
	current_move = null
	looking_for_target = true
	initiate_next_turn()
	moves_panel._on_go_back_button_pressed()

func show_the_dice(result):
	dice.visible = true
	var tween = create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	# First tween
	tween.tween_property(left_die, "position:y", 92.0, 0.3)
	# Chain second tween after first completes
	tween.tween_callback(func(): return true)
	tween.tween_interval(0.2)
	tween.tween_property(right_die, "position:y", 92.0, 0.3)
	await tween.finished
	color_the_dice(result)
	await get_tree().create_timer(0.3).timeout
	hide_the_dice()

func hide_the_dice():
	var tween = create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	# First tween
	tween.tween_property(left_die, "position:y", 276.0, 0.3)
	# Add 0.2 second delay
	tween.tween_callback(func(): return true)
	tween.tween_interval(0.2)
	# Second tween
	tween.tween_property(right_die, "position:y", 276.0, 0.3)
	await tween.finished
	dice.modulate = 'WHITE'
	right_die.position.y = -92
	left_die.position.y = -92
	dice.visible = false

func color_the_dice(result):
	if result > 9:
		dice.modulate = '#55927f'
	elif result < 7:
		dice.modulate = '#dc6250'
	else:
		dice.modulate = '#eeb24a'
	dice.visible = true

func slow_motion():
	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN).set_parallel()
	tween.tween_property(Engine, "time_scale", 1.0, 0.3).from(0.1)

func stop_animations(is_pausing: bool):
	for enemy in enemies_in_combat.get_children():
		if is_pausing:
			enemy.model.animation_player.speed_scale = 0 
		else:
			enemy.model.animation_player.speed_scale = 1
	for ally in all_allies:
		if is_pausing:
			ally.model.animation_player.speed_scale = 0 
		else:
			ally.model.animation_player.speed_scale = 1

func check_status_effects():
	if all_machines == []:
		var enemies_array = enemies_in_combat.get_children()
		all_machines = enemies_array + Global.shuffled_allies
	for machine in all_machines:
		if machine.stats.current_health > 0:
			var window
			if machine is Enemy:
				window = get_node("UI/Enemies/" + "view_" + str(machine.int_id))
			else:
				window = get_node("UI/Allies/" + "view_" + str(machine.int_id))
			machine.status_effects = machine.status_effects.filter(func(status): return status.expired == false)
			for status in machine.status_effects:
				if status.was_initiated == false:
					var new_status_window = STATUS_WINDOW.instantiate()
					var status_container = window.status_effects_container
					status_container.add_child(new_status_window)
					#?????
					status.initiate_status(status_container.get_child(status_container.get_child_count()-1), machine)
				else:
					await status.check_status()
	return true

func check_for_victory():
	var there_are_still_enemies: bool = false
	var there_are_still_allies: bool = false
	for i in enemy_num:
		var enemy = get_node("EnemiesInCombat/" + "enemy_" + str(i))
		if enemy.stats.current_health > 0:
			there_are_still_enemies = true
	for ally in Global.shuffled_allies:
		if ally.stats.current_health > 0:
			there_are_still_allies = true
	if !there_are_still_enemies:
		Global.current_scene.screen_transiton.combat_won(experience, supplies, credits, items)
	elif !there_are_still_allies:
		Global.current_scene.screen_transiton.game_over()
	else:
		move_finished()

func floating_texts():
	for i in len(statuses_and_damage):
		var element = statuses_and_damage.pop_back()
		match element[0]:
			"damage":
				element[1].model.floating_number.show_damage(element[2])
			"heal":
				pass
			"status":
				element[1].model.floating_text.show_status(element[2])

func update_combat_windows():
	for enemy in enemies_in_combat.get_children():
		var window = get_node("UI/Enemies/" + "view_" + str(enemy.int_id))
		if enemy.stats.current_health != window.health_bar.value * 100:
			var healthbar_tween = get_tree().create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT).set_parallel()
			var current_value: int = window.health_bar.value
			window.health_value.text = str(max(0, enemy.stats.current_health))
			healthbar_tween.tween_property(window.health_bar, "value", enemy.stats.current_health * 100, 0.8).from(current_value)
			if enemy.stats.current_health < 1: 
				window.hide_window()
				var clickable_window = get_node("ClickableEnemyWindowNode/ClickableEnemyWindowsContainer/enemy_window_" + str(enemy.int_id))
				clickable_window.disabled = true
	for ally in Global.shuffled_allies:
		var window = get_node("UI/Allies/" + "view_" + str(ally.int_id))
		if ally.stats.current_health != window.health_bar.value * 100:
			var healthbar_tween = get_tree().create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT).set_parallel()
			var current_value: int = window.health_bar.value
			window.health_value.text = str(max(0, ally.stats.current_health))
			healthbar_tween.tween_property(window.health_bar, "value", ally.stats.current_health * 100, 0.8).from(current_value)
			if ally.stats.current_health < 1: 
				window.hide_window()
