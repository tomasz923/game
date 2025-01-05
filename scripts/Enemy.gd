extends CharacterBody3D
class_name Enemy

signal someone_is_in_melee_positon()

@onready var visuals = $Visuals
@onready var hexagon_animation_player = $AnimationPlayer
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
#var is_observing: bool = false
var agressor_int_id: int

var model
var current_camera_pos: Marker3D
var current_target: CharacterBody3D
var vista_point: Vector3
var main_spot: Vector3
var idle_combat_animation: String

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

func reset_combat_position():
	global_position = main_spot
	look_at(vista_point)
	model.animation_player.play(idle_combat_animation)

func _on_melee_area_body_entered(body):
	if body is Follower or body is Player: 
		if body.int_id == agressor_int_id:
			someone_is_in_melee_positon.emit()
			body.is_moving = false
