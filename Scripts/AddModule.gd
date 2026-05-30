extends Control



func _ready() -> void:
	$Button.pressed.connect(addfunc)

func _process(delta: float) -> void:
	if has_node("Cont"):
		$Cont.size.x = 9
		size.x = $Cont.size.x + 20
		custom_minimum_size.x = size.x
	$Button.size.x = size.x
	if size.x + 10 > get_parent().get_parent().get_parent().get_parent().size.x:
		get_parent().get_parent().get_parent().get_parent().size.x = size.x + 10
		get_parent().get_parent().get_parent().get_parent().get_parent().size.x = size.x + 20

func addfunc():
	print("ogo")
	var ogi = get_parent().get_parent().get_parent().get_parent().get_parent()
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(ogi.get_node("Buttons/Plus"), "scale", Vector2(1, 1), 1)
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(ogi.get_node("Buttons/Play"), "scale", Vector2(1, 1), 1)
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(ogi.get_node("Buttons/openFE"), "scale", Vector2(1, 1), 1)
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(ogi.get_node("Bak/Back"), "scale", Vector2(1, 0.001), 1)
	get_parent().get_parent().get_parent().get_parent().get_parent().get_node("OCM").funcselected = true
	get_parent().get_parent().get_parent().get_parent().get_parent().get_node("OCM").funco = name
