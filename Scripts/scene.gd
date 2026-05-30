extends Node2D
var pos = Vector2(0, 0)
var zoom = Vector2(1, 1)
func _ready() -> void:
	if name == "UIelems":
		while true:
			for x in get_children():
				x.position = x.pos - x.size / 2
			await get_tree().process_frame
