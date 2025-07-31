extends Button

signal instance_was_highlighted(items)

@export var nested_resource: Resource
@export var nested_string: String = "Error - no data found"
var has_resources: bool = false


func _on_mouse_entered() -> void:
	var items_to_be_sent
	
	if has_resources:
		items_to_be_sent = nested_resource
	else:
		items_to_be_sent = nested_string
		
	instance_was_highlighted.emit(items_to_be_sent)
