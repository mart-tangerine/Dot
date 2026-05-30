extends Panel
var ogo = 0
var oop = 0

var dragging: bool = false
var start_mouse_offset: Vector2
var placeholder: Control
var ogogoo
var opasn = 0
var basey = size.y
func _on_button_pressed() -> void:
	get_parent().get_parent().get_parent().get_parent().get_node("Click").play()
	for x in get_parent().get_parent().get_parent().get_parent().get_node("Objects/Objs").get_children():
		if x.name == name:
			x.show()
		else:
			x.hide()


func _on_delete_pressed() -> void:
	queue_free()
	pass # Replace with function body.


func _on_main_pressed() -> void:
	for x in get_parent().get_children():
		x.get_node("Main").modulate = Color("ffffff58")
	$Main.modulate = Color(0.952, 0.85, 1.0, 0.694)
	pass # Replace with function body.

func _ready() -> void:
	if "Scenesss" in str(name):
		return
	clip_children = CanvasItem.CLIP_CHILDREN_DISABLED
	$Drag.button_down.connect(_on_button_down)
	$Drag.button_up.connect(_on_button_up)
	if has_node("Scr"):
		get_node("Scr").button_up.connect(on_clp)
	if has_node("Com"):
		get_node("Com").button_up.connect(on_com)
		
func on_com():
	get_parent().get_parent().get_parent().get_parent().get_node("Click").play()
	if (modulate.r + modulate.g + modulate.b) < 2.2:
		modulate = Color(1, 1, 1, 1)
	else:
		modulate = Color(0.5, 0.5, 0.5, 1)

func on_clp():
	get_parent().get_parent().get_parent().get_parent().get_node("Click").play()
	if custom_minimum_size.y > 100:
		clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW
		create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(self, "custom_minimum_size", Vector2(custom_minimum_size.x, 33), 0.6)
	else:
		clip_children = CanvasItem.CLIP_CHILDREN_DISABLED
		create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(self, "custom_minimum_size", Vector2(custom_minimum_size.x, basey), 0.6)

func _process(_delta: float) -> void:
	if "Scenesss" in str(name):
		return
	rotation = sin(ogo) / 45
	$Drag.size.y = size.y
	$Drag.size.x = 60
	if dragging:
		ogo += (20.26 * _delta)
		oop = 2
		_drag_update()
		if ogo > 6:
			ogo -= 6
		if position.x > Disp.x - (100 / Disp.mod):
			queue_free()
	else:
		ogo = (ogo) / 1.5
	if has_node("Scr"):
		get_node("Scr").position.x = size.x - 46
	if has_node("Com"):
		get_node("Com").position.x = size.x - 26
	if size.y > 100 and basey < 100:
		basey = size.y

func _on_button_down() -> void:
	get_parent().get_parent().get_parent().get_parent().get_node("OCM").target = null
	dragging = true
	start_mouse_offset = get_global_mouse_position() - global_position
	placeholder = Control.new()
	placeholder.custom_minimum_size = size
	scale = Vector2(1, 1) * Disp.mod
	get_parent().add_child(placeholder)
	get_parent().move_child(placeholder, get_index())
	top_level = true
	z_index = 100

func _on_button_up() -> void:
	if not dragging:
		return
	dragging = false
	get_parent().get_parent().get_parent().get_parent().get_node("Click").play()
	
	top_level = false
	z_index = 0
	
	var final_dima = placeholder.get_index()
	get_parent().move_child(self, final_dima)
	
	placeholder.queue_free()
	position = Vector2.ZERO

func _drag_update() -> void:
	global_position = get_global_mouse_position() - start_mouse_offset
	var new_dima = _get_drop_index(global_position.y + size.y / 2)
	if get_parent().get_child(new_dima) != placeholder:
		get_parent().move_child(placeholder, new_dima)

func _get_drop_index(y_pisun: float) -> int:
	var target_index = 0
	for i in range(get_parent().get_child_count()):
		var child = get_parent().get_child(i)
		if child == placeholder or child == self: 
			continue
		
		if y_pisun > child.global_position.y + child.size.y / 2:
			target_index = i + 1
		else:
			break
	return target_index
