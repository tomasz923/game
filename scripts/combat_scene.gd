extends Node3D

signal combat_was_triggerred(combat_name: String)

@export_category("General")
@export var combat_id: String
@export var is_a_trap: bool = false
@export var collision_dome_radius: float = 6.0

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
var first_enemy
var second_enemy
var third_enemy
var fourth_enemy
var fifth_enemy
var sixth_enemy

var all_enemies: Array = [first_enemy, second_enemy, third_enemy, fourth_enemy, fifth_enemy, sixth_enemy]
var friendly_rays: Array = []
var all_allies: Array = []

#ENEMY POSITIONS
@onready var even_enemies_rays = $EvenEnemiesRays
@onready var odd_enemies_rays = $OddEnemiesRays
@onready var enemies_in_combat = $EnemiesInCombat

#UI
@onready var allies_ui = $UI/Allies
@onready var enemies_ui = $UI/Enemies
@onready var ui = $UI
@onready var moves_panel = $UI/MovesPanel
const CHARACTER_COMBAT_WINDOW = preload("res://game/scenes/character_combat_window.tscn")
const ENEMY_COMBAT_WINDOW = preload("res://game/scenes/enemy_combat_window.tscn")
const MOVE_CHOICE_BUTTON = preload("res://game/scenes/move_choice_button.tscn")
const BONUS_LABEL = preload("res://game/scenes/move_bonus_label.tscn")

#Combat Pipeline
var current_move
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
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	ui.visible = true
	camera.current = true
	all_allies = [Global.hero_character, Global.first_character, Global.second_character, Global.third_character]
	Global.allow_movement = false
	#combat_was_triggerred.emit(combat_id)
	assign_allied_slots()
	spawn_enemies()
	initiate_next_turn()

func assign_allied_slots():
	var ally_window
	Global.shuffled_allies = all_allies
	Global.shuffled_allies.shuffle()
	for i in len(all_allies):
		#all_allies[i].arrived()
		var current_ray = friendly_rays[i]
		all_allies[i].position = current_ray.get_collision_point()
		all_allies[i].int_id = i
		all_allies[i].look_at(current_ray.get_collision_point() + Vector3(6.0, 0.0, 0.0))
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

	
	var enemy_num: int = 0
	var rays_parent_node: Node3D
	var rays: Array = []
	
	for enemy in enemy_statistics:
		if enemy != null:
			enemy_num += 1
	
	if enemy_num % 2 == 0:
		rays_parent_node = even_enemies_rays
	else:
		rays_parent_node = odd_enemies_rays
	
	rays_parent_node.visible = true
	for ray in rays_parent_node.get_children():
		rays.append(ray)
	
	for i in enemy_num:
		var new_enemy = NEW_ENEMY_SCENE.instantiate()
		var current_ray = rays[i]
		var enemy_window
		
		new_enemy.name = "enemy_" + str(i)
		new_enemy.enemy_stats = enemy_statistics[i]
		new_enemy.enemy_model = enemy_models[i]
		new_enemy.int_id = i 
		
		enemies_in_combat.add_child(new_enemy)
		var node_to_change = get_node("EnemiesInCombat/" + "enemy_" + str(i))
		node_to_change.global_position = current_ray.get_collision_point()
		node_to_change.look_at(current_ray.get_collision_point() + Vector3(6.0, 0.0, 0.0))
		node_to_change.get_ready()
		
		#Create UI elements
		enemy_window = ENEMY_COMBAT_WINDOW.instantiate()
		enemy_window.name = "view_" + str(i)
		enemies_ui.add_child(enemy_window)
		
		node_to_change = get_node("UI/Enemies/" + "view_" + str(i))
		node_to_change.name_label.text = enemy_statistics[i].enemy_name.capitalize()
		node_to_change.health_value.text = str(enemy_statistics[i].max_health)
		node_to_change.health_bar.value = enemy_statistics[i].max_health
		node_to_change.health_bar.max_value = enemy_statistics[i].max_health
		node_to_change.protection_value.text =str(enemy_statistics[i].protection)

