extends Control
var fr = []
var cursor = 0
var lc = 0
var targ = null
const mth = {
	"plus" : "+",
	"minus" : "-",
	"mult" : "*",
	"div" : "/",
	"step" : "^",
	"=" : "=",
	"n=" : "~=",
	">" : ">",
	"<" : "<"
}

func tickk() -> void:
	$Penl/RTL.text = ""
	if targ:
		show()
		targ.text = str(fr).trim_prefix("[").trim_suffix("]")
	else:
		hide()
	for y in range(len(fr)):
		var x = fr[y]
		if y == cursor:
			$Penl/RTL.text += "|"
		match x[0]:
			"numb":
				$Penl/RTL.text += "[color=#ff4444]" + str(x[1]) + "[/color]"
			"str":
				$Penl/RTL.text += "[color=#ffbb44]'" + str(x[1]) + "'[/color]"
			"math":
				$Penl/RTL.text += "[color=#44ff66] " + Dot.symbs[x[1]] + " [/color]"
			"func":
				$Penl/RTL.text += "[color=#11ffaa]" + Dot.symbs[x[1]] + "[/color]"
			"var":
				$Penl/RTL.text += "[color=#ff6611]" + x[1] + "[/color]"
			"lvar":
				$Penl/RTL.text += "[color=#ff7777]" + x[1] + "[/color]"
			"lelem":
				$Penl/RTL.text += "[color=#ff6611]элемент " + x[1] + " [[/color]"
			"fun_tc":
				$Penl/RTL.text += "[color=#11ffaa]касается объекта " + x[1] + " ?[/color]"
	if cursor == len(fr):
		$Penl/RTL.text += "|"
	if cursor != lc:
		lc = cursor
		$text.text = ""
		if lc > 0:
			if fr[lc - 1][0] == "str":
				$text.text = fr[lc - 1][1]
	var ld = lc
	if lc == 0:
		ld += 1
	if !fr.is_empty():
		if ld - 1 >= 0 and cursor != 0:
			if fr[ld - 1][0] == "str":
				if len($text.text) > 0:
					fr[ld - 1][1] = $text.text
				else:
					fr.pop_at(ld - 1)
					cursor -= 1
			elif len($text.text) > 0:
				fr.insert(ld, ["str", $text.text])
				cursor += 1
				lc += 1
	else:
		if len($text.text) > 0:
			fr.insert(0, ["str", $text.text])
			cursor += 1
			lc += 1
		
func one() -> void:
	fr.insert(cursor, ["numb", 1])
	cursor += 1


func two() -> void:
	fr.insert(cursor, ["numb", 2])
	cursor += 1

func dot() -> void:
	fr.insert(cursor, ["numb", "."])
	cursor += 1

func plus() -> void:
	fr.insert(cursor, ["math", "plus"])
	cursor += 1

func minus() -> void:
	fr.insert(cursor, ["math", "minus"])
	cursor += 1


func mult() -> void:
	fr.insert(cursor, ["math", "mult"])
	cursor += 1

func div() -> void:
	fr.insert(cursor, ["math", "div"])
	cursor += 1

func step() -> void:
	fr.insert(cursor, ["math", "step"])
	cursor += 1

func pi() -> void:
	fr.insert(cursor, ["func", "pi"])
	cursor += 1


func del() -> void:
	fr.pop_at(cursor - 1)
	cursor -= 1
	if cursor < 0:
		cursor = 0


func three() -> void:
	fr.insert(cursor, ["numb", 3])
	cursor += 1

func close() -> void:
	fr.insert(cursor, ["func", ")"])
	cursor += 1


func open() -> void:
	fr.insert(cursor, ["func", "("])
	cursor += 1

func sinn() -> void:
	fr.insert(cursor, ["func", "sin"])
	cursor += 1


func four() -> void:
	fr.insert(cursor, ["numb", 4])
	cursor += 1


func five() -> void:
	fr.insert(cursor, ["numb", 5])
	cursor += 1


func six() -> void:
	fr.insert(cursor, ["numb", 6])
	cursor += 1


func seven() -> void:
	fr.insert(cursor, ["numb", 7])
	cursor += 1


func eight() -> void:
	fr.insert(cursor, ["numb", 8])
	cursor += 1


func nine() -> void:
	fr.insert(cursor, ["numb", 9])
	cursor += 1


func zero() -> void:
	fr.insert(cursor, ["numb", 0])
	cursor += 1

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_LEFT:
			cursor -= 1
			if cursor < 0:
				cursor = 0
		if event.keycode == KEY_RIGHT:
			cursor += 1
			if cursor > len(fr):
				cursor = len(fr)


func comma() -> void:
	fr.insert(cursor, ["func", ","])
	cursor += 1


func rand() -> void:
	fr.insert(cursor, ["func", "rand"])
	cursor += 1

func unix() -> void:
	fr.insert(cursor, ["func", "unix"])
	cursor += 1

func left() -> void:
	cursor -= 1
	if cursor < 0:
		cursor = 0

func right() -> void:
	cursor += 1
	if cursor > len(fr):
		cursor = len(fr)

func posx() -> void:
	fr.insert(cursor, ["func", "posx"])
	cursor += 1

func posy() -> void:
	fr.insert(cursor, ["func", "posy"])
	cursor += 1

func sizx() -> void:
	fr.insert(cursor, ["func", "sizx"])
	cursor += 1

func sizy() -> void:
	fr.insert(cursor, ["func", "sizy"])
	cursor += 1

func rond() -> void:
	fr.insert(cursor, ["func", "round"])

func back() -> void:
	targ = null


