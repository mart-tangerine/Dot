extends LineEdit

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if has_focus():
			var me = self
			var it = get_parent()
			while it.name != "Game":
				it = it.get_parent()
			it.OCM = me
