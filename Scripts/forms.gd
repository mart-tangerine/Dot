extends LineEdit
# Called when the node enters the scene tree for the first time.
var velic = 0.0
var vlojs = ""

func _process(delta: float) -> void:
	if len(get_children()) == 0:
		custom_minimum_size.x = 80 + len(text) * 10
		size.x = 80 + len(text) * 10



func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed == true:
			if has_focus():
				var me = self
				var it = get_parent()
				while it.name != "Game":
					it = it.get_parent()
				it.OCM = me
	pass # Replace with function body.
