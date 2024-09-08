extends RayCast3D

@onready var label = $LabelNode/Label

func _physics_process(_delta):
	if is_colliding():
		var collider = get_collider()
		if Global.collider != collider:
			if Global.collider is Interactable:
				Global.collider.label.visible = false
			Global.collider = collider
		if collider is Interactable and !collider.is_talking:
			label.visible = true
			collider.label.visible = true
			if Input.is_action_just_pressed("interact") and collider.is_a_character and !collider.is_talking:
				Global.talker = collider
				Global.talker_cam = collider.talker_cam
				Global.talker.label.visible = false
				Global.talker.is_talking = true
				label.visible = false
				Global.talker.interaction()
				start_conversation(Global.talker.script_file)
		else:
			label.visible = false
	else:
		label.visible = false
		if Global.collider is Interactable:
			Global.collider.label.visible = false

func start_conversation(script_file):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Global.allow_movement = false
	Global.dialogue_box.visible = true
	Global.dialogue_box._start_dialogue(script_file)
	Global.talker_cam.current = true
