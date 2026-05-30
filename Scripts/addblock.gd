extends Panel
var button = null
@onready var basey = size.y
@onready var comment = TextureButton.new()
func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	$Drag.mouse_filter = MOUSE_FILTER_PASS
	if size.y > 100:
		button = TextureButton.new()
		button.toggle_mode = true
		button.size = Vector2(30, 30)
		button.ignore_texture_size = true
		button.texture_normal = load("res://Icons/downarrow.png")
		button.texture_pressed = load("res://Icons/rightarrow.png")
		button.position.y = 10
		clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW
		button.name = "Scr"
		add_child(button)
	comment.toggle_mode = true
	comment.ignore_texture_size = true
	comment.texture_normal = load("res://Icons/comment.png")
	comment.texture_pressed = load("res://Icons/comment.png")
	comment.position.y = 10
	comment.size = Vector2(30, 30)
	clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW
	comment.name = "Com"
	if str(name) not in ["comment", "image"]:
		add_child(comment)
	
func _on_drag_pressed():
	get_parent().get_parent().get_parent().hide()
	var ogi = get_parent().get_parent().get_parent().get_parent()
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(ogi.get_node("Buttons/Plus"), "scale", Vector2(1, 1), 1)
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(ogi.get_node("Buttons/Play"), "scale", Vector2(1, 1), 1)
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(ogi.get_node("Buttons/openFE"), "scale", Vector2(1, 1), 1)
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(ogi.get_node("Bak/Back"), "scale", Vector2(1, 0.001), 1)
	var me = duplicate()
	me.name += "_" + str(Time.get_unix_time_from_system())
	var itt = ""
	for x in get_parent().get_parent().get_parent().get_parent().get_node("Scripts").get_children():
		if x.visible:
			itt = str(x.name)
	for it in get_parent().get_parent().get_parent().get_parent().get_node("Scripts").get_node(itt).get_children():
		if it.visible:
			while it.has_node(str(me.name)):
				me.name += ";"
	me.set_script(load("res://Scripts/block.gd"))
	me.get_node("Drag").size.x = 60
	get_parent().get_parent().get_parent().get_parent().get_node("Click").play()
	for x in get_parent().get_parent().get_parent().get_parent().get_node("Scripts").get_node(itt).get_children():
		if x.visible:
			var o : ScrollContainer = get_parent().get_parent().get_parent().get_parent().get_node("Scripts").get_node(itt)
			var s = []
			var i = 0
			for y in x.get_children():
				i += y.size.y
				s.append(i)
			for j in range(len(s)):
				var y = s[j]
				if y > o.scroll_vertical:
					x.add_child(me)
					x.move_child(me, j)
					break
			if len(s) < 1:
				x.add_child(me)

func _process(delta: float) -> void:
	$Drag.size = size
	if button:
		button.position.x = size.x - 46
	comment.position.x = size.x - 26
