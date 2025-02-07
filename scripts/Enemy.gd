extends Machine
class_name Enemy

signal someone_is_in_melee_positon()
signal arrived_at_the_main_spot()

@export_category("Enemy")
@export var enemy_stats: Resource 
@export var enemy_model: PackedScene
@export var current_health: int
@onready var visuals = $Visuals
@onready var hexagon_animation_player = $HexagonAnimationPlayer
@onready var label_3d = $Label3D
@onready var damage_player = $DamagePlayer
@onready var melee_area = $MeleeArea
@onready var marker_3d = $Marker3D
@onready var combat_pcam_left = $CombatPcams/CombatPcamLeft
@onready var combat_pcam_right = $CombatPcams/CombatPcamRight
@onready var staring_point = $StaringPoint
@onready var evade_position_ray = $EvadePositionRay

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
	pass

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
			reset_combat_position(false)
	elif is_observing:
		look_at_spot(observee)

func get_ready():
	var model_3D = enemy_model.instantiate()
	visuals.add_child(model_3D)
	model = $Visuals/Model
	animation_player = model.animation_player
	change_equipment(enemy_stats)
	look_at(vista_point)
	model.tween_backward.connect(_on_tween_backward)
	model.tween_forward.connect(_on_tween_forward)
	model.animation_was_finished.connect(_on_animation_was_finished)

func reset_combat_position(done_fighting: bool = true):
	observee = vista_point
	global_position = main_spot
	if done_fighting:
		look_at_spot(vista_point)
		model.animation_player.play(idle_combat_animation)

func _on_melee_area_body_entered(body):
	if body is Ally: 
		if body.int_id == agressor_int_id:
			someone_is_in_melee_positon.emit()
			body.is_moving = false

func _on_animation_was_finished(animation: String):
	pass
	#if animation == "dodge_forward":
		#global_position = main_spot
		#var counterattack_animation: String
		#match enemy_stats.melee.type:
			#0:
				#counterattack_animation = "1h_melee_horizontal"
		#model.animation_player.play(counterattack_animation)

func _on_tween_backward():
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
