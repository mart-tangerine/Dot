extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for x in $Visual/Scroll/Projects.get_children():
		x.size.x = Disp.x - 90
		x.custom_minimum_size.x = Disp.x - 90
		x.get_node("Touch").size.x = Disp.x - 90
	pass
