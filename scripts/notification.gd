extends Control
class_name Notification

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label = $Background/Text

var labels_list: Array = []
var texts_list: Array = []