func initiate_next_turn():
	#Declaring variables
	var character_window_to_change
	
	#Changes to the ending character before moving on
	Global.shuffled_allies[Global.turn_order].hexagon.visible = false
	if Global.turn_order > -1:
		character_window_to_change = get_node("UI/Allies/" + "view_" + str(Global.turn_order))
		character_window_to_change.active_triangle.visible = false
		
	#Changing number of the current turn
	elif Global.turn_order > 2:
		Global.turn_order = 0
	else:
		Global.turn_order += 1
	
	#Changes to the current character
	character_window_to_change = get_node("UI/Allies/" + "view_" + str(Global.turn_order))
	character_window_to_change.active_triangle.visible = true
	Global.shuffled_allies[Global.turn_order].hexagon.visible = true
	Global.shuffled_allies[Global.turn_order].hexagon_animation_player.play("hexagon_pulsating")
	
	#Load the moves
	var even_or_odd: int = 0
	for move in basic_moves_array:
		var new_move_choice = MOVE_CHOICE_BUTTON.instantiate()
		new_move_choice.move = move
		new_move_choice.text = move.move_name
		new_move_choice.forward_move_data.connect(_on_forward_move_data)
		even_or_odd += 1
		if even_or_odd % 2 == 0:
			moves_panel.even.add_child(new_move_choice)
		else:
			moves_panel.odd.add_child(new_move_choice)

func _on_forward_move_data(move: Resource, bonus_array: Array):
	var new_container
	var total_bonus: int = 0
	var success_prob: float = 0.0
	var failure_prob: float = 0.0
	var complication_prob: float = 0.0
	
	current_move = move
	if Global.user_prefs.mvp_right_panel_visible:
		moves_panel._on_show_right_panel_button_pressed()
	if Global.user_prefs.mvp_left_panel_visible:
		moves_panel._on_show_left_panel_button_pressed()
	moves_panel.scroll_container.visible = false
	moves_panel.move_info.visible = true
	moves_panel.choose_move_label.visible = false
	moves_panel.buttons_container.visible = true
	moves_panel.moves_name.text = move.move_name
	moves_panel.description.text = move.description
	
	for bonus in bonus_array:
		new_container = HBoxContainer.new()
		new_container.alignment = BoxContainer.ALIGNMENT_CENTER
		create_bonus_number(bonus[1], new_container)
		create_bonus_description(bonus[0], new_container)
		moves_panel.bonuses.add_child(new_container)
	
	for bonus in bonus_array:
		total_bonus += bonus[1]
	
	var debug_int: float = 0.0
	for row in prob_table:
		debug_int += row[1]
	print(debug_int)
	
	for row in prob_table:
		if row[0] + total_bonus > 9:
			success_prob += row[1]
		elif row[0] + total_bonus < 7:
			failure_prob += row[1]
		else:
			complication_prob += row[1]
	
	moves_panel.show_chances(failure_prob, complication_prob, success_prob)
	print('DEBUG Raw probabilities: ')
	print(failure_prob, complication_prob, success_prob)

func create_bonus_number(number: int, container: HBoxContainer):
	var bonus_label: BonusLabel = BONUS_LABEL.instantiate()
	if int(number) > 0:
		bonus_label.text = "+" + str(number)
	else:
		bonus_label.text = str(number)
	bonus_label.bonus_number(true)
	#bonus_label.add_theme_font_size_override("font_size", 8)
	container.add_child(bonus_label)

func create_bonus_description(description: String, container: HBoxContainer):
	var bonus_label: BonusLabel = BONUS_LABEL.instantiate()
	bonus_label.text = description
	bonus_label.bonus_description(true)
	#bonus_label.add_theme_font_size_override("font_size", 8)
	container.add_child(bonus_label)
	
	#Check for existing sttaus effects
	#for status in Global.shuffled_allies[turn_order].status_effects:
		#if status != null and status.has_method("trigger_effect"):
			#status.trigger_effect(Global.shuffled_allies[turn_order])
