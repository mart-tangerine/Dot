extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var formulas = false
	if get_parent().has_node("Pole"):
		formulas = get_parent().get_node("Pole/Scroll/LForms").has_node("Label")
	for x in get_parent().get_children():
		if x is HBoxContainer:
			if len(x.get_children()) == 1:
				x.get_node("Scroll").size.x = get_parent().size.x - 5 - x.get_node("Scroll").position.x
			else:
				x.get_node("Scroll").size.x = get_parent().size.x - 10 - x.get_child(0).size.x - x.get_node("Scroll").position.x
			if "Colorpicker" in x.name:
				var ogo = x.name.split("_")
				for y in range(len(ogo)):
					if not formulas:
						if y == 1:
							get_parent().get_node("Pole" + ogo[y] + "/Scroll/LForms").text = str(int(float(str(x.get_node("Scroll/LForms").color.r)) * 255))
						elif y == 2:
							get_parent().get_node("Pole" + ogo[y] + "/Scroll/LForms").text = str(int(float(str(x.get_node("Scroll/LForms").color.g)) * 255))
						elif y == 3:
							get_parent().get_node("Pole" + ogo[y] + "/Scroll/LForms").text = str(int(float(str(x.get_node("Scroll/LForms").color.b)) * 255))
						elif y == 4:
							get_parent().get_node("Pole" + ogo[y] + "/Scroll/LForms").text = str(int(float(str(x.get_node("Scroll/LForms").color.a)) * 255))
					else:
						if y == 1:
							get_parent().get_node("Pole" + ogo[y] + "/Scroll/LForms").text = str(int(float(str(x.get_node("Scroll/LForms").color.r)) * 255))
						elif y == 2:
							get_parent().get_node("Pole" + ogo[y] + "/Scroll/LForms").text = str(int(float(str(x.get_node("Scroll/LForms").color.g)) * 255))
						elif y == 3:
							get_parent().get_node("Pole" + ogo[y] + "/Scroll/LForms").text = str(int(float(str(x.get_node("Scroll/LForms").color.b)) * 255))
						elif y == 4:
							get_parent().get_node("Pole" + ogo[y] + "/Scroll/LForms").text = str(int(float(str(x.get_node("Scroll/LForms").color.a)) * 255))
		if x is OptionButton:
			get_parent().get_node("Pole" + x.name.replace("Optb", "").split("_")[0] + "/Scroll/LForms").text = x.get_item_text(x.selected)
	pass
