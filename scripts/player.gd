extends CharacterBody3D
class_name Player

signal arrived_at_the_main_spot()

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
@export var follower_name: String = 'HERO'
@export var second_bar_type: SecondBar
@export var character_class: CharacterClass
@export_range(4, 20, 2) var basic_damage: int = 4
@export var current_health: int = 10
@export var protection: int = 0
@export var max_health: int 
@export var int_id: int 
#@export var bonds: Array[Resource] = []
@export var status_effects: Array[Resource] = []
@export var moves: Array[Resource] = []

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

@onready var model = $visuals/Model
@onready var camera_mount =  $camera_mount
@onready var animation_player = model.animation_player
@onready var visuals = $visuals
#@onready var dialogue_box = $"../DialogueBox"
@onready var navigation_agent_3d = $NavigationAgent3D
@onready var follower_positions = $FollowerPositions
@onready var collision_shape_3d = $CollisionShape3D
@onready var staring_point = $StaringPoint

@onready var follower_position_one = $FollowerPositions/First/FollowerPositionOne
@onready var view_one = $FollowerPositions/First/ViewOne
@onready var follower_position_two = $FollowerPositions/Second/FollowerPositionTwo
@onready var view_three = $FollowerPositions/Third/ViewThree
@onready var follower_position_three = $FollowerPositions/Third/FollowerPositionThree

#Combat Additions
@onready var hexagon_animation_player = $AnimationPlayer
@onready var hexagon = $Hexagon
@onready var combat_pcam_left = $CombatPcams/CombatPcamLeft
@onready var combat_pcam_right = $CombatPcams/CombatPcamRight
var combat_pcam_target: Vector3 


#Cameras
@onready var exploration_pcam = $camera_mount/ExplorationPcam
var zoom_speed = 1
var min_fov = 50
var max_fov = 85
#func _input(event): 


var SPEED = 2.5
var current_target: CharacterBody3D
var isRunning = true
var isLocked = false
var user_prefs: UserPreferences
var vista_point: Vector3
var main_spot: Vector3
var idle_combat_animation: String
var is_moving: bool = false #only in combat
var is_returning_from_melee: bool #coming back to its post after a melee move in combat
var destination: Vector3 #in combat 

const walking_speed = 1.5
const running_speed = 3.5
const rotation_speed = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	#exploration_pcam = owner.get_node("%ExplorationPcam")
	#if exploration_pcam.get_follow_mode() == exploration_pcam.FollowMode.THIRD_PERSON:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	user_prefs = UserPreferences.load_or_create()
	Global.current_pcam = exploration_pcam
	get_max_health()
	get_protection()

func _process(_delta):
	if is_moving: #and !in_combat
		var current_location = global_transform.origin
		var next_location = navigation_agent_3d.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		
		velocity = new_velocity
		move_and_slide()
		look_at_spot(destination)
		combat_pcam_left.look_at(combat_pcam_target)
		combat_pcam_right.look_at(combat_pcam_target)
		
	if is_returning_from_melee:
		var distance = global_transform.origin.distance_to(main_spot)
		if distance < 0.2:
			arrived_at_the_main_spot.emit()
			is_returning_from_melee = false
			reset_combat_position()
	
func look_at_spot(target_pos: Vector3):
	#var global_pos = self.global_transform.origin
	#var wtransform = self.global_transform.looking_at(Vector3(target_pos.x, global_pos.y, target_pos.z), Vector3.UP)
	var global_pos = self.global_transform.origin
	var wtransform = self.global_transform.looking_at(Vector3(target_pos.x, global_pos.y, target_pos.z), Vector3.UP)
	var wrotation = Quaternion(global_transform.basis).slerp(Quaternion(wtransform.basis), 0.1)
	self.global_transform = Transform3D(Basis(wrotation), global_pos)

func _input(event):
	if event is InputEventMouseButton: 
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			exploration_pcam.fov -= zoom_speed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			exploration_pcam.fov += zoom_speed
		exploration_pcam.fov = clamp(exploration_pcam.fov, min_fov, max_fov)
		
	if event is InputEventMouseMotion and Global.allow_movement:
		rotate_y(deg_to_rad(-event.relative.x*user_prefs.mouse_sensitivity))
		visuals.rotate_y(deg_to_rad(event.relative.x*user_prefs.mouse_sensitivity))
		follower_positions.rotate_y(deg_to_rad(event.relative.x*user_prefs.mouse_sensitivity))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y*user_prefs.mouse_sensitivity))

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

func _physics_process(delta):
	Global.player_position = global_position
	
	if !Global.allow_movement:
		return
		
	if Input.is_action_just_pressed('run') and isRunning == false:
		isRunning = true
	elif Input.is_action_just_pressed('run') and isRunning == true:
		isRunning = false

	if isRunning == true:
		SPEED = running_speed
	else:
		SPEED = walking_speed
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		if isRunning == false and animation_player.current_animation != "walk":
			animation_player.play("walk")
		if isRunning == true and animation_player.current_animation != "run" and !isLocked:
			animation_player.play("run")
		if (animation_player.current_animation == "run" or animation_player.current_animation == "walk")  and isLocked:
			animation_player.play("idle")
			
		if !isLocked:
			visuals.rotation.y = lerp_angle(visuals.rotation.y, atan2(-input_dir.x, -input_dir.y), .5)
			follower_positions.rotation.y = lerp_angle(follower_positions.rotation.y, atan2(-input_dir.x, -input_dir.y), .5)

		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if animation_player.current_animation != "idle":
			animation_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if !isLocked:
		move_and_slide()

func _on_follower_position_one_body_entered(body):
	if body is Follower:
		if !body.in_combat:
			body.arrived()

func _on_follower_position_two_body_entered(body):
	if body is Follower:
		if !body.in_combat:
			body.arrived()

func _on_follower_position_three_body_entered(body):
	if body is Follower:
		if !body.in_combat:
			body.arrived()

func update_target_position(target_position):
	navigation_agent_3d.target_position = target_position

func _on_personal_space_body_entered(body):
	if body is Follower:
		if !body.in_combat:
			body.arrived()

func change_equipment():
	var new_weapon
	if melee != null:
		for n in model.hips_container.get_children():
			model.hips_container.remove_child(n)
			n.queue_free()
		for n in model.back_container.get_children():
			model.back_container.remove_child(n)
			n.queue_free()
		new_weapon = melee.model_scene.instantiate()
		if melee.type == 0:
			model.hips_container.add_child(new_weapon)
		else:
			model.back_container.add_child(new_weapon)

func arrived():
	animation_player.play('idle')

func get_in_combat():
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
