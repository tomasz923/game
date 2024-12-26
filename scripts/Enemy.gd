extends CharacterBody3D
class_name Enemy

@onready var visuals = $Visuals
@onready var hexagon_animation_player = $AnimationPlayer

@export var enemy_stats: Resource 
@export var enemy_model: PackedScene
@export var current_health: int
@export var int_id: int 

var model

func get_ready():
	var model_3D = enemy_model.instantiate()
	visuals.add_child(model_3D)
	model = $Visuals/Model
	change_equipment()
	current_health = enemy_stats.max_health

func change_equipment():
	if enemy_stats.ranged == null:
		model.hips_container.visible = false
		match enemy_stats.melee.type:
			enemy_stats.melee.ItemType.WEAPON_1H:
				model.right_hand_container.visible = true
				var equipped_weapon = enemy_stats.melee.model_scene.instantiate()
				model.right_hand_container.add_child(equipped_weapon)
				model.animation_player.play("1h_idle")
	else:
		pass
	#var new_weapon
	#if enemy_stats.melee != null:
		#for n in model.hips_container.get_children():
			#model.hips_container.remove_child(n)
			#n.queue_free()
		#for n in model.back_container.get_children():
			#model.back_container.remove_child(n)
			#n.queue_free()
		#new_weapon = enemy_stats.melee.model_scene.instantiate()
		#
		#if enemy_stats.melee.type == 0:
			#model.hips_container.add_child(new_weapon)
		#else:
			#model.back_container.add_child(new_weapon)
