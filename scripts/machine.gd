extends CharacterBody3D
class_name Machine

@export_category("Machine")
@export var int_id: int 

var model: Node3D
var animation_player: AnimationPlayer
var navigation_agent_3d: NavigationAgent3D
var is_returning_from_melee: bool = false
var is_moving: bool = false
var is_in_combat: bool = false
var destination: Vector3
var main_spot: Vector3
var back_spot: Vector3
var vista_point: Vector3
var melee_animation: String
var melee_reaction: String
var idle_melee_animation: String
var melee_running_animation: String
var melee_death_animation: String
var debug: bool = false

const walking_speed: float = 1.5
const running_speed: float = 3.5
const rotation_speed: float = 10

func look_at_spot(target_pos: Vector3):
	var global_pos = self.global_transform.origin
	var wtransform = self.global_transform.looking_at(Vector3(target_pos.x, global_pos.y, target_pos.z), Vector3.UP)
	var wrotation = Quaternion(global_transform.basis).slerp(Quaternion(wtransform.basis), 0.1)
	self.global_transform = Transform3D(Basis(wrotation), global_pos)

func update_target_position(target_position: Vector3):
	navigation_agent_3d.target_position = target_position

func change_equipment(stats: MachineStats):
	var new_weapon
	var new_weapon_2
	if stats.melee != null:
		for n in model.right_hand_container.get_children():
			model.right_hand_container.remove_child(n)
			n.queue_free()
		for n in model.hips_container.get_children():
			model.hips_container.remove_child(n)
			n.queue_free()
		for n in model.back_container.get_children():
			model.back_container.remove_child(n)
			n.queue_free()
		new_weapon = stats.melee.model_scene.instantiate()
		new_weapon_2 = new_weapon.duplicate()
		if stats.melee.type == 0:
			model.hips_container.add_child(new_weapon)
			model.right_hand_container.add_child(new_weapon_2)
			melee_animation = "1h_melee_horizontal"
			melee_reaction = "1h_react" 
			melee_death_animation = "1h_death"
			idle_melee_animation = "1h_idle"
			melee_running_animation = "1h_run_forward"
		else:
			model.back_container.add_child(new_weapon)

func back_to_main_spot():
	animation_player.play(melee_running_animation)
	is_returning_from_melee = true
	is_moving = true
	destination = main_spot
	update_target_position(destination)

func reset_combat_position():
	is_moving = false
	is_in_combat = true
	global_position = main_spot
	look_at(vista_point)
	model.animation_player.play(idle_melee_animation)

func get_in_combat(stats: MachineStats):
	reset_combat_position()
	look_at(vista_point)
	if stats.ranged == null:
		model.hips_container.visible = false
		match stats.melee.type:
			stats.melee.ItemType.WEAPON_1H:
				model.right_hand_container.visible = true
				var equipped_weapon = stats.melee.model_scene.instantiate()
				for n in model.right_hand_container.get_children():
					model.right_hand_container.remove_child(n)
					n.queue_free()
				model.right_hand_container.add_child(equipped_weapon)
	else:
		pass
