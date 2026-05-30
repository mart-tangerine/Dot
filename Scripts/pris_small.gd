extends Panel
var velic = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in get_children():
		if x is LineEdit:
			x.set_meta("basex", x.position.x)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent().name == "Holders":
		return
	size.x = get_parent().size.x
	for x in get_children():
		if x is LineEdit:
			x.size.x = (size.x / 2)
			x.position.x = (x.get_meta("basex")) * x.anchor_right
			var base_x = x.get_meta("basex", 0.0)
			var offset_x = ((size.x / 2) - 110) * x.anchor_right
			x.position.x = offset_x
			if "Not" in name:
				x.position.x = 40
				x.size.x = size.x - 50
			if "Reverse" in name:
				x.position.x = 40
				x.size.x = size.x - 50
	if size.x < 120:
		velic += 25
		velic *= 2
		rastyag(get_parent())
	else:
		velic /= 10
		
	pass

func rastyag(node):
	if size.x < 100:
		if "Forms" in node.name:
			node.size.x += velic
			node.custom_minimum_size.x = node.size.x
		elif node.name != "Game":
			rastyag(node.get_parent())
