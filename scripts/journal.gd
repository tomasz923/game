extends Control

@onready var active_quests_label = $BlackBox/QuestNames/QuestNamesContainer/ActiveQuests/Divider
@onready var done_quests_label = $BlackBox/QuestNames/QuestNamesContainer/DoneQuests/Divider
@onready var other_label = $BlackBox/QuestNames/QuestNamesContainer/Other/Divider

@onready var active_quests = $BlackBox/QuestNames/QuestNamesContainer/ActiveQuests
@onready var done_quests = $BlackBox/QuestNames/QuestNamesContainer/DoneQuests
@onready var other = $BlackBox/QuestNames/QuestNamesContainer/Other

@onready var active_quests_list = $BlackBox/QuestNames/QuestNamesContainer/ActiveQuests/ActiveQuestsList
@onready var done_quests_list = $BlackBox/QuestNames/QuestNamesContainer/DoneQuests/DoneQuestsList
@onready var other_list = $BlackBox/QuestNames/QuestNamesContainer/Other/OtherList
@onready var updates_list = $BlackBox/UpdatesContainer/UpdatesList

@onready var updates_container = $BlackBox/UpdatesContainer
@onready var quest_names = $BlackBox/QuestNames
@onready var back_button = $BlackBox/BackButton

@onready var journal_label = $JournalLabel

const JOURNAL_BAR = preload("res://assets/textures/ui/journal_bar.png")
const journal_quest = preload("res://game/scenes/journal_quest.tscn")
const quest_update = preload("res://game/scenes/quest_update.tscn")
var num: int = 0

func get_ready():
	clear_quest_lists()
	clear_quest_updates()
	_on_back_button_pressed()
	for quest in Global.journal:
		match Global.journal[quest]['status']:
			1:
				var button_obj: JournalQuest = journal_quest.instantiate()
				button_obj.name = "ChoiceButton_" + quest
				button_obj.text = quest
				button_obj.show_quest_updates.connect(on_show_quest_updates)
				active_quests_list.add_child(button_obj)
			2:
				var button_obj: JournalQuest = journal_quest.instantiate()
				button_obj.name = "ChoiceButton_" + quest
				button_obj.text = quest
				button_obj.show_quest_updates.connect(on_show_quest_updates)
				done_quests_list.add_child(button_obj)
			3:
				var button_obj: JournalQuest = journal_quest.instantiate()
				button_obj.name = "ChoiceButton_" + quest
				button_obj.text = quest
				button_obj.show_quest_updates.connect(on_show_quest_updates)
				other_list.add_child(button_obj)

	if done_quests_list.get_children().size() == 0:
		done_quests.visible = false
	else:
		done_quests.visible = true
	
	if other_list.get_children().size() == 0:
		other.visible = false
	else:
		other.visible = true

func on_show_quest_updates(quest_name: String):
	clear_quest_updates()

	var updates_num: int = 0
	for update in Global.journal[quest_name]['updates']:
		if updates_num != 0:
			var new_bar = TextureRect.new()
			new_bar.texture = JOURNAL_BAR
			updates_list.add_child(new_bar)
		var label_obj: QuestUpdate = quest_update.instantiate()
		label_obj.text = update
		updates_list.add_child(label_obj)
		updates_num += 1
	updates_container.visible = true
	quest_names.visible = false
	back_button.visible = true

func clear_quest_lists():
	for n in active_quests_list.get_children():
		active_quests_list.remove_child(n)
		n.queue_free() 
	for n in done_quests_list.get_children():
		done_quests_list.remove_child(n)
		n.queue_free() 
	for n in other_list.get_children():
		other_list.remove_child(n)
		n.queue_free() 
		
func clear_quest_updates():
	for n in updates_list.get_children():
		updates_list.remove_child(n)
		n.queue_free() 

func _on_back_button_pressed():
	updates_container.visible = false
	quest_names.visible = true
	back_button.visible = false
