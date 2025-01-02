extends Resource
class_name MoveResource

func sort_modifiers(array: Array) -> Array:
	# Sort the array using sort_custom
	array.sort_custom(func(a, b):
		return a[1] < b[1]
	)
	
	return array
