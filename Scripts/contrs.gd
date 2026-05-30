extends VBoxContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_parent().size.x = Disp.x - 40
	for x in get_children():
		x.offset_left = 0
		x.custom_minimum_size.x = clamp(Disp.x - 50 - x.offset_left, 460, 50000)
		continue
