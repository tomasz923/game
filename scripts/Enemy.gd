extends CharacterBody3D
class_name Enemy

@onready var visuals = $Visuals
@onready var hexagon_animation_player = $AnimationPlayer
@onready var label_3d = $Label3D
@onready var damage_player = $DamagePlayer

@export var enemy_stats: Resource 
@export var enemy_model: PackedScene
@export var current_health: int
@export var int_id: int 

#Combat Cameras
@onready var combat_camera_left = $CombatCameraLeft
@onready var combat_camera_right = $CombatCameraRight
var is_observing: bool = false

var model
var current_camera: Camera3D
var current_target: CharacterBody3D
var vista_point: Vector3
var main_spot: Vector3
var allys_melee_fight_posiiton: Vector3
var idle_combat_animation: String

func _process(delta):
	if is_observing:
		current_camera.look_at(current_target.global_position)

func get_ready():
	var model_3D = enemy_model.instantiate()
	visuals.add_child(model_3D)
	model = $Visuals/Model
	change_equipment()
	current_health = enemy_stats.max_health
	look_at(vista_point)

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

func set_cameras(target: CharacterBody3D):
	current_target = target
	var to_the_left = combat_camera_left.global_transform.origin.distance_to(target.global_position)
	var to_the_right = combat_camera_right.global_transform.origin.distance_to(target.global_position)
	var minimum_camera_distance = min(to_the_left, to_the_right)
	if to_the_left == minimum_camera_distance:
		current_camera = combat_camera_left
	else:
		current_camera = combat_camera_right
	is_observing = true
	current_camera.current = true
	pass
