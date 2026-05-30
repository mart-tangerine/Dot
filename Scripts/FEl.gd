extends Control
var targ = null
var data = {}
@onready var spr : Sprite2D = $Control/Node/Sprite
func _process(delta: float) -> void:
	if targ:
		var tex = get_parent().get_node("Project").get_node(str(targ.get_parent().name)).get_node(str(targ.name)).get_node("Sprite").texture
		$Control/Node/Sprite.texture = tex
		if visible:
			if not data.has(str(targ.get_parent().name)):
				data[str(targ.get_parent().name)] = {}
			var dat = {
				"Sprite" : $Panel/VBoxContainer/sprite.get_item_text($Panel/VBoxContainer/sprite.get_selected_id()),
				"Posx" : $Panel/VBoxContainer/posx/HSlider.value,
				"Posy" : $Panel/VBoxContainer/posy/HSlider.value,
				"Sizx" : $Panel/VBoxContainer/sizx/HSlider.value,
				"Sizy" : $Panel/VBoxContainer/sizy/HSlider.value,
				"Modl" : $Panel/VBoxContainer/modl.color
			}
			data[str(targ.get_parent().name)][str(targ.name)] = dat
	spr.position.x = $Panel/VBoxContainer/posx/HSlider.value
	spr.position.y = -$Panel/VBoxContainer/posy/HSlider.value
	spr.scale.x = $Panel/VBoxContainer/sizx/HSlider.value
	spr.scale.y = $Panel/VBoxContainer/sizy/HSlider.value
	if $Panel/VBoxContainer/sprite.get_selected_id() != -1:
		if get_parent().get_node("Files/Files/Hernya/Fles/").has_node($Panel/VBoxContainer/sprite.get_item_text($Panel/VBoxContainer/sprite.get_selected_id())):
			spr.texture = get_parent().get_node("Files/Files/Hernya/Fles/").get_node($Panel/VBoxContainer/sprite.get_item_text($Panel/VBoxContainer/sprite.get_selected_id())).get_node("Panel/Icon").texture
	spr.modulate = $Panel/VBoxContainer/modl.color
	var sls = $Panel.size.x - 153
	$Panel/VBoxContainer/posx/HSlider.custom_minimum_size.x = sls
	$Panel/VBoxContainer/posy/HSlider.custom_minimum_size.x = sls
	$Panel/VBoxContainer/sizx/HSlider.custom_minimum_size.x = sls + 9
	$Panel/VBoxContainer/sizy/HSlider.custom_minimum_size.x = sls + 9
	
	if targ == null:
		$Panel/Label.show()
		$Panel/VBoxContainer.hide()
		$Control.hide()
	else:
		$Control.show()
		$Panel/Label.hide()
		$Panel/VBoxContainer.show()
	pass


func posx_reset() -> void:
	$Panel/VBoxContainer/posx/HSlider.value = 0
	pass # Replace with function body.


func posy_reset() -> void:
	$Panel/VBoxContainer/posy/HSlider.value = 0
	pass # Replace with function body.




func sizx_reset() -> void:
	$Panel/VBoxContainer/sizx/HSlider.value = 1
	pass # Replace with function body.


func sizy_reser() -> void:
	$Panel/VBoxContainer/sizy/HSlider.value = 1
	pass # Replace with function body.
