extends Panel


# Called when the node enters the scene tree for the first time.
func _process(_delta) -> void:
	if get_parent().name != "PHolders":
		name = $Title.text
	$Size.text = str(int($Panel/Icon.texture.get_size().x)) + "x" + str(int($Panel/Icon.texture.get_size().y))
	$Title.size.x = size.x - 120
	$Delete.position.x = size.x - 50

func _on_delete_pressed() -> void:
	queue_free()
	pass # Replace with function body.
