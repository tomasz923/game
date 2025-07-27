extends Machine
class_name Ally

@export_category("Ally")
@export var stats: AllyStats
@export var character: Global.Characters

var current_exploration_speed = running_speed
var ready_for_combat = false

const ALLY_STATS_ROBERT_PROTOTYPE = preload("res://assets/temp/ally_stats_robert_prototype.tres")
func unsheath_weapon():
	animation_player.play_backwards("1h_sheath")
	ready_for_combat = true

func arrived():
	is_moving = false

func ensure_ally_stats():
	if stats == null:
		stats = ALLY_STATS_ROBERT_PROTOTYPE

func _on_tween_backward():
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).set_parallel()
	tween.tween_property(self, "global_position", back_spot, 1.1)
	await tween.finished
	tween.stop()
