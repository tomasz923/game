extends Sprite3D

func _process(_delta):
	$SubViewport.size  = $SubViewport/VBoxContainer.rect_size
