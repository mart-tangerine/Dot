extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not $Butts/Error.visible:
		if size.x > 385:
			$Butts/Full.visible = true
			$Butts/Icons.visible = false
		else:
			$Butts/Icons.visible = true
			$Butts/Full.visible = false
	else:
		$Butts/Full.hide()
		$Butts/Icons.hide()
	pass


func _on_button_pressed() -> void:
	get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Click").play()
	for x in get_parent().get_children():
		if x.name != name:
			create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property(x.get_node("Butts"), "scale", Vector2(1, 0), 0.6)
			create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property(x.get_node("Butts"), "modulate", Color(1, 1, 1, 0), 0.6)
			create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property(x, "custom_minimum_size", Vector2(size.x, 60), 0.6)
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property($Butts, "scale", Vector2(1, 1), 0.5)
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property($Butts, "modulate", Color(1, 1, 1, 1), 0.5)
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property(self, "custom_minimum_size", Vector2(size.x, 100), 0.5)
	pass # Replace with function body.


func _on_delete_pressed() -> void:
	get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Click").play()
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property($Butts, "scale", Vector2(1, 0), 0.5)
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property($Butts, "modulate", Color(1, 1, 1, 0), 0.5)
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property(self, "custom_minimum_size", Vector2(size.x, 0), 0.5)
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property(self, "size", Vector2(size.x, 0), 0.5)
	$Panel.visible = false
	$Title.visible = false
	$Time.visible = false
	$Subtitle.visible = false
	$Ver.visible = false
	yayca(Disp.projpath + "/Projects/" + $Filename.text)
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property($Panel, "size", Vector2($Panel.size.x, 0), 0.5)
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property($Title, "size", Vector2($Title.size.x, 0), 0.5)
	await get_tree().create_timer(0.4).timeout
	queue_free()
	pass # Replace with function body.

func yayca(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				yayca(path + "/" + file_name)
			else:
				dir.remove(file_name)
			file_name = dir.get_next()
		dir.remove(path)


func _on_edit_pressed() -> void:
	var editor = load("res://game.tscn").instantiate()
	editor.projname = $Filename.text
	var ogo = str_to_var(FileAccess.get_file_as_string("user://settings.txt"))
	if ogo:
		if ogo["UI"].has("Lang"):
			Dot.lang = ogo["UI"]["Lang"]
	get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().add_child(editor)
	get_parent().get_parent().get_parent().get_parent().get_parent().queue_free()
	pass # Replace with function body.



func _on_launch_pressed() -> void:
	var editor = load("res://game.tscn").instantiate()
	editor.projname = $Filename.text
	editor.lnc = true
	var ogo = str_to_var(FileAccess.get_file_as_string("user://settings.txt"))
	if ogo:
		if ogo["UI"].has("Lang"):
			Dot.lang = ogo["UI"]["Lang"]
	get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().add_child(editor)
	get_parent().get_parent().get_parent().get_parent().get_parent().queue_free()
	pass # Replace with function body.
