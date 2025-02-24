extends Machine
class_name Ally

@export_category("Ally")
@export var stats: AllyStats
@export var character: Global.Characters
@export var status_effects: Array[StatusEffect]

var current_exploration_speed = running_speed
var ready_for_combat = false

func unsheath_weapon():
	animation_player.play_backwards("1h_sheath")
	ready_for_combat = true

func arrived():
	is_moving = false

func ensure_ally_stats():
	if stats == null:
		stats = AllyStats.new()
		stats.initiate(character)

func _on_tween_backward():
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).set_parallel()
	tween.tween_property(self, "global_position", back_spot, 1.1)
	await tween.finished
	tween.stop()
