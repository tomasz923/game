extends Node3D

signal combat_was_triggerred(combat_name: String)

@export_category("General")
@export var combat_id: String
@export var is_a_trap: bool = false
@export var has_3d_zone: bool = true
@export var collision_dome_radius: float = 6.0
@export var number_of_enemies: int

@export_category("Enemy Models")
@export var first_enemy_model: PackedScene
@export var second_enemy_model: PackedScene
@export var third_enemy_model: PackedScene
@export var fourth_enemy_model: PackedScene
@export var fifth_enemy_model: PackedScene
@export var sixth_enemy_model: PackedScene

@export_category("Enemy Statistics")
@export var first_enemy_stats: Resource
@export var second_enemy_stats: Resource
@export var third_enemy_stats: Resource
@export var fourth_enemy_stats: Resource
@export var fifth_enemy_stats: Resource
@export var sixth_enemy_stats: Resource

#CLICKABLE WINDOWS
@onready var clickable_enemy_windows_container = $ClickableEnemyWindow/ClickableEnemyWindowsContainer
const CLICKABLE_WINDOW = preload("res://game/scenes/clickable_window.tscn")

#AREA 3D
@onready var danger_zone = $DangerZone
@onready var collision_dome = $DangerZone/CollisionDome
@onready var camera = $Camera

#FRIENDLY RAYS
@onready var friendly_first_ray = $Allies/FriendlyFirstRay
@onready var friendly_second_ray = $Allies/FriendlySecondRay
@onready var friendly_third_ray = $Allies/FriendlyThirdRay
@onready var friendly_fourth_ray = $Allies/FriendlyFourthRay
const NEW_ENEMY_SCENE = preload("res://game/scenes/enemy.tscn")

var friendly_rays: Array = []
var all_allies: Array = []

#ENEMY POSITIONS
@onready var even_enemy_rays = $EvenEnemyRays
@onready var odd_enemy_rays = $OddEnemyRays
@onready var enemies_in_combat = $EnemiesInCombat
@onready var enemy_vistas = $EnemyVistas
@onready var allies_vistas = $AlliesVistas
@onready var even_ally_stand_points = $AllyStandPoints/EvenAllyStandPoints
@onready var odd_ally_stand_points = $AllyStandPoints/OddAllyStandPoints


#UI
@onready var allies_ui = $UI/Allies
@onready var enemies_ui = $UI/Enemies
@onready var ui = $UI
@onready var clickable_enemy_window = $ClickableEnemyWindow
@onready var moves_panel = $UI/MovesPanel
const CHARACTER_COMBAT_WINDOW = preload("res://game/scenes/character_combat_window.tscn")
const ENEMY_COMBAT_WINDOW = preload("res://game/scenes/enemy_combat_window.tscn")
const MOVE_CHOICE_BUTTON = preload("res://game/scenes/move_choice_button.tscn")
const BONUS_LABEL = preload("res://game/scenes/move_bonus_label.tscn")
#var vista_ponts: Array = [
	#[0, $EnemyVistas/Marker1], 
	#[1, $EnemyVistas/Marker2], 
	#[2, $EnemyVistas/Marker3],
	#[3, $EnemyVistas/Marker4],
	#[4, $EnemyVistas/Marker5],
	#[5, $EnemyVistas/Marker6]
	#]

#Combat Pipeline
var current_move
var total_bonus: int = 0
var enemy_num: int = 0
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
#Basic Moves
@export var basic_moves_array: Array[Resource]

func _ready():
	friendly_rays = [friendly_first_ray, friendly_second_ray, friendly_third_ray, friendly_fourth_ray]
	collision_dome.shape.radius = collision_dome_radius
	if !is_a_trap:
		danger_zone.visible = false

func trigger_combat():
	Global.turn_order = -1
	Global.current_combat_scene = self
	Global.cursors_visible_in_game = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	ui.visible = true
	clickable_enemy_window.visible = true
	camera.current = true
	all_allies = [Global.hero_character, Global.first_character, Global.second_character, Global.third_character]
	Global.allow_movement = false
	#combat_was_triggerred.emit(combat_id)
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
		#all_allies[i].arrived()
		var current_ray = friendly_rays[i]
		all_allies[i].position = current_ray.get_collision_point()
		all_allies[i].main_spot = current_ray.get_collision_point()
		all_allies[i].int_id = i
		all_allies[i].vista_point = vista_points[i].global_position
		all_allies[i].get_in_combat()
		
		ally_window = CHARACTER_COMBAT_WINDOW.instantiate()
		ally_window.name = "view_" + str(i)
		allies_ui.add_child(ally_window)
		
		var node_to_change = get_node("UI/Allies/" + "view_" + str(i))
		node_to_change.name_label.text = all_allies[i].follower_name
		node_to_change.health_value.text = str(all_allies[i].current_health)
		node_to_change.health_bar.value = all_allies[i].current_health
		node_to_change.health_bar.max_value = all_allies[i].max_health
		node_to_change.protection_value.text =str(all_allies[i].protection)

func _on_danger_zone_body_entered(_body):
	trigger_combat()

