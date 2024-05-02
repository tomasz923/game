extends RichTextLabel

var var_one = "Centered Text"
var var_two = preload("res://assets/textures/ui/TemporaryTitle.png")
var var_three = "Left Text"
var var_four = "Right Text"

func _ready():
	bbcode_enabled = true
	# Centered text on the first line
	add_text("[center][size=16]var_one[/size][/center]")
	# Image on the second line
	add_image(var_two)
	add_text("\n")
	## Text on the third line
	#add_text("[left]%s[/left][right]%s[/right]" % [var_three, var_four])
