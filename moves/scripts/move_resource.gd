extends Resource
class_name MoveResource

func sort_modifiers(array: Array) -> Array:
	# Sort the array using sort_custom
	array.sort_custom(func(a, b):
		return a[1] < b[1]
	)
	
	return array

func go_for_melee(run_animation_name: String, agressor: CharacterBody3D, victim: CharacterBody3D):
	agressor.animation_player.play(run_animation_name)
	agressor.is_moving = true
	agressor.destination = victim.global_position
	victim.agressor_int_id = agressor.int_id
	agressor.update_target_position(agressor.destination)

#func back_to_main_spot(run_animation_name):
	#animation_player.play(run_animation_name)
	#look_at(main_spot)
	#var distance = global_transform.origin.distance_to(main_spot)
	#var tween_length = snapped((distance/2.5), 0.1)
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "position", main_spot, tween_length)
	#await tween.finished 
	#look_at(vista_point)
	#model.animation_player.play(idle_combat_animation)
