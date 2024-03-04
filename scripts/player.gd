extends CharacterBody3D

@onready var camera_mount =  $camera_mount
@onready var animation_player = $visuals/mixamo_base/AnimationPlayer
@onready var visuals = $visuals

var SPEED = 2.5
var isRunning = true
var isLocked = false
var allow_movement = true

const walking_speed = 1.5
const running_speed = 3.5
const rotation_speed = 10

@export var sens_horizontal = 0.2
@export var sens_vertical = 0.2
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*sens_horizontal))
		visuals.rotate_y(deg_to_rad(event.relative.x*sens_horizontal))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y*sens_vertical))

func _physics_process(delta):
	if !allow_movement:
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
		if isRunning == false and animation_player.current_animation != "walking":
			animation_player.play("walking")
		if isRunning == true and animation_player.current_animation != "running" and !isLocked:
			animation_player.play("running")
		if (animation_player.current_animation == "running" or animation_player.current_animation == "walking")  and isLocked:
			animation_player.play("idle")
			
		if !isLocked:
			visuals.rotation.y = lerp_angle(visuals.rotation.y, atan2(-input_dir.x, -input_dir.y), .5)

		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if animation_player.current_animation != "idle":
			animation_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if !isLocked:
		move_and_slide()

func _on_area_3d_area_entered(area):
	if area.name != 'Area3D':
		allow_movement = false
		animation_player.play("idle")
		#var parts = area.name.split("_")
		#var area_name = parts[0]
		LoadManager.load_scene("res://game/scenes/fightSceneOne.tscn")
	else:
			print('Saving...')

#func _on_area_3d_area_exited(area):
	#print(area.name, ' exited')
