extends Panel


# Called when the node enters the scene tree for the first time.
func _on_touch_pressed() -> void:
	get_parent().get_parent().get_parent().get_parent().get_parent().get_node("NewProj").show()
	get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Click").play()
	get_parent().get_parent().get_parent().get_parent().hide()
	pass # Replace with function body.
