extends CharacterBody3D

var texting_saving = "Deafult Value"

@onready var main_cam = $camera_mount/MainCam
@onready var camera_mount =  $camera_mount
#@onready var animation_player = $visuals/mixamo_base/AnimationPlayer
@onready var animation_player = $visuals/hero/AnimationPlayer
@onready var visuals = $visuals
@onready var dialogue_box = $"../../DialogueBox"
@onready var navigation_agent_3d = $NavigationAgent3D
@onready var player_cam = $camera_mount/PlayerCam
@onready var follower_positions = $FollowerPositions
@onready var collision_shape_3d = $CollisionShape3D

@onready var follower_position_one = $FollowerPositions/First/FollowerPositionOne
@onready var view_one = $FollowerPositions/First/ViewOne
@onready var follower_position_two = $FollowerPositions/Second/FollowerPositionTwo
@onready var view_three = $FollowerPositions/Third/ViewThree
@onready var follower_position_three = $FollowerPositions/Third/FollowerPositionThree




var SPEED = 2.5
var isRunning = true
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
	
func _input(event):
	#if Input.is_action_just_pressed("ui_cancel"):
		#get_tree().quit()
		
	if event is InputEventMouseMotion and Global.allow_movement:
		rotate_y(deg_to_rad(-event.relative.x*user_prefs.mouse_sensitivity))
		visuals.rotate_y(deg_to_rad(event.relative.x*user_prefs.mouse_sensitivity))
		follower_positions.rotate_y(deg_to_rad(event.relative.x*user_prefs.mouse_sensitivity))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y*user_prefs.mouse_sensitivity))

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
