extends Panel

func _on_delete_pressed() -> void:
	queue_free()
	pass # Replace with function body.

func _process(_delta) -> void:
	if get_parent().name != "PHolders":
		name = $Title.text
	if $Audio.stream:
		$Size.text = str(int($Audio.stream.get_length())) + " сек."
	$Title.size.x = size.x - 120
	$Delete.position.x = size.x - 50
