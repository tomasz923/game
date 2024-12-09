extends CharacterBody3D
class_name Hero

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
@onready var main_cam = $camera_mount/MainCam
@onready var camera_mount =  $camera_mount
@onready var animation_player = model.animation_player
@onready var visuals = $visuals
@onready var dialogue_box = $"../../DialogueBox"
@onready var navigation_agent_3d = $NavigationAgent3D
@onready var player_cam = $PlayerCam
@onready var follower_positions = $FollowerPositions
@onready var collision_shape_3d = $CollisionShape3D

@onready var follower_position_one = $FollowerPositions/First/FollowerPositionOne
@onready var view_one = $FollowerPositions/First/ViewOne
@onready var follower_position_two = $FollowerPositions/Second/FollowerPositionTwo
@onready var view_three = $FollowerPositions/Third/ViewThree
@onready var follower_position_three = $FollowerPositions/Third/FollowerPositionThree

#Hexagon
@onready var hexagon_animation_player = $AnimationPlayer
@onready var hexagon = $Hexagon

var SPEED = 2.5
@onready var isRunning = true
var isLocked = false
var user_prefs: UserPreferences

const walking_speed = 1.5
const running_speed = 3.5
const rotation_speed = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	user_prefs = UserPreferences.load_or_create()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_max_health()
	get_protection()
	
func _input(event):
	#if Input.is_action_just_pressed("ui_cancel"):
		#get_tree().quit()
		
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
		body.arrived()

func _on_follower_position_two_body_entered(body):
	if body is Follower:
		body.arrived()

func _on_follower_position_three_body_entered(body):
	if body is Follower:
		body.arrived()

#func _on_area_3d_body_exited(body):
	#print('DEBUG: ', body, ' has entered the area.')
	#if body is Follower:
		#body.arrived()

func _on_personal_space_body_entered(body):
	if body is Follower:
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
				model.animation_player.play("1h_idle")
	else:
		pass
