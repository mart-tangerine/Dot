extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var editor = load("res://editor.tscn").instantiate()
	await get_tree().create_timer(0.05).timeout
	$Dot.position = DisplayServer.window_get_size() / 2.0
	$Parts.position = DisplayServer.window_get_size() / 2.0
	$ColorRect.size = DisplayServer.window_get_size()
	await get_tree().create_timer(0.15).timeout
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Dot, "scale", Vector2(0.3, 0.3), 0.4)
	await get_tree().create_timer(0.45).timeout
	$Dot.modulate = Color.WHITE
	$Dot.scale = Vector2(0.32, 0.32)
	create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE).tween_property($Dot, "modulate", Color("e6a9ff"), 0.2)
	create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO).tween_property($Dot, "scale", Vector2(0, 0), 0.8)
	await get_tree().create_timer(0.8).timeout
	$Parts.emitting = true
	await get_tree().create_timer(0.1).timeout
	$Parts.emitting = false
	create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO).tween_property($ColorRect, "modulate", Color(1, 1, 1, 1), 1)
	await get_tree().create_timer(1).timeout
	get_viewport().transparent_bg = false
	RenderingServer.set_default_clear_color(Color(0, 0, 0, 1))
	editor.modulate = Color(0, 0, 0, 1)
	get_parent().add_child(editor)
	queue_free()
	pass # Replace with function body.
