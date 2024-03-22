class_name UserPreferences extends Resource

@export var display_resolution_selected: int = 1

func save() -> void:
	ResourceSaver.save(self, "res://saves/user_prefs.tres")

static func load_or_create() -> UserPreferences:
	var res: UserPreferences = load("res://saves/user_prefs.tres") as UserPreferences
	if !res:
		res = UserPreferences.new()
	return res
