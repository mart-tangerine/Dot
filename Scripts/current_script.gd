extends VBoxContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_d_ : float) -> void:
	get_parent().size.x = Disp.x - 50
	var vlj = 0
	var drag = false
	for x in get_children():
		if x is Panel:
			if x.dragging:
				drag = true
				x.size.x = 300
				break
	for x in get_children():
		if drag:
			x.offset_left = 0
			continue
		var nidpos = 0
		if x is Panel:
			if x.name.begins_with("ifend_") or x.name.begins_with("endcycle_"):
				vlj -= 1
			if "При" in x.get_node("Label").text:
				vlj = 0
			nidpos = vlj * Disp.sepr
			if x.name.begins_with("if_") or x.name.begins_with("repeat_") or x.name.begins_with("while_"):
				vlj += 1
			if x.name.begins_with("else_"):
				nidpos -= Disp.sepr
			x.offset_left = clamp(nidpos, 0, max(Disp.x - 500, 0))
		if not drag:
			x.custom_minimum_size.x = clamp(Disp.x - 60 - x.offset_left, 350, 50000)
