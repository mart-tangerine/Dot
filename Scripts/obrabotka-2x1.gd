extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ned = [get_parent().get_node("Scroll"), get_parent().get_node("Scroll2")]
	for x in ned:
		x.size.x = get_parent().size.x - 5 - x.position.x
	pass
