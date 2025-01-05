extends CharacterBody3D
class_name Follower

signal arrived_at_the_main_spot()

enum FollowerOrder {
	FIRST,
	SECOND,
	THIRD,
}

enum CharacterClass {
	PREACHER, #0
	PROTECTOR, #1
	HACKER, #2
	OPERATIVE, #3
	MILITANT, #4
	SCOUT, #5
	NONE
}

enum SecondBar {
	NONE, #0
	MEMORY, #1
	PROCESSING_CORES #2
}



@export_category("General")
@export var model_tscn: PackedScene
@export var follower_number: FollowerOrder 
@export var follower_name: String 
@export var second_bar_type: SecondBar
@export var character_class: CharacterClass
@export_range(4, 20, 2) var basic_damage: int = 4
@export var current_health: int = 10
@export var protection: int = 0
@export var max_health: int = 10
@export var int_id: int 
#@export var bonds: Array = []
@export var status_effects: Array[Resource] = []
@export var moves: Array = []

@export_category("Equipment")
@export var melee: InventoryItem 
@export var ranged: InventoryItem
@export var shield: InventoryItem
@export var spray: InventoryItem

@export_category("Attributes")
@export var strength: int = 0
@export var dexterity: int = 0
@export var endurance: int = 0
@export var processing: int = 0
@export var memory: int = 0
@export var charisma: int = 0

@onready var visuals = $Visuals
@onready var navigation_agent_3d = $NavigationAgent3D
@onready var combat_pcam_left = $CombatPcams/CombatPcamLeft
@onready var combat_pcam_right = $CombatPcams/CombatPcamRight
var combat_pcam_target: Vector3 
var animation_player 
var model

#Hexagon
@onready var hexagon = $Hexagon
@onready var hexagon_animation_player = $HexagonAnimationPlayer

var is_moving: bool = false
var is_returning_from_melee: bool = false
var SPEED: float = 3.5
var target: CharacterBody3D
var destination: Vector3
var main_spot: Vector3
var is_looking: bool = false
var in_combat: bool = false
var vista_point: Vector3
var idle_combat_animation: String

func _ready():
	var model_3D = model_tscn.instantiate()
	visuals.add_child(model_3D)
	model = $Visuals/Model
	animation_player = model.animation_player
	get_max_health()
	get_protection()

func _process(_delta):
	if is_moving: 
		if !in_combat:
			animation_player.play("run")
			match follower_number:
				0:
					destination = target.follower_position_one.global_position
					update_target_position(destination)
				1:
					destination = target.global_position
					#destination = target.follower_position_two.global_position
					update_target_position(destination)
				2:
					destination = target.follower_position_three.global_position
					update_target_position(destination)
		else:
			combat_pcam_left.look_at(combat_pcam_target)
			combat_pcam_right.look_at(combat_pcam_target)
			
			
		var current_location = global_transform.origin
		var next_location = navigation_agent_3d.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		
		velocity = new_velocity
		move_and_slide()
		look_at_spot(destination)
		
	elif !is_moving and !in_combat:
		animation_player.play("idle")

	if is_returning_from_melee:
		var distance = global_transform.origin.distance_to(main_spot)
		if distance < 0.2:
			arrived_at_the_main_spot.emit()
			is_returning_from_melee = false
			reset_combat_position()
func look_at_spot(target_pos):
	var global_pos = self.global_transform.origin
	var wtransform = self.global_transform.looking_at(Vector3(target_pos.x, global_pos.y, target_pos.z), Vector3.UP)
	var wrotation = Quaternion(global_transform.basis).slerp(Quaternion(wtransform.basis), 0.1)
	self.global_transform = Transform3D(Basis(wrotation), global_pos)

func update_target_position(target_position):
	#var forward_vector = global_transform.basis.z
	#var behind_point = global_transform.origin - forward_vector * distance
	navigation_agent_3d.target_position = target_position

func _on_area_3d_body_exited(body):
	target = body
	if Global.allow_movement:
		is_moving = true

func arrived():
	is_moving = false
	
func get_max_health():
	match endurance:
		-1:
			max_health = 14
		0:
			max_health = 19
		1:
			max_health = 23
		2:
			max_health = 26
		3:
			max_health = 28

func get_protection():
	protection = 2

func change_equipment():
	var new_weapon
	lose_all_weapons()
	if melee != null:
		new_weapon = melee.model_scene.instantiate()
		if melee.type == 0:
			model.hips_container.add_child(new_weapon)
		else:
			model.back_container.add_child(new_weapon)

func lose_all_weapons():
	for n in model.hips_container.get_children():
		model.hips_container.remove_child(n)
		n.queue_free()
	for n in model.back_container.get_children():
		model.back_container.remove_child(n)
		n.queue_free()

func get_in_combat():
	is_moving = false
	in_combat = true
	if ranged == null:
		model.hips_container.visible = false
		match melee.type:
			melee.ItemType.WEAPON_1H:
				model.right_hand_container.visible = true
				var equipped_weapon = melee.model_scene.instantiate()
				for n in model.right_hand_container.get_children():
					model.right_hand_container.remove_child(n)
					n.queue_free()
				model.right_hand_container.add_child(equipped_weapon)
				idle_combat_animation = "1h_idle"
				model.animation_player.play(idle_combat_animation)
	else:
		pass
	look_at(vista_point)

func back_to_main_spot(run_animation_name):
	animation_player.play(run_animation_name)
	is_returning_from_melee = true
	is_moving = true
	destination = main_spot
	update_target_position(destination)

func reset_combat_position():
	is_moving = false
	global_position = main_spot
	look_at(vista_point)
	model.animation_player.play(idle_combat_animation)

