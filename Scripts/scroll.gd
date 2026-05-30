extends ScrollContainer

func _process(delta: float) -> void:
	size.x = 500 + randi_range(0, 0)