func flor() -> void:
	fr.insert(cursor, ["func", "floor"])
	cursor += 1

func cel() -> void:
	fr.insert(cursor, ["func", "ceil"])
	cursor += 1
	
func math() -> void:
	$mathh.show()
	$data.hide()
	$objj.hide()
	$logicc.hide()
	$devv.hide()

func obj() -> void:
	$objj.show()
	$data.hide()
	$mathh.hide()
	$logicc.hide()
	$devv.hide()

func logic() -> void:
	$logicc.show()
	$data.hide()
	$mathh.hide()
	$objj.hide()
	$devv.hide()

func data() -> void:
	$logicc.hide()
	$mathh.hide()
	$objj.hide()
	$data.show()
	$devv.hide()
	
func dev() -> void:
	$logicc.hide()
	$mathh.hide()
	$objj.hide()
	$data.hide()
	$devv.show()

func equal() -> void:
	fr.insert(cursor, ["math", "="])
	cursor += 1

func nequal() -> void:
	fr.insert(cursor, ["math", "n="])
	cursor += 1

func bigger() -> void:
	fr.insert(cursor, ["math", ">"])
	cursor += 1

func lesser() -> void:
	fr.insert(cursor, ["math", "<"])
	cursor += 1

func andd() -> void:
	fr.insert(cursor, ["math", "and"])
	cursor += 1

func orr() -> void:
	fr.insert(cursor, ["math", "or"])
	cursor += 1

func nott() -> void:
	fr.insert(cursor, ["math", "not"])
	cursor += 1

func fals() -> void:
	fr.insert(cursor, ["math", "false"])
	cursor += 1

func tru() -> void:
	fr.insert(cursor, ["math", "true"])
	cursor += 1

func joinn() -> void:
	fr.insert(cursor, ["func", "join"])
	cursor += 1

func lenn() -> void:
	fr.insert(cursor, ["func", "len"])
	cursor += 1

func rev() -> void:
	fr.insert(cursor, ["func", "rev"])
	cursor += 1

func cosinn() -> void:
	fr.insert(cursor, ["func", "cos"])
	cursor += 1


func inf() -> void:
	fr.insert(cursor, ["func", "inf"])
	cursor += 1
	pass # Replace with function body.


func varr(juj) -> void:
	fr.insert(cursor, ["var", juj])
	cursor += 1

func lvarr(juj) -> void:
	fr.insert(cursor, ["lvar", juj])
	cursor += 1


func lelem(juj) -> void:
	fr.insert(cursor, ["lelem", juj])
	fr.insert(cursor + 1, ["numb", 1])
	fr.insert(cursor + 2, ["numb", ']'])
	cursor += 3

func tann() -> void:
	fr.insert(cursor, ["func", "tan"])
	cursor += 1


func mposx() -> void:
	fr.insert(cursor, ["func", "mposx"])
	cursor += 1


func mposy() -> void:
	fr.insert(cursor, ["func", "mposy"])
	cursor += 1


func touchx() -> void:
	fr.insert(cursor, ["func", "tocx"])
	fr.insert(cursor + 1, ["numb", 1])
	fr.insert(cursor + 2, ["func", "]"])
	cursor += 3

func touchy() -> void:
	fr.insert(cursor, ["func", "tocy"])
	fr.insert(cursor + 1, ["numb", 1])
	fr.insert(cursor + 2, ["func", "]"])
	cursor += 3


func touchs() -> void:
	fr.insert(cursor, ["func", "tocs"])
	cursor += 1


func asinn() -> void:
	fr.insert(cursor, ["func", "asin"])
	cursor += 1


func acosinn() -> void:
	fr.insert(cursor, ["func", "acos"])
	cursor += 1


func atann() -> void:
	fr.insert(cursor, ["func", "atan"])
	cursor += 1


func year() -> void:
	fr.insert(cursor, ["func", "year"])
	cursor += 1

func month() -> void:
	fr.insert(cursor, ["func", "month"])
	cursor += 1

func weekday() -> void:
	fr.insert(cursor, ["func", "weekday"])
	cursor += 1

func day() -> void:
	fr.insert(cursor, ["func", "day"])
	cursor += 1

func hour() -> void:
	fr.insert(cursor, ["func", "hour"])
	cursor += 1

func minute() -> void:
	fr.insert(cursor, ["func", "minute"])
	cursor += 1

func second() -> void:
	fr.insert(cursor, ["func", "second"])
	cursor += 1


func rot() -> void:
	fr.insert(cursor, ["func", "rot"])
	cursor += 1

func skew() -> void:
	fr.insert(cursor, ["func", "skew"])
	cursor += 1

func tcss(nm : String) -> void:
	fr.insert(cursor, ["fun_tc", nm])
	cursor += 1


func presd() -> void:
	fr.insert(cursor, ["func", "presd"])
	cursor += 1


func clone() -> void:
	fr.insert(cursor, ["func", "clone"])
	cursor += 1


func leseq() -> void:
	fr.insert(cursor, ["math", "≤"])
	cursor += 1

func bigeq() -> void:
	fr.insert(cursor, ["math", "≥"])
	cursor += 1


func abss() -> void:
	fr.insert(cursor, ["func", "abs"])
	cursor += 1


func osu() -> void:
	fr.insert(cursor, ["func", "os"])
	cursor += 1


func osver() -> void:
	fr.insert(cursor, ["func", "osver"])
	cursor += 1


func gpu() -> void:
	fr.insert(cursor, ["func", "gpu"])
	cursor += 1


func cpu() -> void:
	fr.insert(cursor, ["func", "cpu"])
	cursor += 1
