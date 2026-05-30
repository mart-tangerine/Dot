extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var rat = DisplayServer.window_get_size()
	size = rat
	for x in get_children():
		if x is Node2D:
			x.position = (rat / Disp.mod / 2)
			if rat.x < rat.y:
				x.scale = Vector2(1, 1) * 0.0025 * rat.x / Disp.mod
			else:
				x.scale = Vector2(1, 1) * 0.0025 * rat.y / Disp.mod
	pass
