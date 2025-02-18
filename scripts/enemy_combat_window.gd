extends Control

@onready var health_bar = $HealthBar
@onready var name_label = $NameContainer/NameLabel
@onready var health_value = $BasicStats/HealthContainer/HealthValue
@onready var protection_value = $BasicStats/ProtectionContainer/ProtectionValue
@onready var active_triangle: TextureRect = $NameContainer/ActiveTriangle
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func hide_window():
	active_triangle.visible = false
	animation_player.play("hide")
	await animation_player.animation_finished
	visible = false
