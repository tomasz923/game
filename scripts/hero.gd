extends Ally
class_name Hero

signal arrived_at_the_main_spot()

@onready var camera_mount =  $camera_mount
@onready var visuals = $visuals
@onready var follower_positions = $FollowerPositions
@onready var collision_shape_3d = $CollisionShape3D
@onready var staring_point = $StaringPoint
@onready var evade_position_ray = $EvadePositionRay

@onready var follower_position_one = $FollowerPositions/First/FollowerPositionOne
@onready var view_one = $FollowerPositions/First/ViewOne
@onready var spawn_point_one: RayCast3D = $FollowerPositions/First/SpawnPointOne
@onready var follower_position_two = $FollowerPositions/Second/FollowerPositionTwo
@onready var spawn_point_two: RayCast3D = $FollowerPositions/Second/SpawnPointTwo
@onready var view_three = $FollowerPositions/Third/ViewThree
@onready var follower_position_three = $FollowerPositions/Third/FollowerPositionThree
@onready var spawn_point_three: RayCast3D = $FollowerPositions/Third/SpawnPointThree

#Combat Additions
@onready var hexagon_animation_player = $HexagonAnimationPlayer
@onready var hexagon = $Hexagon
@onready var combat_pcam_left = $CombatPcams/CombatPcamLeft
@onready var combat_pcam_right = $CombatPcams/CombatPcamRight
@onready var marker_3d: Marker3D = $Marker3D
var combat_pcam_target: Vector3 

#Cameras
@onready var exploration_pcam = $camera_mount/ExplorationPcam
var zoom_speed = 1
var min_fov = 50
var max_fov = 85
var current_target: CharacterBody3D
var is_running = true
var is_locked = false
var user_prefs: UserPreferences

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	model = $visuals/Model
	animation_player = model.animation_player #TEMP
	navigation_agent_3d = $NavigationAgent3D
	model.tween_backward.connect(_on_tween_backward)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	user_prefs = UserPreferences.load_or_create()
	Global.current_pcam = exploration_pcam
	ensure_ally_stats()
	change_equipment(stats)

func _process(_delta):
	if is_moving: #and !in_combat
		var current_location = global_transform.origin
		var next_location = navigation_agent_3d.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * Global.save_state["current_exploration_speed"]
		
		velocity = new_velocity
		move_and_slide()
		look_at_spot(destination)
			
		if is_in_combat:
			combat_pcam_left.look_at(combat_pcam_target)
			combat_pcam_right.look_at(combat_pcam_target)
		
	if is_returning_from_melee:
		var distance = global_transform.origin.distance_to(main_spot)
		if distance < 0.2:
			arrived_at_the_main_spot.emit()
			is_returning_from_melee = false
			reset_combat_position()

func _input(event):
	if event is InputEventMouseButton: 
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and Global.current_ui_mode == "none":
			exploration_pcam.fov -= zoom_speed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and Global.current_ui_mode == "none":
			exploration_pcam.fov += zoom_speed
		exploration_pcam.fov = clamp(exploration_pcam.fov, min_fov, max_fov)
		
	if event is InputEventMouseMotion and Global.allow_movement:
		rotate_y(deg_to_rad(-event.relative.x*user_prefs.mouse_sensitivity))
		visuals.rotate_y(deg_to_rad(event.relative.x*user_prefs.mouse_sensitivity))
		follower_positions.rotate_y(deg_to_rad(event.relative.x*user_prefs.mouse_sensitivity))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y*user_prefs.mouse_sensitivity))

func _physics_process(delta):
	if !Global.allow_movement:
		return
		
	if Input.is_action_just_pressed('run') and is_running == false:
		is_running = true
		Global.save_state["current_exploration_speed"] = running_speed
	elif Input.is_action_just_pressed('run') and is_running == true:
		is_running = false
		Global.save_state["current_exploration_speed"] = walking_speed

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		if is_running == false and animation_player.current_animation != "walk":
			animation_player.play("walk")
		if is_running == true and animation_player.current_animation != "run" and !is_locked:
			animation_player.play("run")
		if (animation_player.current_animation == "run" or animation_player.current_animation == "walk")  and is_locked:
			animation_player.play("idle")
			
		if !is_locked:
			visuals.rotation.y = lerp_angle(visuals.rotation.y, atan2(-input_dir.x, -input_dir.y), .5)
			follower_positions.rotation.y = lerp_angle(follower_positions.rotation.y, atan2(-input_dir.x, -input_dir.y), .5)

		velocity.x = direction.x * Global.save_state["current_exploration_speed"]
		velocity.z = direction.z * Global.save_state["current_exploration_speed"]
	else:
		if animation_player.current_animation != "idle":
			animation_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, Global.save_state["current_exploration_speed"])
		velocity.z = move_toward(velocity.z, 0, Global.save_state["current_exploration_speed"])
		
	if !is_locked:
		move_and_slide()

func _on_personal_space_body_entered(body):
	if body is Follower:
		if !body.is_in_combat:
			body.arrived()
