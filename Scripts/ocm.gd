extends CanvasLayer
var target = null
var funcselected = false
var chosd = false
var funco = null
var lt = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Panel.visible = true
	$Choc.visible = false
func tickk() -> void:
	scale = Vector2(Disp.mod, Disp.mod)
	if target == null:
		hide()
	else:
		$Panel/Add.modulate = Color(1, 1, 1, 1)
		$Panel/Add/addmodule.show()
		for x in ["Var"]:
			if x in target.get_parent().get_parent().name:
				$Panel/Add.modulate = Color(0.85, 0.85, 0.85, 1)
				$Panel/Add/addmodule.hide()
				if $Choc.visible:
					$Choc.hide()
					$Panel.show()
		visible = true
	if lt != target:
		lt = target
		$Choc.hide()
		$Panel.show()
	if not chosd and target:
		if Input.is_key_pressed(KEY_ALT):
			_on_addmodule_pressed()
		if Input.is_key_pressed(KEY_DELETE) and "Forms" not in target.name:
			_on_remmodule_pressed()

func _on_redacttext_pressed() -> void:
	chosd = true
	target.grab_focus()
	print("brabb")
	target = null
	pass

func paste_module():
	chosd = true
	if %Holders.has_node("Copied"):
		var ogo = %Holders.get_node("Copied").duplicate()
		ogo.name = ogo.get_meta("ON")
		target.add_child(ogo)
	target = null

func copy_module():
	chosd = true
	var ogo = target.get_parent().duplicate()
	ogo.set_meta("ON", ogo.name)
	ogo.name = "Copied"
	if %Holders.has_node("Copied"):
		%Holders.get_node("Copied").free()
	get_parent().get_node("Holders").add_child(ogo)
	target = null

func _on_addmodule_pressed() -> void:
	DisplayServer.virtual_keyboard_hide()
	$Panel.hide()
	chosd = true
	%ModlKat.show()
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(get_parent().get_node("Buttons/Plus"), "scale", Vector2(1, 0.001), 1)
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(get_parent().get_node("Buttons/Play"), "scale", Vector2(1, 0.001), 1)
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(get_parent().get_node("Buttons/openFE"), "scale", Vector2(1, 0.001), 1)
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(get_parent().get_node("Bak/Back"), "scale", Vector2(1, 1), 1)
	funcselected = false
	while not funcselected:
		await get_tree().create_timer(0.1).timeout
	var plus = %Holders.get_node(str(funco)).duplicate()
	if target is LineEdit:
		target.add_child(plus)
	elif target:
		target.get_parent().get_parent().get_parent().add_child(plus)
		target.get_parent().get_parent().queue_free()
	$Panel.show()
	%ModlKat.hide()
	plus.position = Vector2.ZERO
	print("brabbom")
	target = null
	pass


func _on_remmodule_pressed() -> void:
	DisplayServer.virtual_keyboard_hide()
	chosd = true
	target.get_parent().get_parent().queue_free()
	target = null
	pass
