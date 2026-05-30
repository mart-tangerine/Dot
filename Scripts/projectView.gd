extends Node

func _ready() -> void:
	while true:
		await get_tree().create_timer(0.2).timeout
		var rat = DisplayServer.window_get_size()
		$Bg.size = rat
		for x in get_children():
			if x is Node2D and not x is CanvasModulate:
				x.position = (rat / Disp.mod / 2) + x.pos
				if rat.x < rat.y:
					x.scale = Vector2(1, 1) * 0.0025 * rat.x / Disp.mod
				else:
					x.scale = Vector2(1, 1) * 0.0025 * rat.y / Disp.mod
				x.scale *= x.zoom
