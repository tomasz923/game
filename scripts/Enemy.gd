extends CharacterBody3D
class_name Enemy

signal someone_is_in_melee_positon()
signal arrived_at_the_main_spot()

@onready var visuals = $Visuals
@onready var hexagon_animation_player = $HexagonAnimationPlayer
@onready var label_3d = $Label3D
@onready var damage_player = $DamagePlayer
@onready var melee_area = $MeleeArea

@export var enemy_stats: Resource 
@export var enemy_model: PackedScene
@export var current_health: int
@export var int_id: int 

#Combat Cameras
@onready var combat_pcam_left = $CombatPcams/CombatPcamLeft
@onready var combat_pcam_right = $CombatPcams/CombatPcamRight
@onready var staring_point = $StaringPoint
@onready var evade_position = $EvadePosition
@onready var navigation_agent_3d = $NavigationAgent3D
var is_moving: bool = false
var speed: float = 3.5
var destination: Vector3
var is_returning: bool = false
var combat_pcam_target: Vector3
#var is_observing: bool = false
var agressor_int_id: int = 10

var model
var current_camera_pos: Marker3D
var current_target: CharacterBody3D
var vista_point: Vector3
var main_spot: Vector3
var idle_combat_animation: String
var is_counterattacking: bool = false
var counterattack_target: CharacterBody3D

func _process(_delta):
	if is_moving: #and !in_combat
		var current_location = global_transform.origin
		var next_location = navigation_agent_3d.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * speed
		
		velocity = new_velocity
		move_and_slide()
		look_at_spot(destination)
		if !is_returning:
			combat_pcam_left.look_at(combat_pcam_target)
			combat_pcam_right.look_at(combat_pcam_target)
		
	if is_returning:
		var distance = global_transform.origin.distance_to(main_spot)
		if distance < 0.2:
			arrived_at_the_main_spot.emit()
			is_returning = false
			is_moving = false
			reset_combat_position(false)
			#if is_counterattacking:
				#is_counterattacking = false
				#counterattack_stage_two()

func look_at_spot(target_pos: Vector3):
	#var global_pos = self.global_transform.origin
	#var wtransform = self.global_transform.looking_at(Vector3(target_pos.x, global_pos.y, target_pos.z), Vector3.UP)
	var global_pos = self.global_transform.origin
	var wtransform = self.global_transform.looking_at(Vector3(target_pos.x, global_pos.y, target_pos.z), Vector3.UP)
	var wrotation = Quaternion(global_transform.basis).slerp(Quaternion(wtransform.basis), 0.1)
	self.global_transform = Transform3D(Basis(wrotation), global_pos)

func get_ready():
	var model_3D = enemy_model.instantiate()
	visuals.add_child(model_3D)
	model = $Visuals/Model
	change_equipment()
	current_health = enemy_stats.max_health
	look_at(vista_point)
	model.animation_was_finished.connect(_on_animation_was_finished)

func change_equipment():
	if enemy_stats.ranged == null:
		model.hips_container.visible = false
		match enemy_stats.melee.type:
			enemy_stats.melee.ItemType.WEAPON_1H:
				model.right_hand_container.visible = true
				var equipped_weapon = enemy_stats.melee.model_scene.instantiate()
				model.right_hand_container.add_child(equipped_weapon)
				idle_combat_animation = "1h_idle"
	else:
		pass
	model.animation_player.play(idle_combat_animation)
	#var new_weapon
	#if enemy_stats.melee != null:
		#for n in model.hips_container.get_children():
			#model.hips_container.remove_child(n)
			#n.queue_free()
		#for n in model.back_container.get_children():
			#model.back_container.remove_child(n)
			#n.queue_free()
		#new_weapon = enemy_stats.melee.model_scene.instantiate()
		#
		#if enemy_stats.melee.type == 0:
			#model.hips_container.add_child(new_weapon)
		#else:
			#model.back_container.add_child(new_weapon)

func reset_combat_position(done_fighting: bool = true):
	global_position = main_spot
	if done_fighting:
		look_at_spot(vista_point)
		model.animation_player.play(idle_combat_animation)

func _on_melee_area_body_entered(body):
	if body is Follower or body is Player: 
		if body.int_id == agressor_int_id:
			someone_is_in_melee_positon.emit()
			body.is_moving = false
	if body is Follower or body is Player:
		print(body.is_moving)

func counterattack_stage_one():
	global_position = evade_position.get_collision_point()
	model.animation_player.play("dodge_forward")

func _on_animation_was_finished(animation: String):
	if animation == "dodge_forward":
		var counterattack_animation: String
		match enemy_stats.melee.type:
			0:
				counterattack_animation = "1h_melee_horizontal"
		model.animation_player.play(counterattack_animation)

#func counterattack_stage_two():
	#var counterattack_animation: String
	#match enemy_stats.melee.type:
		#0:
			#counterattack_animation = "1h_melee_horizontal"
	#model.animation_player.play(counterattack_animation)
