extends CharacterBody3D
class_name Follower

enum FollowerOrder {
	FIRST,
	SECOND,
	THIRD,
}

enum CharacterClass {
	MONK, #0
	CLERIC, #1
	HACKER, #2
	ROGUE, #3
	TANK, #4
	RANGER #5
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
@export var basic_damage: int = 4
@export var current_health: int = 10
@export var bonds: Array = []

@export_category("Equipment")
@export var melee: InventoryItem = load("res://game/inventory_items/warhammer.tres")
@export var ranged: InventoryItem
@export var shield: InventoryItem
@export var protection: InventoryItem

@export_category("Attributes")
@export var strength: int = 0
@export var dexterity: int = 0
@export var endurance: int = 0
@export var processing: int = 0
@export var memory: int = 0
@export var charisma: int = 0

@onready var navigation_agent_3d = $NavigationAgent3D
@onready var animation_player = $visuals/AnimationPlayer

var is_moving: bool = false
var SPEED: float = 3.5
var target: CharacterBody3D
var destination: Vector3
var is_looking: bool = false

#WeaponContainers
@onready var back_container = $visuals/Armature/Skeleton3D/BackBone/BackContainer
@onready var hips_container = $visuals/Armature/Skeleton3D/HipsBone/HipsContainer


func _process(_delta):
	if is_moving:
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
		
		#var direction = next_location - current_location
		#var target_rotation = atan2(direction.x, -direction.y)
		#rotation.y = lerp_angle(rotation.y, target_rotation, 0.5)

		velocity = new_velocity
		move_and_slide()
		look_at_spot()

	else:
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
	is_moving = true
	#look_at_spot()
	#if body is CharacterBody3D:
		#print("CharacterBody3D exited the area!")
		#print(target.follower_position_three.global_position)

func arrived():
	is_moving = false

func change_equipment():
	var new_weapon
	lose_all_weapons()
	if melee != null:
		new_weapon = melee.model_scene.instantiate()
		if melee.type == 0:
			hips_container.add_child(new_weapon)
		else:
			back_container.add_child(new_weapon)

func lose_all_weapons():
	for n in hips_container.get_children():
		hips_container.remove_child(n)
		n.queue_free()
	for n in back_container.get_children():
		back_container.remove_child(n)
		n.queue_free()
########################################################################################




#Gravity
#var gravity = 15 
##Idle rotation
#var xlocation = randf_range(-360,360)
#var zlocation = randf_range(-360,360)
##Folowing player:
#var is_following: bool = false
##Player escape event
#var player_escape = false
##Face direction of player
#var target = null
#var rot_speed = 0.05
##Map navigation
#@onready var agent: NavigationAgent3D = $NavigationAgent3D
#@onready var animation_player = $visuals/AnimationPlayer
##@onready var target_location: Node = $"../Player"
#var speed = 50
##var minimum_speed = 3
##var idle_speed = rand_range(minimum_speed, speed)
##var move_or_not = [true, false]
##var start_move = move_or_not[randi() % move_or_not.size()]
#
#func _on_area_3d_body_exited(body):
	#target = body
	#rot_speed = 0.1
	#is_following = true
#
##func _on_Area_body_entered(body):
 ##if body.name == ("Player"):
  ##rot_speed = 0.1
  ##harass = true
#
#func _process(delta):
	#if is_following:
		#if target != null:
		##face direction of player
			#animation_player.play("running")
			#var global_pos = self.global_transform.origin
			#var target_pos = target.global_transform.origin
			#var wtransform = self.global_transform.looking_at(Vector3(target_pos.x, global_pos.y, target_pos.z), Vector3.UP)
			#var wrotation = Quaternion(global_transform.basis).slerp(Quaternion(wtransform.basis), rot_speed)
			#self.global_transform = Transform3D(Basis(wrotation), global_pos)
	#
		##Set player location:
		#agent.set_target_position(target.transform.origin)
		##Move to the player
		#var next = agent.get_next_path_position()
		#var velocity = (next - transform.origin).normalized() * speed  * delta
		#move_and_collide(velocity)
	##elif player_escape == false:
		###idle action
		##var global_pos = self.global_transform.origin
		##var wtransform = self.global_transform.looking_at(Vector3(xlocation, global_pos.y, zlocation), Vector3.UP)
		##var wrotation = Quat(global_transform.basis).slerp(Quat(wtransform.basis), rot_speed)
		##self.global_transform = Transform(Basis(wrotation), global_pos)
		##if start_move == true:
		##var velocity = global_transform.basis.z.normalized() * idle_speed * delta
		##move_and_collide(-velocity)
	#elif target != null:
	##enemy looks at player when player escape
		#animation_player.play("idle")
		#var global_pos = self.global_transform.origin
		#var target_pos = target.global_transform.origin
		#var wtransform = self.global_transform.looking_at(Vector3(target_pos.x, global_pos.y, target_pos.z), Vector3.UP)
		#var wrotation = Quaternion(global_transform.basis).slerp(Quaternion(wtransform.basis), rot_speed)
		#self.global_transform = Transform3D(Basis(wrotation), global_pos)
  #
	#if not is_on_floor():
		#move_and_collide(-global_transform.basis.y.normalized() * gravity * delta)
#
##func _on_Area_body_exited(body):
 ##if body.name == ("Player"):
  ##rot_speed = 0.05
  ##harass = false
  ###when player escape enemy wait and look at player
  ##player_escape = true
  ##$Timer2.start()
#
##timer for random looking
##func _on_Timer_timeout():
 ##$Timer.set_wait_time(rand_range(4,8))
 ##xlocation = rand_range(-360,360) 
 ##zlocation = rand_range(-360,360)
 ###random speed of idle move
 ##idle_speed = rand_range(minimum_speed, speed)
 ###enemy will move or just look around
 ##start_move = move_or_not[randi() % move_or_not.size()]
 ##$Timer.start()
#
##func _on_NavigationAgent_velocity_computed(safe_velocity):
	##move_and_collide(safe_velocity)
#
#
#func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	#move_and_collide(safe_velocity)
