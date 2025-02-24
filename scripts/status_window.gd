extends Control
class_name StatusWindow

@onready var picture: TextureRect = $Picture
@onready var number: Label = $BlackRectangle/Number
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var status_type: StatusEffect
