extends Control

@onready var health_bar = $HealthBar
@onready var name_label = $NameContainer/NameLabel
@onready var active_triangle = $NameContainer/ActiveTriangle
@onready var health_value = $BasicStats/HealthContainer/HealthValue
@onready var aggro_value = $BasicStats/AggroContainer/AggroValue
@onready var protection_value = $BasicStats/ProtectionContainer/ProtectionValue
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func hide_window():
	active_triangle.visible = false
	animation_player.play("hide")
	await animation_player.animation_finished
	visible = false
