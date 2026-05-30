extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if size.x > 280:
		$Cont/Butts/Full.visible = true
		$Cont/Butts/Icons.visible = false
	else:
		$Cont/Butts/Icons.visible = true
		$Cont/Butts/Full.visible = false
	pass

func _on_edit_pressed() -> void:
	var editor = load("res://game.tscn").instantiate()
	editor.projname = $Cont/Filename.text
	var ogo = str_to_var(FileAccess.get_file_as_string("user://settings.txt"))
	if ogo:
		if ogo["UI"].has("Lang"):
			Dot.lang = ogo["UI"]["Lang"]
	get_parent().get_parent().get_parent().add_child(editor)
	get_parent().get_parent().queue_free()
	pass # Replace with function body.



func _on_launch_pressed() -> void:
	var editor = load("res://game.tscn").instantiate()
	editor.projname = $Cont/Filename.text
	editor.lnc = true
	var ogo = str_to_var(FileAccess.get_file_as_string("user://settings.txt"))
	if ogo:
		if ogo["UI"].has("Lang"):
			Dot.lang = ogo["UI"]["Lang"]
	get_parent().get_parent().get_parent().add_child(editor)
	get_parent().get_parent().queue_free()
	pass # Replace with function body.
