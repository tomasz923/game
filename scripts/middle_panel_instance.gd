extends Button

signal instance_was_highlighted(items)
signal instance_was_pressed(items, mark)

const ITEM_EQUIPPED_MARK = preload("res://assets/ui/item_equipped_mark.png")
#var nested_array: Array[String] = ["Error - no data found"]
var nested_array: Array
var nested_resource
var has_resources: bool = false
var is_marked: bool = false


func _on_mouse_entered() -> void:
	var items_to_be_sent
	
	if has_resources:
		items_to_be_sent = nested_resource
	else:
		items_to_be_sent = nested_array
		
	instance_was_highlighted.emit(items_to_be_sent)


func mark_item_as_equipped():
	$".".icon = ITEM_EQUIPPED_MARK
	is_marked = true


func unmark_item_as_equipped():
	$".".icon = null
	is_marked = false


func _on_pressed() -> void:
	var items_to_be_sent
	
	if has_resources:
		items_to_be_sent = nested_resource
	else:
		items_to_be_sent = nested_array
		
	instance_was_pressed.emit(items_to_be_sent, is_marked)
