extends Button

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed == true:
			var me = self
			var it = get_parent()
			while it.name != "Game":
				it = it.get_parent()
			it.OCM = me
	pass # Replace with function body.
