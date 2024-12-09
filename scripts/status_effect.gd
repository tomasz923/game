extends Resource
class_name StatusEffect

@export var text: String = 'DEBUG Better new text'

func trigger_effect(follower):
	print(text)
	follower.animation_player.play("1h_react")
