extends VBoxContainer

var module_script = load("res://Scripts/AddModule.gd")
func _ready():
	for y in range(len(get_children())):
		var x = get_children()
		if x is Panel:
			x.set_script(null) # Сначала полностью отвязываем старый (даже если его нет)
			x.set_script(module_script)
			x.offsett = x.position.y
			x.set_process(true)
