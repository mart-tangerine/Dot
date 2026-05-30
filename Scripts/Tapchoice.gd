extends Panel

func _on_drag_pressed() -> void:
	for x in get_parent().get_parent().get_children():
		x.hide()
	get_parent().get_parent().get_parent().get_parent().get_node("Click").play()
	get_parent().get_parent().get_node(str(name)).show()
	pass # Replace with function body.

func _process(delta: float) -> void:
	$Drag.size = size
