extends Control

@onready var animation_player = $AnimationPlayer
@onready var texture_progress_bar = $TextureProgressBar

@export var texture: CompressedTexture2D
@export var status_name: String

func set_texture():
	texture_progress_bar.texture_over = texture
