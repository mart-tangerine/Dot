extends OptionButton



func _on_pressed() -> void:
	var rut = get_parent().get_parent().get_parent().get_parent().get_parent()
	clear()
	add_item(" Случайный объект")
	for x in rut.get_node("Objects/Objs/Dot").get_children():
		add_item(" " + x.name)
	pass # Replace with function body.
