extends Panel
var velic = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_parent().custom_minimum_size.x = size.x
	if has_node("Cont"):
		$Cont.custom_minimum_size.x = size.x
		var ogo = 0
		for x in $Cont.get_children():
			ogo += x.size.x
			if x is LineEdit:
				if len(x.get_children()) == 0:
					x.custom_minimum_size.x = 80 + len(x.text) * 10
					x.size.x = 80 + len(x.text) * 10
		if size.x - 30 > ogo:
			custom_minimum_size.x = 100
			size.x = 100
		if size.x - 20 < ogo:
			custom_minimum_size.x = ogo + 30
	pass
