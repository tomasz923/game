extends Control

signal the_screen_is_covered

const ROBOTO_CONDENSED_REGULAR = preload("res://assets/fonts/RobotoCondensed-Regular.ttf")
const WARHAMMER = preload("res://game/inventory_items/warhammer.tres")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var black_bottom: ProgressBar = $BlackBottom
@onready var black_upper: ProgressBar = $BlackUpper
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var title: Label = $Title
@onready var before_combat_node: Control = $BeforeCombatNode
@onready var description: Label = $BeforeCombatNode/ScreenContainer/Description
@onready var visual_help: TextureRect = $BeforeCombatNode/ScreenContainer/VisualHelp
@onready var hide_button: Button = $HideButton
@onready var game_over_screen: Control = $GameOverScreen
@onready var combat_won_screen: Control = $CombatWonScreen
@onready var timer: Timer = $Timer
@onready var ready_to_level_up: Label = $CombatWonScreen/ReadyToLevelUp
@onready var left_column: VBoxContainer = $CombatWonScreen/ColumnsNode/LeftColumn
@onready var right_column: VBoxContainer = $CombatWonScreen/ColumnsNode/RightColumn
@onready var experience_label: Label = $CombatWonScreen/ColumnsNode/LeftColumn/ExperienceLabel
@onready var experience_value: Label = $CombatWonScreen/ColumnsNode/RightColumn/ExperienceValue
@onready var supplies_label: Label = $CombatWonScreen/ColumnsNode/LeftColumn/SuppliesLabel
@onready var supplies_value: Label = $CombatWonScreen/ColumnsNode/RightColumn/SuppliesValue
@onready var credits_label: Label = $CombatWonScreen/ColumnsNode/LeftColumn/CreditsLabel
@onready var credits_value: Label = $CombatWonScreen/ColumnsNode/RightColumn/CreditsValue

func start_combat(title_string: String, description_string: String):
	visible = true
	title.text = title_string
	description.text = description_string
	animation_player.play("show_screen_transition")
	animation_player.queue("show_before_combat")
	before_combat_node.visible = true
	hide_button.visible = true
	await animation_player.animation_finished
	the_screen_is_covered.emit()

func game_over():
	visible = true
	title.text = "st_game_over"
	animation_player.play("show_screen_transition")
	animation_player.queue("game_over")
	game_over_screen.visible = true

func combat_won(experience: int, supplies: int, credits: int, items: Array):
	var victory_labels_and_values: Array = (
	[experience_label, supplies_label, credits_label] +
	[experience_value, supplies_value, credits_value])
	
	# Make it all black
	ready_to_level_up.visible = false
	for label in victory_labels_and_values:
		label.set("theme_override_colors/font_color", 00000000)
	
	visible = true
	title.text = "st_victory"
	animation_player.play("show_screen_transition")
	
	# Hide or remove unused parts and add items
	var left_column_children = left_column.get_children()
	var right_column_children = right_column.get_children()
	for i in len(left_column.get_children()):
		if left_column_children[i].text == "st_new_item":
			left_column.remove_child(left_column_children[i])
			left_column_children[i].queue_free() 
			right_column.remove_child(right_column_children[i])
			right_column_children[i].queue_free() 
	if supplies == 0:
		supplies_label.visible = false
		supplies_value.visible = false
	if credits == 0:
		credits_label.visible = false
		credits_value.visible = false
	for item in items:
		var new_label = Label.new()
		var new_value = Label.new()
		new_label.text = "st_new_item"
		new_value.text = item.item_name
		new_label.set("theme_override_font_sizes/font_size", 32)
		new_value.set("theme_override_font_sizes/font_size", 32)
		new_label.set("theme_override_fonts/font", ROBOTO_CONDENSED_REGULAR)
		new_value.set("theme_override_fonts/font", ROBOTO_CONDENSED_REGULAR)
		new_label.set("theme_override_colors/font_color", 00000000)
		new_value.set("theme_override_colors/font_color", 00000000)
		left_column.add_child(new_label)
		right_column.add_child(new_value)

	# Experience Part
	await animation_player.animation_finished
	combat_won_screen.visible = true
	experience_value.text = str(Global.save_state["experience"]) + "/" + str(7 + Global.save_state["level"])
	experience_label.set("theme_override_colors/font_color", "WHITE")
	experience_value.set("theme_override_colors/font_color", "WHITE")
	if experience != 0:
		timer.wait_time = 0.5
		while experience != 0:
			timer.start()
			await timer.timeout
			experience -= 1
			if timer.wait_time > 0.1:
				timer.wait_time -= 0.04
			Global.save_state["experience"] += 1
			experience_value.text = str(Global.save_state["experience"])+ "/" + str(7 + Global.save_state["level"])
			if Global.save_state["experience"] == 7 + Global.save_state["level"]:
				ready_to_level_up.visible = true
				
	# Show other rewards than experience
	supplies_value.text = str(supplies)
	credits_value.text = str(credits)
	timer.wait_time = 0.5
	left_column_children = left_column.get_children()
	right_column_children = right_column.get_children()
	for i in len(left_column.get_children()):
		if i == 0:
			pass
		else:
			timer.start()
			await timer.timeout
			left_column_children[i].set("theme_override_colors/font_color", "WHITE")
			right_column_children[i].set("theme_override_colors/font_color", "WHITE")
	timer.start()
	await timer.timeout
	hide_button.visible = true
	animation_player.play("show_hide_button")
	Global.current_scene.return_to_exploration()

func _on_hide_button_pressed() -> void:
	animation_player.play("RESET")
	hide_button.visible = false
	before_combat_node.visible = false
	visible = false
	if combat_won_screen.visible == true:
		combat_won_screen.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		Global.cursors_visible_in_game = false
		Global.allow_movement = true
		Global.current_combat_scene.queue_free()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
