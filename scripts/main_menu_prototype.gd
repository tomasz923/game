extends Node3D
@onready var hero: Hero = $hero
@onready var main_menu_ui: Control = $MainMenuUI
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var any_button_was_pressed: bool = false

func _ready() -> void:
	hero.animation_player.play("silly_dance")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Global.user_prefs = UserPreferences.load_or_create()
	Global.current_scene = self

func _input(event):
	if !any_button_was_pressed and event.is_pressed():
		any_button_was_pressed = true
		main_menu_ui.visible = true
		animation_player.play("show_menu")
