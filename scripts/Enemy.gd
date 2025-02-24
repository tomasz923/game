extends Machine
class_name Enemy

signal someone_is_in_melee_positon()
signal arrived_at_the_main_spot()

@export_category("Enemy")
@export var enemy_stats: EnemyStats 
@export var enemy_model: PackedScene
@export var status_effects: Array[StatusEffect]
@onready var visuals = $Visuals
@onready var hexagon_animation_player = $HexagonAnimationPlayer
@onready var marker_3d = $Marker3D
@onready var combat_pcam_left: PhantomCamera3D = $CombatPcams/CombatPcamLeft
@onready var combat_pcam_right: PhantomCamera3D = $CombatPcams/CombatPcamRight
@onready var staring_point = $StaringPoint
@onready var evade_position_ray = $EvadePositionRay
@onready var melee_area: Area3D = $MeleeArea

var stats: EnemyStats
var speed: float = 3.5
var is_returning: bool = false
# Without this variable, the crashes upon spawning since there is no observee declared yet:
var is_observing: bool = false 
var observee
var combat_pcam_target: Vector3
var agressor_int_id: int = 10

var current_camera_pos: Marker3D
var current_target: CharacterBody3D
var is_counterattacking: bool = false
var counterattack_target: CharacterBody3D

func _ready():
	navigation_agent_3d = $NavigationAgent3D

func _process(_delta):
	if is_moving: 
		var current_location = global_transform.origin
		var next_location = navigation_agent_3d.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * speed
		velocity = new_velocity
		move_and_slide()
		look_at_spot(destination)
		if !is_returning:
			combat_pcam_left.look_at(combat_pcam_target)
			combat_pcam_right.look_at(combat_pcam_target)
	elif is_returning:
		var distance = global_transform.origin.distance_to(main_spot)
		if distance < 0.2:
			arrived_at_the_main_spot.emit()
			is_returning = false
			is_moving = false
			reset_combat_position()
	elif is_observing:
		look_at_spot(observee)

func get_ready():
	# There are issues with local resources so a bit of dancing has to be done
	if stats == null:
		enemy_stats.resource_local_to_scene  = true
		stats = enemy_stats.duplicate(true)
		stats.resource_local_to_scene  = true
		
	var model_3D = enemy_model.instantiate()
	visuals.add_child(model_3D)
	model = $Visuals/Model
	animation_player = model.animation_player
	change_equipment(stats)
	get_in_combat(stats)
	look_at(vista_point)
	model.tween_backward.connect(_on_tween_backward)
	model.tween_forward.connect(_on_tween_forward)
	model.animation_was_finished.connect(_on_animation_was_finished)
	#reset_combat_position()

func _on_animation_was_finished(animation: String):
	pass

func _on_tween_backward():
	back_spot = evade_position_ray.get_collision_point()
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).set_parallel()
	tween.tween_property(self, "global_position", back_spot, 1.1)
	await tween.finished
	tween.stop()
	model.animation_player.play("dodge_forward")

func _on_tween_forward():
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).set_parallel()
	tween.tween_property(self, "global_position", main_spot, 0.98)
	await tween.finished
	tween.stop()
