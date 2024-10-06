extends Button
class_name JournalQuest

signal show_quest_updates(quest_name: String)

func _on_pressed():
	show_quest_updates.emit(text)
