extends RayCast3D

@onready var label = $LabelNode/Label
@onready var animation_player = $"../../visuals/hero/AnimationPlayer"



func _physics_process(_delta):
	if is_colliding():
		var collider = get_collider()
		if Global.collider != collider:
			if Global.collider is Interactable:
				Global.collider.label.visible = false
			Global.collider = collider
		if collider is Interactable and !collider.is_talking and !Global.just_finished_talking:
			label.visible = true
			collider.label.visible = true
			if Input.is_action_just_pressed("interact") and collider.is_a_character and !collider.is_talking and !Global.just_finished_talking:
				Global.just_finished_talking = true
				Global.talker = collider
				Global.talker_cam = collider.talker_cam
				Global.talker.label.visible = false
				Global.talker.is_talking = true
				label.visible = false
				Global.talker.interaction()
				start_conversation(Global.talker.script_file, Global.talker.label_content)
		else:
			label.visible = false
	else:
		label.visible = false
		if Global.collider is Interactable:
			Global.collider.label.visible = false
		Global.just_finished_talking = false

func start_conversation(script_file, name_label):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Global.pausable = false
	Global.allow_movement = false
	Global.dialogue_box.visible = true
	Global.dialogue_box._start_dialogue(script_file, name_label)
	Global.talker_cam.current = true
	animation_player.play("idle")
