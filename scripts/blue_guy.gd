extends CharacterBody3D
class_name Follower

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
@export var follower_number: FollowerOrder 
@export var follower_name: String 
@export var second_bar_type: SecondBar
@export var character_class: CharacterClass
@export_range(4, 20, 2) var basic_damage: int = 4
@export var current_health: int = 10
@export var protection: int = 0
@export var max_health: int = 10
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

@onready var model = $Visuals/Model
@onready var navigation_agent_3d = $NavigationAgent3D
@onready var animation_player = model.animation_player

#Hexagon
@onready var hexagon = $Hexagon
@onready var hexagon_animation_player = $AnimationPlayer

var is_moving: bool = false
var SPEED: float = 3.5
var target: CharacterBody3D
var destination: Vector3
var is_looking: bool = false
var in_combat: bool = false

func _ready():
	get_max_health()
	get_protection()

func _process(_delta):
	if is_moving and !in_combat:
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
			
			
		var current_location = global_transform.origin
		var next_location = navigation_agent_3d.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		

		velocity = new_velocity
		move_and_slide()
		look_at_spot()

	elif !is_moving and !in_combat:
		animation_player.play("idle")

func look_at_spot():
	#pass
	var global_pos = self.global_transform.origin
	#var target_pos = target.global_transform.origin
	var target_pos = destination
	var wtransform = self.global_transform.looking_at(Vector3(target_pos.x, global_pos.y, target_pos.z), Vector3.UP)
	var wrotation = Quaternion(global_transform.basis).slerp(Quaternion(wtransform.basis), 0.1)
	self.global_transform = Transform3D(Basis(wrotation), global_pos)
	## Get the current rotation
	#var start_rotation = global_rotation
	## Make the object look at the player immediately (to calculate target rotation)
	#match FollowerNumber:
		#0:
			#look_at(target.view_one.global_position)
		#1:
			#look_at(target.global_position)
		#2:
			#look_at(target.view_three.global_position)
	## Store the target rotation
	#var target_rotation = global_rotation
	## Reset to start rotation
	#global_rotation = start_rotation
	### Create a tween to smoothly rotate to the target
	##tween.stop_all()  # Stop any existing tweens
	#var tween = create_tween()
	#tween.tween_property(self, "global_rotation", target_rotation, 1).set_trans(Tween.TRANS_LINEAR)

func update_target_position(target_position):
	#var forward_vector = global_transform.basis.z
	#var behind_point = global_transform.origin - forward_vector * distance
	navigation_agent_3d.target_position = target_position

func _on_area_3d_body_exited(body):
	target = body
	if Global.allow_movement:
		is_moving = true
	#look_at_spot()
	#if body is CharacterBody3D:
		#print("CharacterBody3D exited the area!")
		#print(target.follower_position_three.global_position)

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
				model.animation_player.play("1h_idle")
	else:
		pass
