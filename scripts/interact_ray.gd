extends RayCast3D

@onready var label = $LabelNode/Label

func _physics_process(_delta):
	label.text = Global.state_var_dialogue["name"]
	if is_colliding():
		Global.collider = get_collider()
		if Global.collider is Interactable:
			label.visible = true
			if Input.is_action_just_pressed("interact") and Global.collider.is_a_character and !Global.collider.is_talking:
				Global.collider.label.visible = false
				Global.collider.is_talking = true
				label.visible = false
				Global.collider.interaction()
				start_conversation(Global.collider.script_file)
	elif Global.collider != null and Global.collider is Interactable:
		Global.collider.label.visible = false
		Global.collider = null
	else:
		label.visible = false

func start_conversation(script_file):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Global.allow_movement = false
	Global.dialogue_box.visible = true
	Global.dialogue_box._start_dialogue(script_file)
