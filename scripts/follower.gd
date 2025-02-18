extends Ally
class_name Follower

signal arrived_at_the_main_spot()

enum FollowerOrder {
	FIRST,
	SECOND,
	THIRD,
}
@export_category("Follower")
@export var model_tscn: PackedScene
@export var follower_number: FollowerOrder


@onready var visuals = $Visuals
@onready var combat_pcam_left = $CombatPcams/CombatPcamLeft
@onready var combat_pcam_right = $CombatPcams/CombatPcamRight
@onready var evade_position_ray = $EvadePositionRay
@onready var floating_number = $FloatingNumber
@onready var floating_text = $FloatingText
var combat_pcam_target: Vector3 

#Hexagon
@onready var hexagon = $Hexagon
@onready var hexagon_animation_player = $HexagonAnimationPlayer


var target: CharacterBody3D
var is_looking: bool = false

func _ready():
	var model_3D = model_tscn.instantiate()
	visuals.add_child(model_3D)
	model = $Visuals/Model
	animation_player = model.animation_player
	navigation_agent_3d = $NavigationAgent3D
	ensure_ally_stats()
	change_equipment(stats)
	model.tween_backward.connect(_on_tween_backward)

func debugg():
	pass

func _process(delta):
	if is_moving: 
		if !is_in_combat:
			if animation_player.current_animation != "run":
				animation_player.play("run")
			match follower_number:
				0:
					destination = target.follower_position_one.global_position
					update_target_position(destination)
				1:
					destination = target.global_position
					update_target_position(destination)
				2:
					destination = target.follower_position_three.global_position
					update_target_position(destination)
		else:
			combat_pcam_left.look_at(combat_pcam_target)
			combat_pcam_right.look_at(combat_pcam_target)
			
		var direction: Vector3
		direction = navigation_agent_3d.get_next_path_position() - global_position
		direction = direction.normalized()
		velocity = velocity.lerp(direction * Global.save_state["current_exploration_speed"], 10 * delta)
		move_and_slide()
		
		#var current_location = global_transform.origin
		#var next_location = navigation_agent_3d.get_next_path_position()
		#var new_velocity = (next_location - current_location).normalized() * Global.save_state["current_exploration_speed"]
		#velocity = new_velocity
		#move_and_slide()
		
		#if global_transform.origin.distance_to(main_spot) < 0.2:
			#global_position = main_spot
			#look_at_spot(vista_point)
			#is_moving = false
			#animation_player.play_backwards("1h_sheath")
			#animation_player.queue("1h_idle")
		#else: 
		look_at_spot(destination)
			
	elif !is_moving and !is_in_combat and animation_player.current_animation != "idle":
		if !ready_for_combat:
			animation_player.play("idle")
		else:
			animation_player.play_backwards("1h_sheath")
			ready_for_combat = false
			is_in_combat = true

	if is_returning_from_melee:
		var distance = global_transform.origin.distance_to(main_spot)
		if distance < 0.2:
			arrived_at_the_main_spot.emit()
			is_returning_from_melee = false
			reset_combat_position()

func update_target_position(target_position):
	#var forward_vector = global_transform.basis.z
	#var behind_point = global_transform.origin - forward_vector * distance
	navigation_agent_3d.target_position = target_position

func _on_area_3d_body_exited(body):
	if !debug:
		target = body
		if Global.allow_movement:
			is_moving = true

func lose_all_weapons():
	for n in model.hips_container.get_children():
		model.hips_container.remove_child(n)
		n.queue_free()
	for n in model.back_container.get_children():
		model.back_container.remove_child(n)
		n.queue_free()
