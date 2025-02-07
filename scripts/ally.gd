extends Machine
class_name Ally

@export_category("Ally")
@export var ally_stats: AllyStats
@export var ally_character: Global.Characters

var current_exploration_speed = running_speed

func arrived():
	is_moving = false

func get_in_combat():
	if ally_stats.ranged == null:
		model.hips_container.visible = false
		match ally_stats.melee.type:
			ally_stats.melee.ItemType.WEAPON_1H:
				model.right_hand_container.visible = true
				var equipped_weapon = ally_stats.melee.model_scene.instantiate()
				for n in model.right_hand_container.get_children():
					model.right_hand_container.remove_child(n)
					n.queue_free()
				model.right_hand_container.add_child(equipped_weapon)
				idle_combat_animation = "1h_idle"
				model.animation_player.play(idle_combat_animation)
	else:
		pass
	look_at(vista_point)

func ensure_ally_stats():
	if ally_stats == null:
		ally_stats = AllyStats.new()
		ally_stats.initiate()
		ally_stats.calculate_max_health()
		ally_stats.current_health = ally_stats.max_health

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

func _on_tween_backward():
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).set_parallel()
	tween.tween_property(self, "global_position", back_spot, 1.1)
	await tween.finished
	tween.stop()
