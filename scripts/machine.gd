extends CharacterBody3D
class_name Machine

@export_category("Machine")
@export var int_id: int 

var model: Node3D
var animation_player: AnimationPlayer
var idle_combat_animation: String
var navigation_agent_3d: NavigationAgent3D
var is_returning_from_melee: bool = false
var is_moving: bool = false
var destination: Vector3
var main_spot: Vector3
var back_spot: Vector3
var vista_point: Vector3

const walking_speed: float = 1.5
const running_speed: float = 3.5
const rotation_speed: float = 10

func look_at_spot(target_pos: Vector3):
	var global_pos = self.global_transform.origin
	var wtransform = self.global_transform.looking_at(Vector3(target_pos.x, global_pos.y, target_pos.z), Vector3.UP)
	var wrotation = Quaternion(global_transform.basis).slerp(Quaternion(wtransform.basis), 0.1)
	self.global_transform = Transform3D(Basis(wrotation), global_pos)

#Since it is not used in combat, it may be useful only to allies.
#func arrived():
	#is_moving = false

func update_target_position(target_position: Vector3):
	navigation_agent_3d.target_position = target_position

func change_equipment(stats: Resource):
	var new_weapon
	if stats.melee != null:
		for n in model.hips_container.get_children():
			model.hips_container.remove_child(n)
			n.queue_free()
		for n in model.back_container.get_children():
			model.back_container.remove_child(n)
			n.queue_free()
		new_weapon = stats.melee.model_scene.instantiate()
		if stats.melee.type == 0:
			model.hips_container.add_child(new_weapon)
		else:
			model.back_container.add_child(new_weapon)
