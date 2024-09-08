extends CharacterBody3D
class_name Follower

enum Followers {
	Wren,
	Moss,
	Jett,
}

enum FollowerOrder {
	First,
	Second,
	Third,
}

#@export var spells: Array[SpellType] = []
@export var FollowerNumber: FollowerOrder 
@export var Name: Followers
@onready var navigation_agent_3d = $NavigationAgent3D
@onready var animation_player = $visuals/AnimationPlayer

var is_moving: bool = false
var SPEED: float = 2.5
var target: CharacterBody3D
var destination: Vector3
var is_looking: bool = false


func _process(_delta):
	if is_moving:
		look_at_spot()
		animation_player.play("running")
		
		match FollowerNumber:
			0:
				destination = target.follower_position_one.global_position
				update_target_position(destination)
			1:
				destination = target.follower_position_two.global_position
				update_target_position(destination)
			2:
				destination = target.follower_position_three.global_position
				update_target_position(destination)
			
		var current_location = global_transform.origin
		var next_location = navigation_agent_3d.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED

		var direction = next_location - current_location
		var target_rotation = atan2(direction.x, -direction.y)
		rotation.y = lerp_angle(rotation.y, target_rotation, 0.5)

		velocity = new_velocity
		move_and_slide()

	else:
		animation_player.play("idle")

func look_at_spot():
	# Get the current rotation
	var start_rotation = global_rotation
	# Make the object look at the player immediately (to calculate target rotation)
	match FollowerNumber:
		0:
			look_at(target.view_one.global_position)
		1:
			look_at(target.global_position)
		2:
			look_at(target.view_three.global_position)
	# Store the target rotation
	var target_rotation = global_rotation
	# Reset to start rotation
	global_rotation = start_rotation
	## Create a tween to smoothly rotate to the target
	#tween.stop_all()  # Stop any existing tweens
	var tween = create_tween()
	tween.tween_property(self, "global_rotation", target_rotation, 1).set_trans(Tween.TRANS_LINEAR)

func update_target_position(target_position):
	#var forward_vector = global_transform.basis.z
	#var behind_point = global_transform.origin - forward_vector * distance
	navigation_agent_3d.target_position = target_position

func _on_area_3d_body_exited(body):
	target = body
	is_moving = true
	#look_at_spot()
	if body is CharacterBody3D:
		print("CharacterBody3D exited the area!")
		print(target.follower_position_three.global_position)

func arrived():
	is_moving = false
