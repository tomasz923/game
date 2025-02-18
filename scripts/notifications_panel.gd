extends Control

const NOTIFICATION = preload("res://game/scenes/notification.tscn")
@onready var v_box_container = $VBoxContainer
var integer: int = 0

func new_popup(text: String):
	var new  = NOTIFICATION.instantiate()
	new.name = "popup_" + str(integer)
	new.label.text = text
	v_box_container.add_child(new)
	var node_to_change = get_node("VBoxContainer/" + "popup_" + str(integer))
	node_to_change.animation_player.play("pop_up")
	integer += 1
	if integer == 255:
		integer = 0
	await node_to_change.animation_player.animation_finished
	v_box_container.remove_child(node_to_change)
