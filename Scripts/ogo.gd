extends LineEdit
var fr = []
func _ready() -> void:
	gui_input.connect(kal)

func _process(delta: float) -> void:
	fr = str_to_var("[" + text + "]")
	$Label.text = ""
	if fr:
		if typeof(fr[0]) == TYPE_ARRAY:
			for x in fr:
				match x[0]:
					"numb":
						$Label.text += str(x[1])
					"str":
						$Label.text += '"' + str(x[1]) + '"'
					"math":
						$Label.text += " " + Dot.symbs[x[1]] + " "
					"func":
						$Label.text += " " + Dot.symbs[x[1]] + " "
					"var":
						$Label.text += x[1]
					"lelem":
						$Label.text += "элемент " + x[1] + " ["
					"lvar":
						$Label.text += x[1]
					"fun_tc":
						$Label.text += "касается объекта " + x[1] + " ?"

func kal(event):
	if event is InputEventMouseButton:
		if event.pressed == true:
			if has_focus():
				var me = self
				var it = get_parent()
				while it.name != "Game":
					it = it.get_parent()
				it.FE = me