func spawn_enemies():
	var enemy_statistics: Array = [first_enemy_stats, second_enemy_stats, third_enemy_stats, fourth_enemy_stats, fifth_enemy_stats, sixth_enemy_stats]
	var enemy_models: Array = [first_enemy_model, second_enemy_model, third_enemy_model, fourth_enemy_model, fifth_enemy_model, sixth_enemy_model]
	var clickable_windows_ids: Array = []
	var vista_points: Array = []
	var rays_node
	var ally_stand_points_node
	var rays: Array = []
	var ally_stand_points: Array = []
	
	for enemy in enemy_statistics:
		if enemy != null:
			enemy_num += 1
	
	for marker in enemy_vistas.get_children():
		vista_points.append(marker)
	
	if enemy_num % 2 == 0:
		rays_node = even_enemy_rays
		ally_stand_points_node = even_ally_stand_points
		remove_child(odd_enemy_rays)
		odd_enemy_rays.queue_free() 
		#remove_child(odd_ally_stand_points)
		#odd_ally_stand_points.queue_free() 
	else:
		rays_node = odd_enemy_rays
		ally_stand_points_node = odd_ally_stand_points
		remove_child(even_enemy_rays)
		even_enemy_rays.queue_free() 
		#remove_child(even_ally_stand_points)
		#even_ally_stand_points.queue_free() 
	
	for i in enemy_num:
		if i % 2 == 0:
			clickable_windows_ids.append(i)
		else:
			clickable_windows_ids.push_front(i)
	
	for ray in rays_node.get_children():
		rays.append(ray)
	
	for ray in ally_stand_points_node.get_children():
		ally_stand_points.append(ray)
	
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
		node_to_change.allys_melee_fight_posiiton = ally_stand_points[i].get_collision_point()
		node_to_change.get_ready()
		
		#Calculate Enemy Protection
		if new_enemy.enemy_stats.spray != null:
			enemy_defence += new_enemy.enemy_stats.spray.damage_bonus
		
		if new_enemy.enemy_stats.shield != null:
			enemy_defence += new_enemy.enemy_stats.shield.damage_bonus
		
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
		node_to_change.health_value.text = str(enemy_statistics[i].max_health)
		node_to_change.health_bar.max_value = enemy_statistics[i].max_health * 100
		node_to_change.health_bar.value = enemy_statistics[i].max_health * 100
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
	
	#Changes to the current character
	character_window_to_change = get_node("UI/Allies/" + "view_" + str(Global.turn_order))
	character_window_to_change.active_triangle.visible = true
	Global.shuffled_allies[Global.turn_order].hexagon.visible = true
	Global.shuffled_allies[Global.turn_order].hexagon_animation_player.play("hexagon_pulsating")
	
	#Clear the old moves
	for n in moves_panel.even.get_children():
		moves_panel.even.remove_child(n)
		n.queue_free() 
	for n in moves_panel.odd.get_children():
		moves_panel.odd.remove_child(n)
		n.queue_free() 

	#Load the moves
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
	if current_move != null and current_move.NEEDS_A_TARGET:
		var enemy = get_node("EnemiesInCombat/" + "enemy_" + str(target_int_id))
		enemy.hexagon_animation_player.play("hexagon_pulsating")
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
		enemy.hexagon_animation_player.play("RESET")
		Global.shuffled_allies[Global.turn_order].hexagon_animation_player.play("hexagon_pulsating")
		hide_estimated_dmg_or_heal()
		

func _on_target_was_chosen(target_int_id):
	if current_move != null and current_move.NEEDS_A_TARGET:
		var enemy = get_node("EnemiesInCombat/" + "enemy_" + str(target_int_id))
		current_move.execute_the_move(Global.shuffled_allies[Global.turn_order], enemy, total_bonus)

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

func deal_damage_or_heal(is_healing: bool, value: int, height: float, spread: float, start_pos: Vector3, source, window_int: int):
	source.label_3d.text = str(value)
	
	if is_healing:
		pass
	else:
		source.damage_player.play("show_damage")
		
	var number_tween = get_tree().create_tween()
	var end_pos = Vector3(randf_range(-spread, spread), 2+height, 0) 
	var tween_length = source.damage_player.get_animation("show_damage").length
	number_tween.tween_property(source.label_3d, "position", end_pos, tween_length).from(start_pos)
		
	var healthbar_tween = get_tree().create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT).set_parallel()
	var window = get_node("UI/Enemies/" + "view_" + str(window_int))
	var current_value: int = window.health_bar.value
	var new_value: int
	if is_healing:
		pass
	else:
		new_value = current_value -  value * 100
		window.health_value.text = str(max(0, new_value/100))
		healthbar_tween.tween_property(window.health_bar, "value", new_value, 0.8).from(current_value)
		if new_value < 1:
			print(clickable_enemy_windows_container.get_children())
			var clickable_window = get_node("ClickableEnemyWindow/ClickableEnemyWindowsContainer/enemy_window_" + str(window_int))
			clickable_window.disabled = true

func move_finished(results, enemy, target_int_id):
		deal_damage_or_heal(current_move.IS_HEALING, results[1], 0.8, 1.0, Vector3(0,2,0), enemy, target_int_id)
		current_move = null
		enemy.hexagon_animation_player.play("RESET")
		initiate_next_turn()
		moves_panel._on_go_back_button_pressed()
