class_name UserPreferences extends Resource

@export var display_resolution_selected: int = 1
@export var display_settings_selected: int = 0
@export var vsync_settings_selected: int = 0
@export var current_screen_selected: int = 0
@export var scaling_item_selected: int = 3
@export var game_resolution_value_selected: int = 100
@export var scaling_option_item_selected: int = 0
@export var chosen_language: int = 0
@export var aa_option_selected: int = 1
@export var mouse_sensitivity: float = 0.2
@export var master_volume: float = 0.8
@export var music_volume: float = 1.0
@export var sfx_volume: float = 1.0
@export var ui_volume: float = 1.0
@export var voice_volume: float = 1.0

func save() -> void:
	ResourceSaver.save(self, "res://saves/user_prefs.tres")

static func load_or_create() -> UserPreferences:
	var res: UserPreferences = load("res://saves/user_prefs.tres") as UserPreferences
	if !res:
		res = UserPreferences.new()
	return res
