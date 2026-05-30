extends Control
var OCM = null
var FE = null
var code : Dictionary = {}
var ifs : Dictionary = {}
var og : float = 0.0
var vars : Dictionary = {}
var colls : Dictionary = {}
var delta : float = 0.0
var formulas : bool = false
var lnc : bool = false
var targ : Node = null
var tchs : int = 0
var ist : bool = false
var tcha : Array = []
var tss : int = 0
var tind: Dictionary = {}
@onready var pst = PostProcess.new()
@onready var conf : PostProcessingConfiguration
@onready var ncon : Environment = $Post.environment
@onready var lua : LuaState = LuaState.new()
var mode : bool = false
var projname : String = "babushka_kushaet"
var customs : Dictionary = {
	"efr" : [],
	"sig" : {},
	"ks" : []
}

const mth : Dictionary = {
	"plus" : "+",
	"minus" : "-",
	"mult" : "*",
	"div" : "/",
	"step" : "^",
	"=" : "==",
	"n=" : "~=",
	">" : ">",
	"<" : "<",
	"≥" : ">=",
	"≤" : "<=",
	"and" : " and ",
	"or" : " or ",
	"not" : " not ",
	"true" : " true ",
	"false" : " false "
}
# Called when the node enters the scene tree for the first time.
func _play():
	vars = {}
	tss = 0
	tcha = []
	var line : Line2D = $Project/Pen/Line2D
	line.clear_points()
	line.width = 10
	line.default_color = Color(0, 0, 0, 1)
	line.gradient = null
	$Project/Bg.modulate = Color(1, 1, 1, 1)
	mode = true
	var mainscene = null
	for x in $Objects/Objs/Scenesss.get_children():
		if x.get_node("Main").modulate == Color(0.952, 0.85, 1.0, 0.694):
			mainscene = str(x.name)
	$Project.visible = mode
	for y in $Project.get_children():
		if y is Node2D and not y is CanvasModulate:
			y.skew = 0
			y.rotation = 0
			y.pos = Vector2(0, 0)
			y.zoom = Vector2(1, 1)
		for x in y.get_children():
			if "__Clone" in x.name:
				x.free()
	if mode:
		code = await _compilyarka(false)
		_vipolnn(mainscene)

func _stop():
	conf.Blur = false
	conf.Pixelate = false
	conf.L_O_D = 0
	conf.PixelatePixelSize = 1
	conf.CRT = false
	conf.Glitch = false
	conf.Grain = false
	conf.GrainPower = 0
	conf.Vignette = false
	conf.VignetteR_G_B = Color(0, 0, 0)
	conf.VignetteIntensity = 0
	conf.VignetteOpacity = 0.5
	conf.ASCII = false
	conf.ASCIISize = Vector2(4, 9)
	ncon.adjustment_brightness = 1
	ncon.adjustment_contrast = 1
	ncon.adjustment_saturation = 1
	ncon.glow_intensity = 0
	ncon.glow_bloom = 0
	conf.ScreenShakePower = 0
	conf.ScreenShake = false
	og = 0
	mode = false
	Engine.time_scale = 1
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR)
	for x in $Files/Files/Hernya/Snds.get_children():
		x.get_node("Audio").stop()
	$Project.visible = mode
	customs = {
	"efr" : [],
	"sig" : {},
	"ks" : []
	}
	for x in $Project/UIelems.get_children():
		x.queue_free()
	for x in $Project/Partics.get_children():
		x.queue_free()
	if lnc:
		var menu = load("res://editor.tscn").instantiate()
		get_parent().add_child(menu)
		queue_free()

func transl(node : Node):
	if "text" in node:
		for w in Dot.table:
			node.text = node.text.replace(w, Dot.table[w][Dot.lang])
	for x in node.get_children():
		transl(x)
			

func _ready() -> void:
	conf = PostProcessingConfiguration.new()
	pst.configuration = conf
	add_child(pst)
	lua.open_libraries(LuaState.ALL_LIBS)
	var proj = str_to_var(FileAccess.get_file_as_string("user://Projects/" + projname + "/data.txt"))
	if proj:
		proj["Last"] = Time.get_unix_time_from_system()
		if proj.has("Formulas"):
			formulas = proj["Formulas"]
	else:
		get_tree().quit()
	if formulas:
		for x in $Katalog/Blocks.get_children():
			for y in x.get_children():
				for z in y.get_children():
					if z is HBoxContainer:
						if z.get_node("Scroll/LForms") is LineEdit:
							if z.get_node("Scroll/LForms").get_script() != null:
								z.get_node("Scroll/LForms").free()
								var new : LineEdit = $PHolders/LFS.duplicate()
								new.virtual_keyboard_show_on_focus = false
								new.custom_minimum_size.x = 150
								new.name = "LForms"
								new.set_script(load("res://Scripts/ogo.gd"))
								z.get_node("Scroll").custom_minimum_size.x = 150
								z.get_node("Scroll").add_child(new)
							else:
								z.get_node("Scroll/LForms").free()
								var new = $PHolders/LFDS.duplicate()
								new.custom_minimum_size.x = 150
								new.name = "LForms"
								z.get_node("Scroll").custom_minimum_size.x = 150
								z.get_node("Scroll").add_child(new)
	var setts = str_to_var(FileAccess.get_file_as_string("user://settings.txt"))
	if not setts.has("Projs"):
		setts["Projs"] = {}
	setts["Projs"]["last"] = projname
	var fl = FileAccess.open("user://Projects/" + projname + "/data.txt", FileAccess.WRITE)
	fl.store_string(str(proj))
	fl.close()
	fl = FileAccess.open("user://settings.txt", FileAccess.WRITE)
	fl.store_string(str(setts))
	fl.close()
	OCM = null
	get_window().title = "Dot - Редактирование " + proj["Name"]
	await transl(self)
	await load_proj()
	anchor_bottom = 1 / Disp.mod
	anchor_right = 1 / Disp.mod
	scale = Vector2(Disp.mod, Disp.mod)
	if lnc:
		get_window().title = proj["Name"]
		$Loading/Prog.value = 100
		$Loading/Label.text = "Запуск..."
		$Loading.show()
		$Files.show()
		await get_tree().create_timer(0.4).timeout
		$Loading.hide()
		_play()
	conf.reload = true
	$Files/Files/Hernya/GameName.custom_minimum_size.x = size.x - 60

func nodes_to_formula(fr_node : Node):
	if formulas:
		if fr_node.get_script() == null:
			return fr_node.text
		return str_to_var("[" + fr_node.text + "]")
	var fr = await ntf(fr_node)
	return fr

func ntf(node):
	var ogo = {}
	if "ConMen" in node.name:
		return
	if node is Panel:
		ogo = []
	if len(node.get_children()) == 0:
		ogo = node.text
	else:
		var nod = node
		if nod.has_node("Cont"): nod = nod.get_node("Cont")
		for x in nod.get_children():
			if not x is Label and not "ConMen" in node.name:
				if node is Panel:
					ogo.append(await ntf(x))
				else:
					ogo[x.name] = await ntf(x)
				
	return ogo

func formula_to_nodes(formula, pastein : Node):
	return await ftn(formula, pastein)

func ftn(frm, node):
	if frm is Dictionary:
		for x in frm:
			var newnode = $Holders.get_node(str(x)).duplicate()
			node.add_child(newnode)
			newnode.position = Vector2.ZERO
			var ledits = 0
			for y in newnode.get_node("Cont").get_children():
				if y is LineEdit:
					if frm[x][ledits] is Dictionary:
						await ftn(frm[x][ledits], y)
					else:
						y.text = frm[x][ledits]
					ledits += 1
	else:
		if formulas:
			if node:
				node.text = str(frm).trim_prefix("[").trim_suffix("]")
				if node.get_script() == null:
					node.text = str(frm)
		else:
			node.text = str(frm)
					
		

func vling(formuls, obj : CharacterBody2D):
	if not formulas:
		if typeof(formuls) == TYPE_STRING:
			return formuls
		for x in formuls:
			var y = formuls[x]
			if x == &"Plus":
				return str(float(await vling(y[0], obj)) + float(await vling(y[1], obj))).trim_suffix(".0")
			elif x == &"Minus":
				return str(float(await vling(y[0], obj)) - float(await vling(y[1], obj))).trim_suffix(".0")
			elif x == &"Mult":
				return str(float(await vling(y[0], obj)) * float(await vling(y[1], obj))).trim_suffix(".0")
			elif x == &"Var":
				return str(vars.get(y[0], "0")).trim_suffix(".0")
			elif x == &"Lelem":
				if vars.has(y[1]) and typeof(vars[y[1]]) == TYPE_ARRAY:
					if len(vars[y[1]]) >= int(await vling(y[0], obj)):
						return str(vars[y[1]][int(await vling(y[0], obj)) - 1]).trim_suffix(".0")
				else:
					return ""
			elif x == &"Localvar":
				var vrs = obj.get_meta("vars", {})
				return str(vrs.get(y[0], "0")).trim_suffix(".0") if typeof(vrs) == TYPE_DICTIONARY else "NDi"
			elif x == &"Equal":
				return "true" if await vling(y[0], obj) == await vling(y[1], obj) else "false"
			elif x == &"And":
				return "true" if await vling(y[0], obj) == "true" and await vling(y[1], obj) == "true" else "false"
			elif x == &"Or":
				return "true" if await vling(y[0], obj) == "true" or await vling(y[1], obj) == "true" else "false"
			elif x == &"Bigger":
				return "true" if float(await vling(y[0], obj)) > float(await vling(y[1], obj)) else "false"
			elif x == &"Smaller":
				return "true" if float(await vling(y[0], obj)) < float(await vling(y[1], obj)) else "false"
			elif x == &"Posx":
				return str(obj.position.x).trim_suffix(".0")
			elif x == &"Posy":
				return str(-obj.position.y).trim_suffix(".0")
			elif x == &"Div":
				var second = float(await vling(y[1], obj))
				return str(float(await vling(y[0], obj)) / second).trim_suffix(".0") if second != 0 else "0"
			elif x == &"Step":
				return str(float(await vling(y[0], obj)) ** float(await vling(y[1], obj))).trim_suffix(".0")
			elif x == &"Rand":
				var f = float(await vling(y[0], obj))
				var s = float(await vling(y[1], obj))
				return str(randf_range(f, s)) if f != round(f) or s != round(s) else str(randi_range(f, s))
			elif x == &"Not":
				return "true" if await vling(y[0], obj) != "true" else "false"
			elif x == &"Mod":
				var f = float(await vling(y[0], obj))
				return str(abs(f))
			elif x == &"Round":
				return str(int(round(float(await vling(y[0], obj)))))
			elif x == &"Join":
				return str(await vling(y[0], obj)) + str(await vling(y[1], obj))
			elif x == &"Length":
				return str(str(await vling(y[0], obj)).length())
			elif x == &"Partin":
				return "true" if str(await vling(y[0], obj)) in str(await vling(y[1], obj)) else "false"
			elif x == &"True": 
				return "true"
			elif x == &"False": 
				return "false"
			elif x == &"Inf": 
				return str(INF)
			elif x == &"Pi": 
				return str(PI)
			elif x == &"Sin":
				return str(sin(deg_to_rad(float(await vling(y[0], obj)))))
			elif x == &"Cosin":
				return str(cos(deg_to_rad(float(await vling(y[0], obj)))))
			elif x == &"Tan":
				return str(tan(deg_to_rad(float(await vling(y[0], obj)))))
			elif x == &"Asin":
				return str(asin(deg_to_rad(float(await vling(y[0], obj)))))
			elif x == &"Acosin":
				return str(acos(deg_to_rad(float(await vling(y[0], obj)))))
			elif x == &"Atan":
				return str(atan(deg_to_rad(float(await vling(y[0], obj)))))
			elif x == &"Atan2":
				return str(atan2(deg_to_rad(float(await vling(y[0], obj))), deg_to_rad(float(await vling(y[1], obj)))))
			elif x == &"Ceil":
				return str(int(ceil(float(await vling(y[0], obj)))))
			elif x == &"Floor":
				return str(int(floor(float(await vling(y[0], obj)))))
			elif x == &"Touchs":
				return str(obj.get_node("Touch").is_pressed()).to_lower() if typeof(obj) == TYPE_OBJECT else "false"
			elif x == &"Clone":
				return "true" if "__Clone" in obj.name else "false"
			elif x == &"Unixtime":
				return str(Time.get_unix_time_from_system())
			elif x.ends_with("time"):
				var t = Time.get_datetime_dict_from_system()
				if x == &"Yeartime": return str(t.year)
				if x == &"Monthtime": return str(t.month)
				if x == &"Weekdaytime": return str(t.weekday)
				if x == &"Daytime": return str(t.day)
				if x == &"Hourtime": return str(t.hour)
				if x == &"Minutetime": return str(t.minute)
				if x == &"Secondtime": return str(t.second)
			elif x == &"Mouseposx":
				return str((get_global_mouse_position().x - DisplayServer.window_get_size().x / 2.0) / obj.get_parent().scale.x / Disp.mod).trim_suffix(".0")
			elif x == &"Mouseposy":
				return str(-(get_global_mouse_position().y - DisplayServer.window_get_size().y / 2.0) / obj.get_parent().scale.y / Disp.mod).trim_suffix(".0")
			elif x == &"Touchx":
				var fs = await vling(y[0], obj)
				if len(tcha) >= int(fs):
					return str(tcha[int(fs) - 1][0])
				return "0"
			elif x == &"Touchy":
				var fs = await vling(y[0], obj)
				if len(tcha) >= int(fs):
					return str(tcha[int(fs) - 1][1])
				return "0"
			elif x == &"Touches":
				return str(len(tcha))
			elif x == &"Scalex":
				return str(obj.scale.x).trim_suffix(".0")
			elif x == &"Scaley":
				return str(obj.scale.y).trim_suffix(".0")
			elif x == &"Rotat":
				return str(rad_to_deg(obj.rotation)).trim_suffix(".0")
			elif x == &"Skew":
				return str(rad_to_deg(obj.skew)).trim_suffix(".0")
			elif x == &"Collideobj":
				if colls.has(obj.name):
					return "true" if colls[obj.name].has(await vling(y[0], obj)) else "false"
				return "false"
			elif x == &"GPU":
				return RenderingServer.get_video_adapter_name()
			elif x == &"CPU":
				return OS.get_processor_name()
			elif x == &"System":
				return OS.get_name()
			elif x == &"OSVer":
				return str(OS.get_version())
			elif x == &"Tobase64":
				return Marshalls.raw_to_base64(str(await vling(y[0], obj)).to_utf8_buffer())
			elif x == &"Frombase64":
				return Marshalls.base64_to_raw(str(await vling(y[0], obj))).get_string_from_utf8()
			elif x == &"Tomd5":
				return str(await vling(y[0], obj)).md5_text()
			elif x == &"Reverse":
				return str(await vling(y[0], obj)).reverse()
	else:
		var tocs : String = ""
		var lf : Array = []
		var cur : int = 0
		if typeof(formuls) == TYPE_STRING:
			return formuls
		for y in formuls:
			var tip : String = y[0]
			var iss = y[1]
			match tip:
				"numb":
					tocs += str(iss)
				"str":
					tocs += '"' + iss + '"'
				"math":
					tocs += mth[iss]
				"func":
					
					if iss == "pi":
						tocs += str(PI)
					if iss == "inf":
						tocs += "math.huge"
					if iss == "tocs":
						tocs += "tss"
					if iss in ["year", "month", "weekday", "day", "hour", "minute", "second"]:
						tocs += str(Time.get_datetime_dict_from_system()[iss])
					if iss == "os":
						tocs += '"' + OS.get_name() + '"'
					if iss == "osver":
						tocs += OS.get_version()
					if iss == "cpu":
						tocs += '"' + OS.get_processor_name() + '"'
					if iss == "gpu":
						tocs += '"' + RenderingServer.get_video_adapter_name() + '"'
					if iss == ",":
						if !lf.is_empty() and lf[len(lf) - 1][0] == cur - 1 and lf[len(lf) - 1][1] == "join":
							tocs += ".."
						else:
							tocs += ","
					if iss in "()":
						if iss == "(":
							cur += 1
						else:
							cur -= 1
							if !lf.is_empty() and lf[len(lf) - 1][0] == cur:
								if lf[len(lf) - 1][1] == "sin":
									tocs += ")"
								if lf[len(lf) - 1][1] == "var":
									tocs += "]"
								lf.pop_back()
						tocs += iss
					if iss == "]":
						tocs += "]"
						cur -= 1
						if lf[len(lf) - 1][1] == "x":
							tocs += "[1]"
						if lf[len(lf) - 1][1] == "y":
							tocs += "[2]"
						lf.pop_back()
					if iss in ["tocx", "tocy"]:
						tocs += "mous["
						if iss == "tocx":
							lf.append([cur, "x"])
						else:
							lf.append([cur, "y"])
						cur += 1
					if iss == "join":
						tocs += "("
						lf.append([cur, "join"])
						cur += 1
					if iss == "len":
						tocs += "string.len("
						cur += 1
					if iss == "presd":
						tocs += "ths"
						cur += 1
					if iss == "clone":
						tocs += str("__Clone" in str(obj.name))
						cur += 1
					if iss == "rev":
						tocs += "string.reverse("
						cur += 1
					if iss in ["sin", "cos", "tan"]:
						tocs += "math." + iss + "(math.rad("
						lf.append([cur, "sin"])
						cur += 1
					if iss in ["asin", "acos", "atan"]:
						tocs += "math.deg(math." + iss + "("
						lf.append([cur, "sin"])
						cur += 1
					if iss in ["round", "floor", "ceil", "abs"]:
						if iss == "round":
							tocs += "math.floor(0.5+"
						else:
							tocs += "math." + iss + "("
						cur += 1
					if iss == "rand":
						tocs += "math.random("
					if iss in ["posx", "posy", "sizx", "sizy", "unix", "mposx", "mposy", "rot", "skew"]:
						tocs += iss
				"fun_tc":
					tocs += str(colls[obj.name].has(StringName(iss)))
				"var":
					tocs += "vars['" + iss + "']"
				"lvar":
					tocs += "lvars['" + iss + "']"
				"lelem":
					tocs += "vars['" + iss + "']["
		if len(tocs) < 1: tocs = "''"
		var cod : String = "local posx = " + str(obj.position.x) + "
		local posy = " + str(obj.position.y) + "
		local sizx = " + str(obj.scale.x) + "
		local skew = " + str(rad_to_deg(obj.skew)) + "
		local rot = " + str(obj.rotation_degrees) + "
		local mposy = " + str(-(get_global_mouse_position().y - DisplayServer.window_get_size().y / 2.0) / obj.get_parent().scale.y / Disp.mod) + "
		local mposx = " + str((get_global_mouse_position().x - DisplayServer.window_get_size().x / 2.0) / obj.get_parent().scale.x / Disp.mod) + "
		local sizy = " + str(obj.scale.y) + "
		local unix = " + str(Time.get_unix_time_from_system()) + "
		local vars = " + await luaify(vars) + "
		local lvars = " + await luaify(obj.get_meta("vars")) + "
		local mous = " + str(tcha).replace("[", "{").replace("]", "}") + "
		local tss = " + str(len(tcha)) + "
		local ths = " + str(obj.get_node("Touch").is_pressed()) + "
		return " + tocs
		var res = lua.do_string(cod)
		if res is LuaError:
			return "Ошибка"
		else:
			if res is LuaTable:
				if len(res.to_array()) < 1:
					return res.to_dictionary()
				return res.to_array()
			return res

func luaify(what):
	var vrs : String = "{ "
	for x in what:
		vrs += str(x) + " = "
		if typeof(what[x]) != TYPE_DICTIONARY:
			if typeof(what[x]) == TYPE_STRING:
				vrs += '"'
			if typeof(what[x]) == TYPE_ARRAY:
				vrs += "{"
			var gg : String = str(what[x])
			if typeof(what[x]) == TYPE_ARRAY:
				gg = gg.trim_prefix("[").trim_suffix("]")
			vrs += gg
			if typeof(what[x]) == TYPE_STRING:
				vrs += '"'
			if typeof(what[x]) == TYPE_ARRAY:
				vrs += "}"
			if vars.keys().back() != x:
				vrs += " ,"
		else:
			vrs += await luaify(what[x])
	vrs += " }"
	return vrs

func _compilyarka(sava):
	var ors : Array = $Objects/Objs/Scenesss.get_children()
	var sobi
	var compa : Dictionary = {}
	if sava == false:
		sobi = null
	else:
		sobi = "savoda"
	for rrs in ors:
		var compd : Dictionary = {}
		for ooo in $Objects/Objs.get_node(str(rrs.name)).get_children():
			var cur = str(ooo.name)
			if str(ooo.name) == "Scenesss":
				continue
			if not $Objects/Objs.get_node(str(rrs.name)).has_node(cur):
				continue
			compd[cur] = {}
			var blockss : Array = $Scripts.get_node(str(rrs.name)).get_node(str(ooo.name)).get_children()
			var arr : Array = []
			for b in blockss:
				arr.append([b.position.y, b])
			if sava:
				compd[cur][sobi] = []
			arr.sort()
			for bo in arr:
				var bl : Control = bo[1]
				if not bl is Panel:
					continue
				var nama : String = bl.name
				var commed : bool = (bl.modulate.r + bl.modulate.g + bl.modulate.b) < 2.2
				if sava == false:
					if not commed:
						if nama.begins_with("started_"):
							sobi = "start" + str(randi_range(1000000, 9999999))
							compd[cur][sobi] = []
						if nama.begins_with("asclone_"):
							sobi = "asclone" + str(randi_range(1000000, 9999999))
							compd[cur][sobi] = []
						if nama.begins_with("presd_"):
							sobi = "presd" + str(randi_range(1000000, 9999999))
							compd[cur][sobi] = []
						if nama.begins_with("evrframe_"):
							sobi = "evrframe" + str(randi_range(1000000, 9999999))
							compd[cur][sobi] = []
						if nama.begins_with("rlsed_"):
							sobi = "rlsed:" + str(randi_range(1000000, 9999999))
							compd[cur][sobi] = []
						if nama.begins_with("signal_"):
							sobi = "signal:" + bl.get_node("Pole/Scroll/LForms").text + ":" + str(randi_range(1000000, 9999999))
							compd[cur][sobi] = []
						if nama.begins_with("keyp_"):
							sobi = "keyp:" + bl.get_node("Pole/Scroll/LForms").text + ":" + str(randi_range(1000000, 9999999))
							compd[cur][sobi] = []
							
				else:
					if nama.begins_with("started_"):
						compd[cur][sobi].append(["started", [], commed])
					if nama.begins_with("evrframe_"):
						compd[cur][sobi].append(["evrframe", [], commed])
					if nama.begins_with("asclone_"):
						compd[cur][sobi].append(["asclone", [], commed])
					if nama.begins_with("presd_"):
						compd[cur][sobi].append(["presd", [], commed])
					if nama.begins_with("rlsed_"):
						compd[cur][sobi].append(["rlsed", [], commed])
					if nama.begins_with("signal_"):
						compd[cur][sobi].append(["signal", [bl.get_node("Pole/Scroll/LForms").text], commed])
					if nama.begins_with("keyp_"):
						compd[cur][sobi].append(["keyp", [bl.get_node("Pole/Scroll/LForms").text], commed])
				if sobi == null or not compd[cur].has(sobi):
					continue
				if nama.begins_with("setgravity_"):
					compd[cur][sobi].append([&"setgravity", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("bgcolor_"):
					compd[cur][sobi].append([&"bgcolor", [bl.get_node("Pole/Scroll/LForms").text, bl.get_node("Pole2/Scroll/LForms").text, bl.get_node("Pole3/Scroll/LForms").text, bl.get_node("Pole4/Scroll/LForms").text], commed])
				elif nama.begins_with("setcolor_"):
					compd[cur][sobi].append([&"setcolor", [bl.get_node("Pole/Scroll/LForms").text, bl.get_node("Pole2/Scroll/LForms").text, bl.get_node("Pole3/Scroll/LForms").text, bl.get_node("Pole4/Scroll/LForms").text], commed])
				elif nama.begins_with("lightcolor_"):
					compd[cur][sobi].append([&"lightcolor", [bl.get_node("Pole/Scroll/LForms").text, bl.get_node("Pole2/Scroll/LForms").text, bl.get_node("Pole3/Scroll/LForms").text, bl.get_node("Pole4/Scroll/LForms").text], commed])
				elif nama.begins_with("setambient_"):
					compd[cur][sobi].append([&"setambient", [bl.get_node("Pole/Scroll/LForms").text, bl.get_node("Pole2/Scroll/LForms").text, bl.get_node("Pole3/Scroll/LForms").text, bl.get_node("Pole4/Scroll/LForms").text], commed])
				elif nama.begins_with("linecolor_"):
					compd[cur][sobi].append([&"linecolor", [bl.get_node("Pole/Scroll/LForms").text, bl.get_node("Pole2/Scroll/LForms").text, bl.get_node("Pole3/Scroll/LForms").text, bl.get_node("Pole4/Scroll/LForms").text], commed])
				elif nama.begins_with("linegradient_"):
					compd[cur][sobi].append([&"linegradient", [bl.get_node("Pole/Scroll/LForms").text, bl.get_node("Pole2/Scroll/LForms").text, bl.get_node("Pole3/Scroll/LForms").text, bl.get_node("Pole4/Scroll/LForms").text, bl.get_node("Pole5/Scroll/LForms").text, bl.get_node("Pole6/Scroll/LForms").text, bl.get_node("Pole7/Scroll/LForms").text, bl.get_node("Pole8/Scroll/LForms").text], commed])
				elif nama.begins_with("vincolor_"):
					compd[cur][sobi].append([&"vincolor", [bl.get_node("Pole/Scroll/LForms").text, bl.get_node("Pole2/Scroll/LForms").text, bl.get_node("Pole3/Scroll/LForms").text, bl.get_node("Pole4/Scroll/LForms").text], commed])
				elif nama.begins_with("setrgb_"):
					compd[cur][sobi].append([&"setrgb", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole3/Scroll/LForms"))], commed])
				elif nama.begins_with("newtext_"):
					compd[cur][sobi].append([&"newtext", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole3/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole4/Scroll/LForms"))], commed])
				elif nama.begins_with("redtext_"):
					compd[cur][sobi].append([&"redtext", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole3/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole4/Scroll/LForms"))], commed])
				elif nama.begins_with("newbutton_"):
					compd[cur][sobi].append([&"newbutton", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole3/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole4/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole5/Scroll/LForms"))], commed])
				elif nama.begins_with("redbutton_"):
					compd[cur][sobi].append([&"redbutton", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole3/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole4/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole5/Scroll/LForms"))], commed])
				elif nama.begins_with("newledit_"):
					compd[cur][sobi].append([&"newledit", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole3/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole4/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole5/Scroll/LForms"))], commed])
				elif nama.begins_with("redledit_"):
					compd[cur][sobi].append([&"redledit", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole3/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole4/Scroll/LForms"))], commed])
				elif nama.begins_with("getletext_"):
					compd[cur][sobi].append([&"getletext", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("styletext_"):
					compd[cur][sobi].append([&"styletext", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole3/Scroll/LForms")), bl.get_node("Pole4/Scroll/LForms").text, bl.get_node("Pole5/Scroll/LForms").text, bl.get_node("Pole6/Scroll/LForms").text, bl.get_node("Pole7/Scroll/LForms").text, bl.get_node("Pole8/Scroll/LForms").text, bl.get_node("Pole9/Scroll/LForms").text, bl.get_node("Pole10/Scroll/LForms").text, bl.get_node("Pole11/Scroll/LForms").text], commed])
				elif nama.begins_with("stylebutton_"):
					compd[cur][sobi].append([&"stylebutton", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole3/Scroll/LForms")), bl.get_node("Pole4/Scroll/LForms").text, bl.get_node("Pole5/Scroll/LForms").text, bl.get_node("Pole6/Scroll/LForms").text, bl.get_node("Pole7/Scroll/LForms").text, bl.get_node("Pole8/Scroll/LForms").text, bl.get_node("Pole9/Scroll/LForms").text, bl.get_node("Pole10/Scroll/LForms").text, bl.get_node("Pole11/Scroll/LForms").text, bl.get_node("Pole12/Scroll/LForms").text, bl.get_node("Pole13/Scroll/LForms").text, bl.get_node("Pole14/Scroll/LForms").text, bl.get_node("Pole15/Scroll/LForms").text, bl.get_node("Pole16/Scroll/LForms").text, bl.get_node("Pole17/Scroll/LForms").text, bl.get_node("Pole18/Scroll/LForms").text, bl.get_node("Pole19/Scroll/LForms").text, bl.get_node("Pole20/Scroll/LForms").text, bl.get_node("Pole21/Scroll/LForms").text, bl.get_node("Pole22/Scroll/LForms").text, bl.get_node("Pole23/Scroll/LForms").text, await nodes_to_formula(bl.get_node("Pole24/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole25/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole26/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole27/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole28/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole29/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole30/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole31/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole32/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole33/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole34/Scroll/LForms")) , await nodes_to_formula(bl.get_node("Pole35/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole36/Scroll/LForms"))], commed])
				elif nama.begins_with("applyforce_"):
					compd[cur][sobi].append([&"applyforce", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("alert_"):
					compd[cur][sobi].append([&"alert", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("setsproff_"):
					compd[cur][sobi].append([&"setsproff", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("setcampos_"):
					compd[cur][sobi].append([&"setcampos", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("addcampos_"):
					compd[cur][sobi].append([&"addcampos", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("setcamzoom_"):
					compd[cur][sobi].append([&"setcamzoom", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("addcamzoom_"):
					compd[cur][sobi].append([&"addcamzoom", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("loadfile_"):
					compd[cur][sobi].append([&"loadfile", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms")), bl.get_node("Pole3/Scroll/LForms").text], commed])
				elif nama.begins_with("savefile_"):
					compd[cur][sobi].append([&"savefile", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms")), bl.get_node("Pole3/Scroll/LForms").text], commed])
				elif nama.begins_with("copyclip_"):
					compd[cur][sobi].append([&"copyclip", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("opensite_"):
					compd[cur][sobi].append([&"opensite", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("wait_"):
					compd[cur][sobi].append([&"wait", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("presskey_"):
					compd[cur][sobi].append([&"presskey", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("lightsize_"):
					compd[cur][sobi].append([&"lightsize", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("lighten_"):
					compd[cur][sobi].append([&"lighten", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("waitfor_"):
					compd[cur][sobi].append([&"waitfor", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("waitframe_"):
					compd[cur][sobi].append([&"waitframe", [], commed])
				elif nama.begins_with("setcamrot_"):
					compd[cur][sobi].append([&"setcamrot", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("addcamrot_"):
					compd[cur][sobi].append([&"addcamrot", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("setcamskew_"):
					compd[cur][sobi].append([&"setcamskew", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("addcamskew_"):
					compd[cur][sobi].append([&"addcamskew", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("flipx_"):
					compd[cur][sobi].append([&"flipx", [], commed])
				elif nama.begins_with("flipy_"):
					compd[cur][sobi].append([&"flipy", [], commed])
				elif nama.begins_with("setausp_"):
					compd[cur][sobi].append([&"setausp", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("addausp_"):
					compd[cur][sobi].append([&"addausp", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("playsound_"):
					compd[cur][sobi].append([&"playsound", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("stopsound_"):
					compd[cur][sobi].append([&"stopsound", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("if_"):
					compd[cur][sobi].append([&"if", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("repeat_"):
					compd[cur][sobi].append([&"repeat", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("while_"):
					compd[cur][sobi].append([&"while", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("setposx_"):
					compd[cur][sobi].append([&"setposx", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("addposx_"):
					compd[cur][sobi].append([&"addposx", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("setposy_"):
					compd[cur][sobi].append([&"setposy", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("addposy_"):
					compd[cur][sobi].append([&"addposy", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("setsizex_"):
					compd[cur][sobi].append([&"setsizex", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("addsizex_"):
					compd[cur][sobi].append([&"addsizex", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("setsizey_"):
					compd[cur][sobi].append([&"setsizey", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("addsizey_"):
					compd[cur][sobi].append([&"addsizey", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("setskew_"):
					compd[cur][sobi].append([&"setskew", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("delui_"):
					compd[cur][sobi].append([&"delui", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("reparentui_"):
					compd[cur][sobi].append([&"reparentui", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("movesteps_"):
					compd[cur][sobi].append([&"movesteps", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("toast_"):
					compd[cur][sobi].append([&"toast", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("timescale_"):
					compd[cur][sobi].append([&"timescale", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("vibrate_"):
					compd[cur][sobi].append([&"vibrate", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("addskew_"):
					compd[cur][sobi].append([&"addskew", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("setrot_"):
					compd[cur][sobi].append([&"setrot", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("addrot_"):
					compd[cur][sobi].append([&"addrot", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("onhit_"):
					compd[cur][sobi].append([&"onhit", [], commed])
				elif nama.begins_with("offhit_"):
					compd[cur][sobi].append([&"offhit", [], commed])
				elif nama.begins_with("onphy_"):
					compd[cur][sobi].append([&"onphy", [], commed])
				elif nama.begins_with("offphy_"):
					compd[cur][sobi].append([&"offphy", [], commed])
				elif nama.begins_with("else_"):
					compd[cur][sobi].append([&"else", [], commed])
				elif nama.begins_with("ifend_"):
					compd[cur][sobi].append([&"ifend", [], commed])
				elif nama.begins_with("endcycle_"):
					compd[cur][sobi].append([&"endcycle", [], commed])
				elif nama.begins_with("declo_"):
					compd[cur][sobi].append([&"declo", [], commed])
				elif nama.begins_with("deaclo_"):
					compd[cur][sobi].append([&"deaclo", [], commed])
				elif nama.begins_with("stopapp_"):
					compd[cur][sobi].append([&"stopapp", [], commed])
				elif nama.begins_with("exitapp_"):
					compd[cur][sobi].append([&"exitapp", [], commed])
				elif nama.begins_with("setvar_"):
					compd[cur][sobi].append([&"setvar", [bl.get_node("Pole/Scroll/LForms").text, await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("addvar_"):
					compd[cur][sobi].append([&"addvar", [bl.get_node("Pole/Scroll/LForms").text, await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("addlist_"):
					compd[cur][sobi].append([&"addlist", [bl.get_node("Pole/Scroll/LForms").text, await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("remlist_"):
					compd[cur][sobi].append([&"remlist", [bl.get_node("Pole/Scroll/LForms").text, await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("adddict_"):
					compd[cur][sobi].append([&"adddict", [bl.get_node("Pole/Scroll/LForms").text, await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole3/Scroll/LForms"))], commed])
				elif nama.begins_with("remdict_"):
					compd[cur][sobi].append([&"remdict", [bl.get_node("Pole/Scroll/LForms").text, await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("split_"):
					compd[cur][sobi].append([&"split", [bl.get_node("Pole/Scroll/LForms").text, await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("clrlist_"):
					compd[cur][sobi].append([&"clrlist", [bl.get_node("Pole/Scroll/LForms").text], commed])
				elif nama.begins_with("clrdict_"):
					compd[cur][sobi].append([&"clrdict", [bl.get_node("Pole/Scroll/LForms").text], commed])
				elif nama.begins_with("strtolist_"):
					compd[cur][sobi].append([&"strtolist", [bl.get_node("Pole/Scroll/LForms").text, await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("luacode_"):
					compd[cur][sobi].append([&"luacode", [bl.get_node("Pole/Scroll/LForms").text, await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole3/Scroll/LForms"))], commed])
				elif nama.begins_with("setlocalvar_"):
					compd[cur][sobi].append([&"setlocalvar", [bl.get_node("Pole/Scroll/LForms").text, await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("addlocalvar_"):
					compd[cur][sobi].append([&"addlocalvar", [bl.get_node("Pole/Scroll/LForms").text, await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("drawpoint_"):
					compd[cur][sobi].append([&"drawpoint", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				elif nama.begins_with("hide_"):
					compd[cur][sobi].append([&"hide", [], commed])
				elif nama.begins_with("show_"):
					compd[cur][sobi].append([&"show", [], commed])
				elif nama.begins_with("clone_"):
					compd[cur][sobi].append([&"clone", [], commed])
				elif nama.begins_with("vertori_"):
					compd[cur][sobi].append([&"vertori", [], commed])
				elif nama.begins_with("goriori_"):
					compd[cur][sobi].append([&"goriori", [], commed])
				elif nama.begins_with("deletepoints_"):
					compd[cur][sobi].append([&"deletepoints", [], commed])
				elif nama.begins_with("enacyc_"):
					compd[cur][sobi].append([&"enacyc", [], commed])
				elif nama.begins_with("discyc_"):
					compd[cur][sobi].append([&"discyc", [], commed])
				elif nama.begins_with("setsprite_"):
					compd[cur][sobi].append([&"setsprite", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("linewidth_"):
					compd[cur][sobi].append([&"linewidth", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("setlayer_"):
					compd[cur][sobi].append([&"setlayer", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("comment_"):
					compd[cur][sobi].append([&"comment", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("image_"):
					compd[cur][sobi].append([&"image", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("hitmod_"):
					compd[cur][sobi].append([&"hitmod", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("lncscene_"):
					compd[cur][sobi].append([&"lncscene", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("stpscene_"):
					compd[cur][sobi].append([&"lncscene", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("setbri_"):
					compd[cur][sobi].append([&"setbri", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("addbri_"):
					compd[cur][sobi].append([&"addbri", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("setproz_"):
					compd[cur][sobi].append([&"setproz", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("addproz_"):
					compd[cur][sobi].append([&"addproz", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("stasignal_"):
					compd[cur][sobi].append([&"stasignal", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("tonpart_"):
					compd[cur][sobi].append([&"tonpart", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("toffpart_"):
					compd[cur][sobi].append([&"toffpart", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("crepart_"):
					compd[cur][sobi].append([&"crepart", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole3/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole4/Scroll/LForms"))], commed])
				elif nama.begins_with("partbase_"):
					compd[cur][sobi].append([&"partbase", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole3/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole4/Scroll/LForms"))], commed])
				elif nama.begins_with("partgrav_"):
					compd[cur][sobi].append([&"partgrav", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole3/Scroll/LForms"))], commed])
				elif nama.begins_with("partvel_"):
					compd[cur][sobi].append([&"partvel", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole3/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole4/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole5/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole6/Scroll/LForms"))], commed])
				elif nama.begins_with("partpos_"):
					compd[cur][sobi].append([&"partpos", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole3/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole4/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole5/Scroll/LForms"))], commed])
				elif nama.begins_with("stopthis_"):
					compd[cur][sobi].append([&"stopthis", [], commed])
				elif nama.begins_with("enaascii_"):
					compd[cur][sobi].append([&"enaascii", [], commed])
				elif nama.begins_with("disascii_"):
					compd[cur][sobi].append([&"disascii", [], commed])
				elif nama.begins_with("enadither_"):
					compd[cur][sobi].append([&"enadither", [], commed])
				elif nama.begins_with("disdither_"):
					compd[cur][sobi].append([&"disdither", [], commed])
				elif nama.begins_with("enavin_"):
					compd[cur][sobi].append([&"enavin", [], commed])
				elif nama.begins_with("disvin_"):
					compd[cur][sobi].append([&"disvin", [], commed])
				elif nama.begins_with("enacrt_"):
					compd[cur][sobi].append([&"enacrt", [], commed])
				elif nama.begins_with("discrt_"):
					compd[cur][sobi].append([&"discrt", [], commed])
				elif nama.begins_with("enagli_"):
					compd[cur][sobi].append([&"enagli", [], commed])
				elif nama.begins_with("disgli_"):
					compd[cur][sobi].append([&"disgli", [], commed])
				elif nama.begins_with("enapix_"):
					compd[cur][sobi].append([&"enapix", [], commed])
				elif nama.begins_with("dispix_"):
					compd[cur][sobi].append([&"dispix", [], commed])
				elif nama.begins_with("enablur_"):
					compd[cur][sobi].append([&"enablur", [], commed])
				elif nama.begins_with("disblur_"):
					compd[cur][sobi].append([&"disblur", [], commed])
				elif nama.begins_with("enashake_"):
					compd[cur][sobi].append([&"enashake", [], commed])
				elif nama.begins_with("disshake_"):
					compd[cur][sobi].append([&"disshake", [], commed])
				elif nama.begins_with("ligon_"):
					compd[cur][sobi].append([&"ligon", [], commed])
				elif nama.begins_with("ligoff_"):
					compd[cur][sobi].append([&"ligoff", [], commed])
				elif nama.begins_with("blockli_"):
					compd[cur][sobi].append([&"blockli", [], commed])
				elif nama.begins_with("nblockli_"):
					compd[cur][sobi].append([&"nblockli", [], commed])
				elif nama.begins_with("asciisize_"):
					compd[cur][sobi].append([&"asciisize", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("vinsize_"):
					compd[cur][sobi].append([&"vinsize", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("pixsize_"):
					compd[cur][sobi].append([&"pixsize", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("blursize_"):
					compd[cur][sobi].append([&"blursize", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("shakesize_"):
					compd[cur][sobi].append([&"shakesize", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("fxcont_"):
					compd[cur][sobi].append([&"fxcont", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("fxsat_"):
					compd[cur][sobi].append([&"fxsat", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("fxbri_"):
					compd[cur][sobi].append([&"fxbri", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms"))], commed])
				elif nama.begins_with("fxglow_"):
					compd[cur][sobi].append([&"fxglow", [await nodes_to_formula(bl.get_node("Pole/Scroll/LForms")), await nodes_to_formula(bl.get_node("Pole2/Scroll/LForms"))], commed])
				
		compa[str(rrs.name)] = compd
	return compa

func _obr(id : StringName, polya : Array, targ : String, commed : bool, cod):
	if commed:
		return
	if not $Project.get_node(cod).visible:
		return
	if not mode:
		return
	var obj : Node2D
	if $Project.get_node(cod).has_node(targ):
		obj = $Project.get_node(cod).get_node(targ)
	else:
		return
	if not ifs.has(targ):
		ifs[targ] = []

	if id == &"if":
		if ifs[targ].size() > 0 and ifs[targ].back() == false:
			ifs[targ].append(false)
		else:
			var res = str(await vling(polya[0], obj))
			ifs[targ].append(res == "true")
		return

	elif id == &"else":
		if ifs[targ].size() > 0:
			var paok : bool = true
			if ifs[targ].size() > 1:
				paok = ifs[targ][ifs[targ].size() - 2]
			
			if paok:
				ifs[targ][ifs[targ].size() - 1] = not ifs[targ][ifs[targ].size() - 1]
		return

	elif id == &"ifend":
		if ifs[targ].size() > 0:
			ifs[targ].pop_back()
		return

	if ifs[targ].size() > 0 and ifs[targ].back() == false:
		return
	if id == &"setposx":
		var x = await vling(polya[0], obj)
		obj.position.x = float(x)
	elif id == &"addposx":
		obj.position.x += float(await vling(polya[0], obj))
	elif id == &"setposy":
		var y = await vling(polya[0], obj)
		obj.position.y = -float(y)
	elif id == &"addposy":
		obj.position.y += -float(await vling(polya[0], obj))
	elif id == &"setvar":
		vars[polya[0]] = await vling(polya[1], obj)
	elif id == &"addvar":
		vars[polya[0]] = str(float(vars.get(polya[0], 0)) + float(await vling(polya[1], obj))).trim_suffix(".0")
	elif id == &"addlist":
		if !vars.has(polya[0]):
			vars[polya[0]] = []
		if typeof(vars[polya[0]]) == TYPE_ARRAY:
			vars[polya[0]].append(str(await vling(polya[1], obj)).trim_suffix(".0"))
	elif id == &"clrlist":
		vars[polya[0]] = []
	elif id == &"clrdict":
		vars[polya[0]] = {}
	elif id == &"split":
		if vars.has(polya[0]):
			var pl : String = vars[polya[0]]
			var sp : String = str(await vling(polya[1], obj))
			vars[polya[0]] = Array((pl).split((sp)))
	elif id == &"remlist":
		if vars.has(polya[0]) and typeof(vars[polya[0]]) == TYPE_DICTIONARY:
			if len(vars[polya[0]]) >= int(await vling(polya[1], obj)):
				vars[polya[0]].pop_at(int(await vling(polya[1], obj)) - 1)
	elif id == &"adddict":
		if !vars.has(polya[0]):
			vars[polya[0]] = {}
		if typeof(vars[polya[0]]) == TYPE_DICTIONARY:
			vars[polya[0]][str(await vling(polya[1], obj))] = await vling(polya[2], obj)
	elif id == &"remdict":
		if vars.has(polya[0]) and typeof(vars[polya[0]]) == TYPE_DICTIONARY:
			if len(vars[polya[0]]) >= int(await vling(polya[1], obj)):
				vars[polya[0]].erase(str(await vling(polya[1], obj)))
	elif id == &"setlocalvar":
		var vrs = obj.get_meta("vars")
		vrs[polya[0]] = await vling(polya[1], obj)
		obj.set_meta("vars", vrs)
	elif id == &"addlocalvar":
		var vrs = obj.get_meta("vars")
		vrs[polya[0]] = str(float(vrs.get(polya[0], 0)) + float(await vling(polya[1], obj))).trim_suffix(".0")
		obj.set_meta("vars" , vrs ) 
	elif id == &"wait":
		await get_tree().create_timer(float(await vling(polya[0], obj))).timeout
	elif id == &"presskey":
		for x in customs["ks"]:
			if x[3].to_upper() == str(await vling(polya[0], obj)).to_upper():
				_ponyal(x[0], x[1], x[2])
	elif id == &"setrot":
		var x = await vling(polya[0], obj)
		obj.rotation_degrees = float(x)
	elif id == &"addrot":
		obj.rotation_degrees += float(await vling(polya[0], obj))
	elif id == &"setsizex":
		var x = await vling(polya[0], obj)
		obj.scale.x = float(x)
	elif id == &"addsizex":
		obj.scale.x += float(await vling(polya[0], obj))
	elif id == &"setsizey":
		var y = await vling(polya[0], obj)
		obj.scale.y = float(y)
	elif id == &"addsizey":
		obj.scale.y += float(await vling(polya[0], obj))
	elif id == &"setproz":
		obj.modulate.a = float(await vling(polya[0], obj))
	elif id == &"addproz":
		obj.modulate.a += float(await vling(polya[0], obj))
	elif id == &"setcolor":
		obj.modulate = Color(float(polya[0]), float(polya[1]), float(polya[2]), float(polya[3])) / 255
	elif id == &"setambient":
		obj.get_parent().get_node("Ambient").color = Color(float(polya[0]), float(polya[1]), float(polya[2]), float(polya[3])) / 255
	elif id == &"lightcolor":
		obj.light.color = Color(float(polya[0]), float(polya[1]), float(polya[2]), float(polya[3])) / 255
	elif id == &"lightsize":
		obj.light.texture_scale = float(await vling(polya[0], obj))
	elif id == &"lighten":
		obj.light.energy = float(await vling(polya[0], obj))
	elif id == &"stasignal":
		await get_tree().create_timer(0.01).timeout
		if customs["sig"].has(await vling(polya[0], obj)):
			for ogi in customs["sig"][await vling(polya[0], obj)]:
				_ponyal(ogi[0], ogi[1], ogi[2])
	elif id == &"luacode":
		var vlind = await vling(polya[2], obj)
		var res = lua.do_string("local fr_d = " + vlind + "\n" + polya[0])
		vars[polya[1]] = str(res)
	elif id == &"clone":
		var clon : CharacterBody2D = obj.duplicate()
		clon.name = str(obj.name).split("__")[0] + "__Clone" + str(Time.get_unix_time_from_system()) + str(randi_range(1, 9999999))
		obj.get_parent().add_child(clon)
		await reg_obj(str(clon.name), str(obj.name).split("__")[0], cod)
	elif id == &"declo":
		if "__Clone" in obj.name:
			obj.queue_free()
	elif id == &"deaclo":
		for x in $Project.get_node(cod).get_children():
			if "__Clone" in x.name and obj.name in x.name:
				x.queue_free()
	elif id == &"linewidth":
		var line : Line2D = $Project/Pen/Line2D
		line.width = float(await vling(polya[0], obj))
	elif id == &"drawpoint":
		var line : Line2D = $Project/Pen/Line2D
		line.add_point(Vector2(float(await vling(polya[0], obj)), -float(await vling(polya[1], obj))))
	elif id == &"deletepoint":
		var line : Line2D = $Project/Pen/Line2D
		line.remove_point(int(await vling(polya[0], obj)) - 1)
	elif id == &"deletepoints":
		var line : Line2D = $Project/Pen/Line2D
		line.clear_points()
	elif id == &"enacyc":
		var line : Line2D = $Project/Pen/Line2D
		line.closed = true
	elif id == &"discyc":
		var line : Line2D = $Project/Pen/Line2D
		line.closed = false
	elif id == &"linecolor":
		var line : Line2D = $Project/Pen/Line2D
		line.gradient = null
		line.default_color = Color(float(polya[0]), float(polya[1]), float(polya[2]), float(polya[3])) / 255
	elif id == &"linegradient":
		var line : Line2D = $Project/Pen/Line2D
		var grad : Gradient = Gradient.new()
		grad.set_color(0, Color(float(polya[0]), float(polya[1]), float(polya[2]), float(polya[3])) / 255)
		grad.set_color(1, Color(float(polya[4]), float(polya[5]), float(polya[6]), float(polya[7])) / 255)
		line.gradient = grad
	elif id == &"setausp":
		if $Files/Files/Hernya/Snds.has_node(await vling(polya[0], obj)):
			$Files/Files/Hernya/Snds.get_node(await vling(polya[0], obj) + "/Audio").pitch_scale = float(await vling(polya[1], obj))
	elif id == &"addausp":
		if $Files/Files/Hernya/Snds.has_node(await vling(polya[0], obj)):
			$Files/Files/Hernya/Snds.get_node(await vling(polya[0], obj) + "/Audio").pitch_scale += float(await vling(polya[1], obj))
	elif id == &"playsound":
		if $Files/Files/Hernya/Snds.has_node(await vling(polya[0], obj)):
			$Files/Files/Hernya/Snds.get_node(await vling(polya[0], obj) + "/Audio").play()
	elif id == &"stopsound":
		if $Files/Files/Hernya/Snds.has_node(await vling(polya[0], obj)):
			$Files/Files/Hernya/Snds.get_node(await vling(polya[0], obj) + "/Audio").stop()
	elif id == &"bgcolor":
		$Project/Bg.modulate = Color(float(await vling(polya[0], obj)), float(await vling(polya[1], obj)), float(await vling(polya[2], obj)), float(await vling(polya[3], obj))) / 255
	elif id == &"vincolor":
		conf.VignetteR_G_B = Color(float(await vling(polya[0], obj)), float(await vling(polya[1], obj)), float(await vling(polya[2], obj)), float(await vling(polya[3], obj))) / 255
	elif id == &"setrgb":
		obj.modulate = Color(float(await vling(polya[0], obj)), float(await vling(polya[1], obj)), float(await vling(polya[2], obj)))
	elif id == &"setbri":
		obj.modulate.v = float(await vling(polya[0], obj))
	elif id == &"addbri":
		obj.modulate.v += float(await vling(polya[0], obj))
	elif id == &"fxbri":
		ncon.adjustment_brightness = float(await vling(polya[0], obj))
	elif id == &"fxsat":
		ncon.adjustment_saturation = float(await vling(polya[0], obj))
	elif id == &"fxcont":
		ncon.adjustment_contrast = float(await vling(polya[0], obj))
	elif id == &"shakesize":
		conf.ScreenShakePower = float(await vling(polya[0], obj))
	elif id == &"fxglow":
		ncon.glow_intensity = float(await vling(polya[0], obj))
		ncon.glow_bloom = float(await vling(polya[1], obj))
	elif id == &"enaascii":
		conf.ASCII = true
	elif id == &"disascii":
		conf.ASCII = false
	elif id == &"enavin":
		conf.Vignette = true
	elif id == &"disvin":
		conf.Vignette = false
	elif id == &"enacrt":
		conf.CRT = true
	elif id == &"discrt":
		conf.CRT = false
	elif id == &"ligon":
		obj.light.enabled = true
	elif id == &"ligoff":
		obj.light.enabled = false
	elif id == &"blockli":
		obj.locl.show()
	elif id == &"nblockli":
		obj.locl.hide()
	elif id == &"enagli":
		conf.Glitch = true
	elif id == &"disgli":
		conf.Glitch = false
	elif id == &"enapix":
		conf.Pixelate = true
	elif id == &"dispix":
		conf.Pixelate = false
	elif id == &"enablur":
		conf.Blur = true
	elif id == &"disblur":
		conf.Blur = false
	elif id == &"enashake":
		conf.ScreenShake = true
	elif id == &"disshake":
		conf.ScreenShake = false
	elif id == &"blursize":
		conf.L_O_D = float(await vling(polya[0], obj))
	elif id == &"pixsize":
		conf.PixelatePixelSize = float(await vling(polya[0], obj))
	elif id == &"vinsize":
		conf.VignetteIntensity = float(await vling(polya[0], obj))
	elif id == &"asciisize":
		conf.ASCIISize = Vector2(float(await vling(polya[0], obj)) * 4.0, float(await vling(polya[0], obj)) * 9.0)
	elif id == &"alert":
		ist = false
		OS.alert(str(await vling(polya[1], obj)), str(await vling(polya[0], obj)))
	elif id == &"vertori":
		DisplayServer.screen_set_orientation(DisplayServer.SCREEN_PORTRAIT)
	elif id == &"goriori":
		DisplayServer.screen_set_orientation(DisplayServer.SCREEN_LANDSCAPE)
	elif id == &"copyclip":
		DisplayServer.clipboard_set(await vling(polya[0], obj))
	elif id == &"waitfor":
		while await vling(polya[0], obj) != "true":
			await get_tree().create_timer(0.033).timeout
	elif id == &"waitframe":
		await get_tree().process_frame
	elif id == &"flipx":
		obj.get_node("Sprite").flip_h = not obj.get_node("Sprite").flip_h
	elif id == &"stopapp":
		_stop()
	elif id == &"exitapp":
		get_tree().quit()
	elif id == &"setsproff":
		var x = await vling(polya[0], obj)
		var y = await vling(polya[1], obj)
		obj.get_node("Sprite").position = Vector2(float(obj.get_node("Sprite").position.x if x == "" else x), float(obj.get_node("Sprite").position.y if y == "" else -y))
	elif id == &"setcampos":
		var x = await vling(polya[0], obj)
		var y = await vling(polya[1], obj)
		obj.get_parent().pos = Vector2(float(obj.get_parent().position.x if x == "" else -x), float(obj.get_parent().position.y if y == "" else y))
	elif id == &"addcampos":
		var x = await vling(polya[0], obj)
		var y = await vling(polya[1], obj)
		obj.get_parent().pos += Vector2(-float(x), float(y))
	elif id == &"setcamzoom":
		var x = await vling(polya[0], obj)
		var y = await vling(polya[1], obj)
		obj.get_parent().zoom = Vector2(float(obj.get_parent().position.x if x == "" else x), float(obj.get_parent().position.y if y == "" else y))
	elif id == &"addcamzoom":
		var x = await vling(polya[0], obj)
		var y = await vling(polya[1], obj)
		obj.get_parent().zoom += Vector2(float(x), float(y))
	elif id == &"flipy":
		obj.get_node("Sprite").flip_v = not obj.get_node("Sprite").flip_v
	elif id == &"timescale":
		Engine.time_scale = clamp(float(await vling(polya[0], obj)), 0.01, 100)
	elif id == &"setskew":
		var x = await vling(polya[0], obj)
		obj.skew = deg_to_rad(float(x))
	elif id == &"addskew":
		obj.skew += deg_to_rad(float(await vling(polya[0], obj)))
	elif id == &"setcamskew":
		var x = await vling(polya[0], obj)
		obj.get_parent().skew = -deg_to_rad(float(x))
	elif id == &"addcamskew":
		obj.get_parent().skew -= deg_to_rad(float(await vling(polya[0], obj)))
	elif id == &"opensite":
		var url = await vling(polya[0], obj)
		if not url.begins_with("http"):
			url = "https://" + url
		OS.shell_open(url)
	elif id == &"newtext":
		var text : Label = Label.new()
		text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		text.set_script(load("res://Scripts/ue.gd"))
		text.anchor_bottom = 0.5
		text.anchor_top = 0.5
		text.anchor_left = 0.5
		text.anchor_right = 0.5
		var labsets : LabelSettings = LabelSettings.new()
		labsets.font = load("res://Fonts/Nunito-Black.ttf")
		labsets.font_color = Color(0, 0, 0)
		text.label_settings = labsets
		text.name = await vling(polya[0], obj)
		text.text = await vling(polya[1], obj)
		$Project/UIelems.add_child(text)
		text.pos.x = float(await vling(polya[2], obj))
		text.pos.y = -float(await vling(polya[3], obj))
	elif id == &"newbutton":
		var text : Button = Button.new()
		text.set_script(load("res://Scripts/ue.gd"))
		text.anchor_bottom = 0.5
		text.anchor_top = 0.5
		text.anchor_left = 0.5
		text.anchor_right = 0.5
		text.add_theme_font_override("font", load("res://Fonts/Nunito-Black.ttf"))
		text.add_theme_color_override("font_color", Color(0, 0, 0))
		text.name = await vling(polya[0], obj)
		text.text = await vling(polya[2], obj)
		$Project/UIelems.add_child(text)
		text.pos.x = float(await vling(polya[3], obj))
		text.pos.y = -float(await vling(polya[4], obj))
		await get_tree().create_timer(0.01).timeout
		if customs["sig"].has(await vling(polya[1], obj)):
			for ogi in customs["sig"][await vling(polya[1], obj)]:
				text.button_down.connect(_ponyal.bind(ogi[0], ogi[1], ogi[2]))
	elif id == &"newledit":
		var text : LineEdit = LineEdit.new()
		text.set_script(load("res://Scripts/ue.gd"))
		text.anchor_bottom = 0.5
		text.anchor_top = 0.5
		text.anchor_left = 0.5
		text.anchor_right = 0.5
		text.add_theme_font_override("font", load("res://Fonts/Nunito-Black.ttf"))
		text.add_theme_color_override("font_color", Color(0, 0, 0))
		text.name = await vling(polya[0], obj)
		text.text = await vling(polya[2], obj)
		text.placeholder_text = await vling(polya[1], obj)
		$Project/UIelems.add_child(text)
		text.pos.x = float(await vling(polya[3], obj))
		text.pos.y = float(await vling(polya[4], obj))
	elif id == &"crepart":
		var tex = null
		if $Files/Files/Hernya/Fles.has_node((await vling(polya[1], obj)).trim_suffix("_png")):
			tex = $Files/Files/Hernya/Fles.get_node((await vling(polya[1], obj)).trim_suffix("_png")).get_node("Panel/Icon").texture
		var parts : GPUParticles2D = GPUParticles2D.new()
		var mat : ParticleProcessMaterial = ParticleProcessMaterial.new()
		mat.gravity.y = 0
		parts.position.x = float(await vling(polya[2], obj))
		parts.position.y = float(await vling(polya[3], obj))
		parts.process_material = mat
		parts.texture = tex
		parts.name = await vling(polya[0], obj)
		$Project/Partics.add_child(parts)
		parts.emitting = true
		mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
		mat.emission_box_extents = Vector3(0, 0, 0)
	elif id == &"partpos":
		if $Project/Partics.has_node(await vling(polya[0], obj)):
			var parts : GPUParticles2D = $Project/Partics.get_node(await vling(polya[0], obj))
			var mat : ParticleProcessMaterial = parts.process_material
			parts.position.x = float(await vling(polya[1], obj))
			mat.emission_box_extents.x = float(await vling(polya[2], obj))
			parts.position.y = float(await vling(polya[3], obj))
			mat.emission_box_extents.y = float(await vling(polya[4], obj))
	elif id == &"partbase":
		if $Project/Partics.has_node(await vling(polya[0], obj)):
			var tex = null
			if $Files/Files/Hernya/Fles.has_node((await vling(polya[1], obj)).trim_suffix("_png")):
				tex = $Files/Files/Hernya/Fles.get_node((await vling(polya[1], obj)).trim_suffix("_png")).get_node("Panel/Icon").texture
			var parts : GPUParticles2D = $Project/Partics.get_node(await vling(polya[0], obj))
			parts.amount = int(await vling(polya[3], obj))
			parts.lifetime = float(await vling(polya[2], obj))
			parts.texture = tex
	elif id == &"tonpart":
		if $Project/Partics.has_node(await vling(polya[0], obj)):
			var parts : GPUParticles2D = $Project/Partics.get_node(await vling(polya[0], obj))
			parts.emitting = true
	elif id == &"toffpart":
		if $Project/Partics.has_node(await vling(polya[0], obj)):
			var parts : GPUParticles2D = $Project/Partics.get_node(await vling(polya[0], obj))
			parts.emitting = false
	elif id == &"partvel":
		if $Project/Partics.has_node(await vling(polya[0], obj)):
			var parts : GPUParticles2D = $Project/Partics.get_node(await vling(polya[0], obj))
			var mat : ParticleProcessMaterial = parts.process_material
			mat.initial_velocity_min = int(await vling(polya[1], obj))
			mat.initial_velocity_max = int(await vling(polya[2], obj))
			mat.direction.x = float(await vling(polya[3], obj))
			mat.direction.y = float(await vling(polya[4], obj))
			mat.spread = int(await vling(polya[5], obj))
	elif id == &"partgrav":
		if $Project/Partics.has_node(await vling(polya[0], obj)):
			var parts : GPUParticles2D = $Project/Partics.get_node(await vling(polya[0], obj))
			var mat : ParticleProcessMaterial = parts.process_material
			mat.gravity.x = float(await vling(polya[1], obj))
			mat.gravity.y = float(await vling(polya[2], obj))
	elif id == &"getletext":
		if $Project/UIelems.has_node(await vling(polya[0], obj)):
			if $Project/UIelems.get_node(await vling(polya[0], obj)) is LineEdit:
				vars[await vling(polya[1], obj)] = $Project/UIelems.get_node(await vling(polya[0], obj)).text
	elif id == &"redtext":
		if $Project/UIelems.has_node(await vling(polya[0], obj)):
			var text : Control = $Project/UIelems.get_node(await vling(polya[0], obj))
			text.text = await vling(polya[1], obj)
			var x = await vling(polya[2], obj)
			var y = await vling(polya[3], obj)
			text.pos = Vector2(float(text.position.x if len(x) < 1 else x), -float(text.position.y if len(x) < 1 else y))
	elif id == &"delui":
		if $Project/UIelems.has_node(await vling(polya[0], obj)):
			$Project/UIelems.get_node(await vling(polya[0], obj)).queue_free()
	elif id == &"reparentui":
		if $Project/UIelems.has_node(await vling(polya[0], obj)) and $Project/UIelems.has_node(await vling(polya[1], obj)):
			$Project/UIelems.get_node(await vling(polya[0], obj)).reparent($Project/UIelems.get_node(await vling(polya[1], obj)))
	elif id == &"redbutton":
		if $Project/UIelems.has_node(await vling(polya[0], obj)):
			var text : Control = $Project/UIelems.get_node(await vling(polya[0], obj))
			text.add_theme_font_override("font", load("res://Fonts/Nunito-Black.ttf"))
			text.add_theme_color_override("font_color", Color(0, 0, 0))
			text.name = await vling(polya[0], obj)
			text.text = await vling(polya[2], obj)
			$Project/UIelems.add_child(text)
			var x = await vling(polya[2], obj)
			var y = await vling(polya[3], obj)
			text.pos = Vector2(float(text.position.x if len(x) < 1 else x), float(text.position.y if len(x) < 1 else y))
	elif id == &"styletext":
		if $Project/UIelems.has_node(await vling(polya[0], obj)):
			var sets : LabelSettings = $Project/UIelems.get_node(await vling(polya[0], obj)).label_settings
			sets.font_size = int(await vling(polya[1], obj))
			sets.outline_size = int(await vling(polya[2], obj))
			sets.font_color = Color(float(polya[3]), float(polya[4]), float(polya[5]), float(polya[6])) / 255
			sets.outline_color = Color(float(polya[7]), float(polya[8]), float(polya[9]), float(polya[10])) / 255
	elif id == &"stylebutton":
		if $Project/UIelems.has_node(await vling(polya[0], obj)):
			var flat : StyleBoxFlat = StyleBoxFlat.new()
			flat.bg_color = Color(float(polya[11]), float(polya[12]), float(polya[13]), float(polya[14])) / 255
			flat.border_color = Color(float(polya[15]), float(polya[16]), float(polya[17]), float(polya[18])) / 255
			flat.shadow_color = Color(float(polya[19]), float(polya[20]), float(polya[21]), float(polya[22])) / 255
			flat.shadow_size = int(await vling(polya[31], obj))
			flat.shadow_offset = Vector2(float(await vling(polya[32], obj)), float(await vling(polya[33], obj)))
			flat.skew = Vector2(float(await vling(polya[34], obj)), float(await vling(polya[35], obj)))
			flat.border_width_left = int(await vling(polya[23], obj))
			flat.border_width_right = int(await vling(polya[24], obj))
			flat.border_width_top = int(await vling(polya[25], obj))
			flat.border_width_bottom = int(await vling(polya[26], obj))
			flat.corner_radius_top_left = int(await vling(polya[27], obj))
			flat.corner_radius_top_right = int(await vling(polya[28], obj))
			flat.corner_radius_bottom_left = int(await vling(polya[29], obj))
			flat.corner_radius_bottom_right = int(await vling(polya[30], obj))
			$Project/UIelems.get_node(await vling(polya[0], obj)).add_theme_stylebox_override("normal", flat)
			$Project/UIelems.get_node(await vling(polya[0], obj)).add_theme_stylebox_override("hover", flat)
			$Project/UIelems.get_node(await vling(polya[0], obj)).add_theme_stylebox_override("pressed", flat)
			$Project/UIelems.get_node(await vling(polya[0], obj)).add_theme_stylebox_override("focus", flat)
			var text : Control = $Project/UIelems.get_node(await vling(polya[0], obj))
			text.add_theme_constant_override("outline_size", int(await vling(polya[2], obj)))
			text.add_theme_font_size_override("font_size", int(await vling(polya[1], obj)))
			text.add_theme_color_override("font_color", Color(float(polya[3]), float(polya[4]), float(polya[5]), float(polya[6])) / 255)
			text.add_theme_color_override("font_pressed_color", Color(float(polya[3]), float(polya[4]), float(polya[5]), float(polya[6])) / 255)
			text.add_theme_color_override("font_hover_color", Color(float(polya[3]), float(polya[4]), float(polya[5]), float(polya[6])) / 255)
			text.add_theme_color_override("font_outline_color", Color(float(polya[7]), float(polya[8]), float(polya[9]), float(polya[10])) / 255)
	elif id == &"movesteps":
		obj.position += obj.transform.x * float(await vling(polya[0], obj))
	elif id == &"hide":
		obj.get_node("Sprite").hide()
	elif id == &"show":
		obj.get_node("Sprite").show()
	elif id == &"onphy":
		obj.freeze = false
	elif id == &"offphy":
		obj.freeze = true
	elif id == &"onhit":
		obj.get_node("Hit").disabled = false
	elif id == &"offhit":
		obj.get_node("Hit").disabled = true
	elif id == &"setgravity":
		var x = await vling(polya[0], obj)
		var y = await vling(polya[1], obj)
		obj.gravity = Vector2(float(obj.position.x if x == "" else x), float(obj.position.y if y == "" else y))
	elif id == &"applyforce":
		var x = await vling(polya[0], obj)
		var y = await vling(polya[1], obj)
		obj.velocity = Vector2(float(obj.position.x if x == "" else x), float(obj.position.y if y == "" else y))
	elif id == &"toast":
		var android_runtime = Engine.get_singleton("AndroidRuntime")
		if android_runtime:
			var activity = android_runtime.getActivity()
			var toast_callable = func():
				var ToastClass = JavaClassWrapper.wrap("android.widget.Toast")
				ToastClass.makeText(activity, str(await vling(polya[0], obj)), ToastClass.LENGTH_LONG).show()
			activity.runOnUiThread(android_runtime.createRunnableFromGodotCallable(toast_callable))
	elif id == &"hitmod":
		obj.hitmod = float(await vling(polya[0], obj))
	elif id == &"lncscene":
		if $Project.has_node(await vling(polya[0], obj)):
			$Project.get_node(await vling(polya[0], obj)).show()
			_vipolnn(await vling(polya[0], obj))
	elif id == &"stpscene":
		if $Project.has_node(await vling(polya[0], obj)):
			$Project.get_node(await vling(polya[0], obj)).hide()
	elif id == &"stopthis":
		obj.get_parent().hide()
	elif id == &"setlayer":
		obj.z_index = float(await vling(polya[0], obj))
	elif id == &"setsprite":
		if $Files/Files/Hernya/Fles.has_node((await vling(polya[0], obj)).trim_suffix("_png")):
			obj.get_node("Sprite").texture = $Files/Files/Hernya/Fles.get_node((await vling(polya[0], obj)).trim_suffix("_png")).get_node("Panel/Icon").texture
	elif id == &"savefile":
		var pf = await vling(polya[0], obj)
		var inn = await vling(polya[1], obj)
		var ps = polya[2].replace(" Снаружи", "user://Files/").replace(" Внутри", "user://Projects/" + projname + "/Files/")
		if not DirAccess.dir_exists_absolute(ps):
			DirAccess.make_dir_recursive_absolute(ps)
		var fp = ps + pf
		var fl = FileAccess.open(fp, FileAccess.WRITE)
		fl.store_string(inn)
		fl.close()
	elif id == &"loadfile":
		var pf = await vling(polya[0], obj)
		var ps = polya[2].replace(" Снаружи", "user://Files/").replace(" Внутри", "user://Projects/" + projname + "/Files/") + str(pf)
		if not DirAccess.dir_exists_absolute(ps):
			DirAccess.make_dir_recursive_absolute(ps)
			vars[polya[1]] = FileAccess.get_file_as_string(ps)
func _vipolnn(cod):
	await save_proj()
	for x in $Project.get_children():
		if x is Node2D:
			x.hide()
	for x in $Project.get_node(cod).get_children():
		if x is CharacterBody2D:
			x.set_meta("vars", {})
			x.locl.hide()
	$Project/UIelems.show()
	$Project/Partics.show()
	$Project/Pen.show()
	$Project.get_node(cod).show()
	$Project.get_node(cod + "/Ambient").color = Color(1, 1, 1, 1)
	for kit in code[cod]:
		for xo in $Project.get_node(cod).get_children():
			if xo.name == kit:
				xo.get_node("Sprite").texture = null
				for sig in xo.get_node("Touch").get_signal_list():
					var cons : Array = xo.get_node("Touch").get_signal_connection_list(sig.name)
					for con in cons:
						xo.get_node("Touch").disconnect(sig.name, con.callable)
				xo.velocity = Vector2(0, 0)
				xo.gravity = Vector2(0, 0)
				xo.position = Vector2(0, 0)
				xo.light.position = Vector2(0, 0)
				xo.get_node("Sprite").flip_h = false
				xo.get_node("Sprite").flip_v = false
				xo.light.enabled = false
				xo.light.texture_scale = 1
				xo.light.energy = 1
				xo.locl.hide()
				xo.skew = 0
				xo.rotation = 0
				xo.scale = Vector2(1, 1)
				xo.modulate = Color(1, 1, 1, 1)
				xo.self_modulate = Color(1, 1, 1, 1)
				if $FE.data.has(str(xo.get_parent().name)):
					if $FE.data[str(xo.get_parent().name)].has(str(xo.name)):
						var dat = $FE.data[str(xo.get_parent().name)][str(xo.name)]
						xo.position = Vector2(dat["Posx"], -dat["Posy"])
						xo.scale = Vector2(dat["Sizx"], dat["Sizy"])
						xo.modulate = dat["Modl"]
						if $Files/Files/Hernya/Fles.has_node(dat["Sprite"]):
							xo.get_node("Sprite").texture = $Files/Files/Hernya/Fles.get_node(dat["Sprite"]).get_node("Panel/Icon").texture
		for ogo in code[cod][kit]:
			if ogo.begins_with("start"):
				_ponyal(kit, ogo, cod)
			if ogo.begins_with("presd"):
				$Project.get_node(cod).get_node(kit).get_node("Touch").pressed.connect(_ponyal.bind(kit, ogo, cod))
			if ogo.begins_with("evrframe"):
				customs["efr"].append([kit, ogo, cod])
			if ogo.begins_with("keyp"):
				customs["ks"].append([kit, ogo, cod, ogo.split(":")[1]])
			if ogo.begins_with("signal"):
				if not customs["sig"].has(ogo.split(":")[1]):
					customs["sig"][ogo.split(":")[1]] = []
				customs["sig"][ogo.split(":")[1]].append([kit, ogo, cod])
			if ogo.begins_with("rlsed"):
				$Project.get_node(cod).get_node(kit).get_node("Touch").released.connect(_ponyal.bind(kit, ogo, cod)) 
			#if ogo.begins_with("menter"):
			#	$Project.get_node(cod).get_node(kit).get_node("Touch").mouse_entered.connect(_ponyal.bind(kit, ogo, cod))
			#if ogo.begins_with("mexit"):
			#	$Project.get_node(cod).get_node(kit).get_node("Touch").mouse_exited.connect(_ponyal.bind(kit, ogo, cod))

func reg_obj(kit, meat, cod):
	for ogo in code[cod][meat]:
		if ogo.begins_with("asclone"):
			_ponyal(kit, ogo, cod)
		if ogo.begins_with("presd"):
			$Project.get_node(cod).get_node(kit).get_node("Touch").pressed.connect(act.bind(kit, ogo, cod))
		if ogo.begins_with("evrframe"):
			customs["efr"].append([kit, ogo, cod])
		if ogo.begins_with("signal"):
			if not customs["sig"].has(ogo.split(":")[1]):
				customs["sig"][ogo.split(":")[1]] = []
			customs["sig"][ogo.split(":")[1]].append([kit, ogo, cod])
		if ogo.begins_with("rlsed"):
			$Project.get_node(cod).get_node(kit).get_node("Touch").released.connect(act.bind(kit, ogo, cod)) 
		#if ogo.begins_with("menter"):
		#	$Project.get_node(cod).get_node(kit).get_node("Touch").mouse_entered.connect(act.bind(kit, ogo, cod))
		#if ogo.begins_with("mexit"):
		#	$Project.get_node(cod).get_node(kit).get_node("Touch").mouse_exited.connect(act.bind(kit, ogo, cod))

func act(kit, ogo, cod):
	_ponyal(kit, ogo, cod)

func _ponyal(dim, ogo, cod : String, sol = []):
	var cursc = null
	for x in $Project.get_children():
		if x.visible and x is Node2D and not str(x.name) in ["UIelems", "Partics", "Pen"]:
			cursc = x
	var dima = dim
	if "__" in dim:
		dima = dim.split("__")[0]
	if not code[cod][dima].has(ogo):
		return
	var workat : Array = sol if sol.size() > 0 else code[cod][dima][ogo]
	var i = 0
	while i < len(workat):
		if mode == false:
			break
		if not cursc.visible: break
		
		var comm = workat[i]
		if comm[0] == &"repeat" or comm[0] == &"while":
			var st = i + 1
			var end = i + 1
			var det = 1
			
			while end < len(workat) and det > 0:
				if workat[end][0] == &"repeat" or workat[end][0] == &"while":
					det += 1
				elif workat[end][0] == &"endcycle":
					det -= 1
				if det > 0:
					end += 1
			
			var ins = workat.slice(st, end)
			var params = comm[1]
			
			if comm[0] == &"repeat":
				var n : int = int(await vling(params[0], cursc.get_node(dim)))
				for loop_i in range(n):
					if not cursc.visible: break
					if mode == false: break
					await _ponyal(dim, ogo, cod, ins)
			
			elif comm[0] == &"while":
				while str(await vling(params[0], cursc.get_node(dim))) == "true":
					if not cursc.visible: break
					if mode == false: break
					await _ponyal(dim, ogo, cod, ins)
			
			i = end + 1
		else:
			if not $Project.get_node(cod).visible: break
			if mode == false: break
			await _obr(comm[0], comm[1], dim, comm[2], cod)
			i += 1

func _process(delt: float) -> void:
	delta = snapped(delt * 1000, 0.1)
	for x in customs["efr"]:
		_ponyal(x[0], x[1], x[2])
	if size.x - 50 > 700:
		$Buttons/Scripts/Icon.position.x = 10
		$Buttons/Files/Icon.position.x = 10
		$Buttons/Objects/Icon.position.x = 10
		$Buttons/Scripts/Label.show()
		$Buttons/Files/Label.show()
		$Buttons/Objects/Label.show()
	else:
		$Buttons/Scripts/Icon.position.x = (Disp.x - 40) / 6 - 32.5
		$Buttons/Files/Icon.position.x = (Disp.x - 40) / 6 - 32.5
		$Buttons/Objects/Icon.position.x = (Disp.x - 40) / 6 - 32.5
		$Buttons/Scripts/Label.hide()
		$Buttons/Files/Label.hide()
		$Buttons/Objects/Label.hide()
	for x in [$Buttons/Scripts, $Buttons/Files, $Buttons/Objects]:
		if get_node(str(x.name)).visible:
			x.modulate = Color(1, 1, 1)
		else:
			x.modulate = Color(0.7, 0.7, 0.7)
		x.get_node(str(x.name)).size = x.size
	for x in $Objects/Objs.get_children():
		x.custom_minimum_size.x = Disp.x - 65
	for x in $Files/Files/Hernya/Fles.get_children():
		x.custom_minimum_size.x = Disp.x - 65

func _input(event: InputEvent) -> void:
	if $Loading.visible:
		return
	if event is InputEventScreenTouch:
		if event.pressed:
			var cursc = null
			for x in $Project.get_children():
				if x.visible and x is Node2D and not str(x.name) in ["UIelems", "Partics", "Pen"]:
					cursc = x
			
			var mposx = event.position.x
			var mposy = event.position.y
			if cursc:
				mposx = (event.position.x - DisplayServer.window_get_size().x / 2.0) / cursc.scale.x / Disp.mod
				mposy = -(event.position.y - DisplayServer.window_get_size().y / 2.0) / cursc.scale.y / Disp.mod
			tcha.append([mposx, mposy])
			tind[event.index] = len(tcha) - 1
		else:
			tind.erase(event.index)
		tss = tind.size()

	elif event is InputEventScreenDrag:
		if tind.has(event.index):
			var cursc = null
			for x in $Project.get_children():
				if x.visible and x is Node2D and not str(x.name) in ["UIelems", "Partics", "Pen"]:
					cursc = x
			
			var mposx = event.position.x
			var mposy = event.position.y
			if cursc:
				mposx = (event.position.x - DisplayServer.window_get_size().x / 2.0) / cursc.scale.x / Disp.mod
				mposy = -(event.position.y - DisplayServer.window_get_size().y / 2.0) / cursc.scale.y / Disp.mod
			var target_idx = tind[event.index]
			tcha[target_idx] = [mposx, mposy]
	if event is InputEventKey:
		for x in customs["ks"]:
			if event.as_text_key_label() == x[3].to_upper() and event.pressed:
				_ponyal(x[0], x[1], x[2])
		if event.key_label == KEY_F11 and event.pressed:
			og = 0
			if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		elif event.key_label == KEY_F4 and event.pressed:
			$Debug.visible = not $Debug.visible
		elif event.key_label == KEY_F5 and event.pressed:
			og = 0
			if mode == true:
				_stop()
			else:
				_play()
		elif event.key_label == KEY_F6 and event.pressed:
			og = 0
			expr()
		elif event.key_label == KEY_ESCAPE and event.pressed:
			if not mode:
				if $Katalog.visible or $ModlKat.visible or $FE.visible or $FormulEdit.visible:
					$Click.play()
					$OCM.target = null
					$Katalog.hide()
					$ModlKat.hide()
					$FormulEdit.targ = null
					$FE.hide()
					create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Buttons/Plus, "scale", Vector2(1, 1), 1)
					create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Buttons/Play, "scale", Vector2(1, 1), 1)
					create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Buttons/openFE, "scale", Vector2(1, 1), 1)
					create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Bak/Back, "scale", Vector2(1, 0.001), 1)
				else:
					await save_proj()
					var sc : Control = load("res://editor.tscn").instantiate()
					sc.modulate = Color(0, 0, 0)
					get_parent().add_child(sc)
					queue_free()
			else:
				_stop()

func save_proj():
	var mainscene = null
	for x in $Objects/Objs/Scenesss.get_children():
		if x.get_node("Main").modulate == Color(0.952, 0.85, 1.0, 0.694):
			mainscene = str(x.name)
	var fldr : String = "user://Projects/"
	var fpat : String = fldr + projname
	$Files/Files/Hernya/IconView/Icon/Icon.texture.get_image().save_png(fpat + "/icon.png")
	var data = null
	if FileAccess.file_exists(fpat + "/data.txt"):
		data = str_to_var(FileAccess.get_file_as_string(fpat + "/data.txt"))
	if data:
		data["Name"] = $Files/Files/Hernya/GameName.text
		data["Desc"] = $Files/Files/Hernya/GameDesc.text
		data["Ver"] = $Files/Files/Hernya/GameVer.text
		data["Dotver"] = Dot.dotver
		data["Main"] = mainscene
		data["Modded"] = Modcore.modded
		data["Modname"] = Modcore.mod_name
		data["Compat"] = Modcore.can_vanilla
		var fl : FileAccess = FileAccess.open(fpat + "/data.txt", FileAccess.WRITE)
		fl.store_string(str(data))
		fl.close()
	var script : Dictionary = await _compilyarka(true)
	var fil : FileAccess = FileAccess.open(fpat + "/script.txt", FileAccess.WRITE)
	fil.store_string(str(script))
	fil.close()
	var fa : FileAccess = FileAccess.open(fpat + "/fastedit.txt", FileAccess.WRITE)
	var ogo : String = str($FE.data)
	ogo = ogo.replace('"Modl": (', '"Modl": Color(')
	fa.store_string(ogo)
	fa.close()
	var pat : String = fpat + "/Sprites"
	var dir : DirAccess = DirAccess.open(pat)
	if dir:
		dir.list_dir_begin()
		var file_name : String = dir.get_next()
		
		while file_name != "":
			if file_name == "." or file_name == "..":
				file_name = dir.get_next()
				continue
			
			var full_pat : String = pat + "/" + file_name
			dir.remove(full_pat)
			
			file_name = dir.get_next()
	var dor : DirAccess = DirAccess.open(fpat + "/Sounds")
	if dor:
		dor.list_dir_begin()
		var file_name : String = dor.get_next()
		
		while file_name != "":
			if file_name == "." or file_name == "..":
				file_name = dir.get_next()
				continue
			
			var full_pat : String = fpat + "/Sounds/" + file_name
			dor.remove(full_pat)
			
			file_name = dor.get_next()
	for x in $Files/Files/Hernya/Fles.get_children():
		var img : Image = x.get_node("Panel/Icon").texture.get_image()
		img.save_png(fpat + "/Sprites/" + x.name + ".png")
	for x in $Files/Files/Hernya/Snds.get_children():
		if not DirAccess.dir_exists_absolute(fpat + "/Sounds/"):
			DirAccess.make_dir_recursive_absolute(fpat + "/Sounds/")
		var fl : FileAccess = FileAccess.open(fpat + "/Sounds/" + x.name + ".mp3", FileAccess.WRITE)
		var strm : AudioStream = x.get_node("Audio").stream
		fl.store_buffer(strm.data)
		fl.close()

func load_proj():
	$Loading.show()
	$Loading/Prog.value = 0
	$Loading/Label.text = "Загрузка проекта..."
	await get_tree().create_timer(0.08).timeout
	var fldr = "user://Projects/"
	var fpat = fldr + projname
	var data = null
	if FileAccess.file_exists(fpat + "/fastedit.txt"):
		$FE.data = str_to_var(FileAccess.get_file_as_string(fpat + "/fastedit.txt"))
	if FileAccess.file_exists(fpat + "/data.txt"):
		data = str_to_var(FileAccess.get_file_as_string(fpat + "/data.txt"))
	var img = Image.load_from_file(fpat + "/icon.png")
	if img:
		$Files/Files/Hernya/IconView/Icon/Icon.texture = ImageTexture.create_from_image(img)
	var script = null
	if FileAccess.file_exists(fpat + "/script.txt"):
		script = str_to_var(FileAccess.get_file_as_string(fpat + "/script.txt"))
	$Loading/Prog.value = 10
	$Loading/Label.text = "Загрузка скриптов..."
	await get_tree().create_timer(0.08).timeout
	if script:
		if len(script) == 0:
			var scscr : Control = $PHolders/Scscr.duplicate()
			scscr.name = "Scene"
			$Scripts.add_child(scscr)
			var scene : Control = $PHolders/Tscn.duplicate()
			scene.name = "Scene"
			scene.get_node("Title").text = "Scene"
			scene.get_node("Main").modulate = Color(0.952, 0.85, 1.0, 0.694)
			$Objects/Objs/Scenesss.add_child(scene)
			var scobj : Control = $PHolders/Scene.duplicate()
			scobj.name = "Scene"
			$Objects/Objs.add_child(scobj)
			var prscn : Node2D = $PHolders/PrScn.duplicate()
			prscn.name = "Scene"
			$Project.add_child(prscn)
		for t in script:
			var scscr : Control = $PHolders/Scscr.duplicate()
			scscr.name = t
			$Scripts.add_child(scscr)
			var scene : Control = $PHolders/Tscn.duplicate()
			scene.name = t
			scene.get_node("Title").text = t
			$Objects/Objs/Scenesss.add_child(scene)
			var scobj : Control = $PHolders/Scene.duplicate()
			scobj.name = t
			$Objects/Objs.add_child(scobj)
			var prscn : Node2D = $PHolders/PrScn.duplicate()
			prscn.name = t
			$Project.add_child(prscn)
			for w in script[t]:
				var mobj : Panel = $PHolders/Mobj.duplicate()
				var obj : CharacterBody2D = $PHolders/Obj.duplicate()
				var scrip : VBoxContainer = $PHolders/Script.duplicate()
				prscn.add_child(obj)
				obj.name = w
				scobj.add_child(mobj)
				mobj.name = w
				mobj.get_node("Title").text = w
				scscr.add_child(scrip)
				scrip.name = w
				var it = scscr.get_node(w)
				for y in script[t][w]["savoda"]:
					var nam = y[0]
					var frs = y[1]
					var commed : bool = false
					if len(y) > 2:
						commed = y[2]
					var posib : Array = ["Pole/Scroll"]
					for x in range(36):
						posib.append("Pole" + str(x + 2) + "/Scroll")
					for k in $Katalog/Blocks.get_children():
						for b in k.get_children():
							if str(b.name) == str(nam):
								var block : Panel = b.duplicate()
								block.name += "_" + str(Time.get_unix_time_from_system())
								while it.has_node(str(block.name)):
									block.name += ";"
								block.set_script(load("res://Scripts/block.gd"))
								it.add_child(block)
								if commed:
									block.modulate = Color(0.5, 0.5, 0.5, 1)
								for f in range(len(frs)):
									var fla = frs[f]
									formula_to_nodes(fla, block.get_node(posib[f] + "/LForms"))
								for c in block.get_children():
									if c is OptionButton:
										for i in range(c.get_item_count()):
											if c.get_item_text(i) == block.get_node("Pole" + c.name.replace("Optb", "").split("_")[0] + "/Scroll/LForms").text:
												c.selected = i
									if "Colorpicker" in c.name:
										var ogo = c.name.split("_")
										for i in range(len(ogo)):
											if i == 1:
												c.get_node("Scroll/LForms").color.r = float(block.get_node("Pole" + ogo[i] + "/Scroll/LForms").text) / 255
											if i == 2:
												c.get_node("Scroll/LForms").color.g = float(block.get_node("Pole" + ogo[i] + "/Scroll/LForms").text) / 255
											if i == 3:
												c.get_node("Scroll/LForms").color.b = float(block.get_node("Pole" + ogo[i] + "/Scroll/LForms").text) / 255
											if i == 4:
												c.get_node("Scroll/LForms").color.a = float(block.get_node("Pole" + ogo[i] + "/Scroll/LForms").text) / 255
	else:
		var scscr : Control = $PHolders/Scscr.duplicate()
		scscr.name = "Scene"
		$Scripts.add_child(scscr)
		var scene : Control = $PHolders/Tscn.duplicate()
		scene.name = "Scene"
		scene.get_node("Title").text = "Scene"
		scene.get_node("Main").modulate = Color(0.952, 0.85, 1.0, 0.694)
		$Objects/Objs/Scenesss.add_child(scene)
		var scobj : Control = $PHolders/Scene.duplicate()
		scobj.name = "Scene"
		$Objects/Objs.add_child(scobj)
		var prscn : Node2D = $PHolders/PrScn.duplicate()
		prscn.name = "Scene"
		$Project.add_child(prscn)
	$Loading/Prog.value = 80
	$Loading/Label.text = "Загрузка спрайтов..."
	await get_tree().create_timer(0.08).timeout
	var dir : DirAccess = DirAccess.open("user://Projects/" + projname + "/Sprites")
	if dir:
		dir.list_dir_begin()
		var file_name : String = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				var image : Image = Image.load_from_file("user://Projects/" + projname + "/Sprites/" + file_name)
				if image:
					var texture : ImageTexture = ImageTexture.create_from_image(image)
					var sprite : Panel = $PHolders/Sprite.duplicate()
					sprite.get_node("Panel/Icon").texture = texture
					var tex : String = file_name
					tex = tex.trim_suffix(".png")
					while tex.ends_with("_png"):
						tex = tex.trim_suffix("_png")
					sprite.get_node("Title").text = tex
					sprite.name = tex
					$Files/Files/Hernya/Fles.add_child(sprite)
			file_name = dir.get_next()
		dir.list_dir_end()
	$Loading/Prog.value = 90
	$Loading/Label.text = "Загрузка звуков..."
	await get_tree().create_timer(0.08).timeout
	dir = DirAccess.open("user://Projects/" + projname + "/Sounds")
	if dir:
		dir.list_dir_begin()
		var file_name : String = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				var paf : String = "user://Projects/" + projname + "/Sounds/" + file_name
				if FileAccess.file_exists(paf):
					var strim : AudioStream = AudioStreamMP3.load_from_file(paf)
					var snd : Panel = $PHolders/Sound.duplicate()
					snd.get_node("Audio").stream = strim
					var tex : String = file_name
					tex = tex.trim_suffix(".mp3")
					while tex.ends_with("_mp3"):
						tex = tex.trim_suffix("_mp3")
					snd.get_node("Title").text = tex
					snd.name = tex
					$Files/Files/Hernya/Snds.add_child(snd)
			file_name = dir.get_next()
		dir.list_dir_end()
	$Loading/Prog.value = 100
	$Loading/Label.text = "Финал..."
	await get_tree().create_timer(0.4).timeout
	for x in $Scripts.get_children():
		x.hide()
		for y in x.get_children():
			y.hide()
	var parent : Node = $Project
	var last_index : int = parent.get_child_count() - 1
	parent.move_child($Project/UIelems, last_index)
	$Loading.hide()
	$Scripts.hide()
	$Files.hide()
	if data:
		$Files/Files/Hernya/GameName.text = data["Name"]
		$Files/Files/Hernya/GameDesc.text = data["Desc"]
		$Files/Files/Hernya/GameVer.text = data["Ver"]
		if data.has("Main"):
			$Objects/Objs/Scenesss.get_node(data["Main"]).get_node("Main").modulate = Color(0.952, 0.85, 1.0, 0.694)
							
	
func _on_back_pressed() -> void:
	$Click.play()
	$OCM.target = null
	$ModlKat.hide()
	$Katalog.hide()
	$FE.hide()
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Buttons/Plus, "scale", Vector2(1, 1), 1)
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Buttons/Play, "scale", Vector2(1, 1), 1)
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Buttons/openFE, "scale", Vector2(1, 1), 1)
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Bak/Back, "scale", Vector2(1, 0.001), 1)

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if $Loading.visible:
			return
		if not mode:
			if $Katalog.visible or %ModlKat.visible or $FE.visible or $FormulEdit.visible:
				$Click.play()
				$OCM.target = null
				$Katalog.hide()
				%Modlkat.hide()
				$FormulEdit.hide()
				$FE.hide()
				create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Buttons/Plus, "scale", Vector2(1, 1), 1)
				create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Buttons/Play, "scale", Vector2(1, 1), 1)
				create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Buttons/openFE, "scale", Vector2(1, 1), 1)
				create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Bak/Back, "scale", Vector2(1, 0.001), 1)
			else:
				await save_proj()
				var sc : Control = load("res://editor.tscn").instantiate()
				sc.modulate = Color(0, 0, 0)
				get_parent().add_child(sc)
				queue_free()
		else:
			_stop()

func _on_plus_pressed() -> void:
	$Click.play()
	$OCM.target = null
	if $Scripts.visible:
		$Katalog.show()
		create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Buttons/Plus, "scale", Vector2(1, 0.001), 1)
		create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Buttons/Play, "scale", Vector2(1, 0.001), 1)
		create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Buttons/openFE, "scale", Vector2(1, 0.001), 1)
		create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Bak/Back, "scale", Vector2(1, 1), 1)
	elif $Objects.visible:
		if $Objects/Objs/Scenesss.visible:
			$NewScene.show()
		else:
			$NewObj.show()
			$NewObj/Panel/ScrollContainer/VBoxContainer/Panel.hide()
	else:
		var fdial : FileDialog = FileDialog.new()
		fdial.use_native_dialog = true
		fdial.add_filter("*.png, *.jpg, *.jpeg, *.svg, *.webp", "Спрайты")
		fdial.add_filter("*.mp3", "Звуки")
		fdial.access = FileDialog.ACCESS_FILESYSTEM
		fdial.file_mode = FileDialog.FILE_MODE_OPEN_FILE
		fdial.popup()
		var pth : String = await fdial.file_selected
		var tp = null
		if pth.get_extension() in ["png", "jpg", "jpeg", "svg", "webp"]:
			tp = "Img"
		if pth.get_extension() in ["mp3"]:
			tp = "Snd"
		if tp == "Img":
			var image : Image = Image.new()
			var img = image.load(pth)
			
			if img == OK:
				var fldr : String = "user://Projects/"
				var fpat : String = fldr + projname
				var texture : ImageTexture = ImageTexture.create_from_image(image)
				var sprite : Panel = $PHolders/Sprite.duplicate()
				sprite.get_node("Panel/Icon").texture = texture
				sprite.name = pth.get_file().get_basename()
				sprite.get_node("Title").text = pth.get_file().get_basename()
				$Files/Files/Hernya/Fles.add_child(sprite)
				if not DirAccess.dir_exists_absolute(fpat + "/Sprites"):
					DirAccess.make_dir_recursive_absolute(fpat + "/Sprites")
				image.save_png(fpat + "/Sprites/" + pth.get_file().get_basename() + ".png")
		elif tp == "Snd":
			var snd : AudioStream = AudioStreamMP3.load_from_file(pth)
			var sndo : Panel = $PHolders/Sound.duplicate()
			sndo.get_node("Audio").stream = snd
			sndo.name = pth.get_file().get_basename()
			sndo.get_node("Title").text = pth.get_file().get_basename()
			$Files/Files/Hernya/Snds.add_child(sndo)
		save_proj()
			

func expr():
	var dil : FileDialog = FileDialog.new()
	dil.use_native_dialog = true
	dil.access = FileDialog.ACCESS_FILESYSTEM
	dil.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	dil.popup()
	var path : String = await dil.file_selected
	if not path.ends_with(".coreal"):
		path += ".coreal"
	var packer : ZIPPacker = ZIPPacker.new()
	packer.open(path)
	
	var project_path : String = "user://Projects/" + projname + "/"
	var dir : DirAccess = DirAccess.open(project_path)
	dir.list_dir_begin()
	var file : String = dir.get_next()
	while file != "":
		if not dir.current_is_dir():
			packer.start_file(file)
			packer.write_file(FileAccess.get_file_as_bytes(project_path + file))
			packer.close_file()
		file = dir.get_next()
	for x in ["Sprites/", "Sounds/"]:
		var spath : String = project_path + x
		if DirAccess.dir_exists_absolute(spath):
			var s_dir : DirAccess = DirAccess.open(spath)
			s_dir.list_dir_begin()
			var s_file : String = s_dir.get_next()
			while s_file != "":
				if not s_dir.current_is_dir():
					packer.start_file(x + s_file)
					packer.write_file(FileAccess.get_file_as_bytes(spath + s_file))
					packer.close_file()
				s_file = s_dir.get_next()
			
	packer.close()

func _on_play_pressed() -> void:
	$Click.play()
	$OCM.target = null
	_play()

func _on_objects_pressed() -> void:
	$Click.play()
	$OCM.target = null
	$Objects.show()
	$Files.hide()
	$Scripts.hide()

func _on_files_pressed() -> void:
	$Click.play()
	$OCM.target = null
	$Objects.hide()
	$Files.show()
	$Scripts.hide()

func _on_scripts_pressed() -> void:
	$Click.play()
	$OCM.target = null
	$Objects.hide()
	$Files.hide()
	$Scripts.show()

func _on_icon_chs_pressed() -> void:
	var filedil : FileDialog = FileDialog.new()
	filedil.use_native_dialog = true
	filedil.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	filedil.add_filter("*.png, *.jpg, *.webp", "Иконка")
	filedil.access = FileDialog.ACCESS_FILESYSTEM
	filedil.popup()
	var fle : String = await filedil.file_selected
	var img : Image = Image.load_from_file(fle)
	$Files/Files/Hernya/IconView/Icon/Icon.texture = ImageTexture.create_from_image(img)

func _on_del_proj_pressed() -> void:
	var dir : DirAccess = DirAccess.open("user://Projects/" + projname + "/Sprites")
	if dir:
		dir.list_dir_begin()
		var file_name : String = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				var paf : String = "user://Projects/" + projname + "/Sprites/" + file_name
				if FileAccess.file_exists(paf):
					dir.remove(paf)
			file_name = dir.get_next()
		dir.list_dir_end()
	dir = DirAccess.open("user://Projects/" + projname + "/Sounds")
	if dir:
		dir.list_dir_begin()
		var file_name : String = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				var paf : String = "user://Projects/" + projname + "/Sounds/" + file_name
				if FileAccess.file_exists(paf):
					dir.remove(paf)
			file_name = dir.get_next()
		dir.list_dir_end()
	dir = DirAccess.open("user://Projects/" + projname)
	dir.remove("user://Projects/" + projname + "/script.txt")
	dir.remove("user://Projects/" + projname + "/data.txt")
	dir.remove("user://Projects/" + projname + "/icon.png")
	var inn = str_to_var(FileAccess.get_file_as_string("user://settings.txt"))
	if inn:
		if not inn.has("Projs"):
			inn["Projs"] = {}
		inn["Projs"]["last"] = "none"
		var fil : FileAccess = FileAccess.open("user://settings.txt", FileAccess.WRITE)
		fil.store_string(str(inn))
		fil.close()
	DirAccess.remove_absolute("user://Projects/" + projname + "/Sprites")
	DirAccess.remove_absolute("user://Projects/" + projname + "/Sounds")
	DirAccess.remove_absolute("user://Projects/" + projname + "/Fonts")
	DirAccess.remove_absolute("user://Projects/" + projname)
	var sc : Control = load("res://editor.tscn").instantiate()
	get_parent().add_child(sc)
	queue_free()

func _openFE() -> void:
	$Click.play()
	$FE/Panel/VBoxContainer/sprite.clear()
	for x in $Files/Files/Hernya/Fles.get_children():
		$FE/Panel/VBoxContainer/sprite.add_item(x.name)
	if $Scripts.visible:
		for x in $Scripts.get_children():
			if x.visible:
				for y in x.get_children():
					if y.visible:
						$FE.targ = y
	$FE/Panel/VBoxContainer/posx/HSlider.value = 0
	$FE/Panel/VBoxContainer/posy/HSlider.value = 0
	$FE/Panel/VBoxContainer/sizx/HSlider.value = 1
	$FE/Panel/VBoxContainer/sizy/HSlider.value = 1
	$FE/Panel/VBoxContainer/modl.color = Color(1, 1, 1, 1)
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Buttons/Plus, "scale", Vector2(1, 0.001), 1)
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Buttons/Play, "scale", Vector2(1, 0.001), 1)
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Buttons/openFE, "scale", Vector2(1, 0.001), 1)
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property($Bak/Back, "scale", Vector2(1, 1), 1)
	$FE/Panel/VBoxContainer/sprite.select(-1)
	$FE.show()
	if not $FE.targ:
		return
	if $FE.data.has(str($FE.targ.get_parent().name)):
		if $FE.data[str($FE.targ.get_parent().name)].has(str($FE.targ.name)):
			var dat : Dictionary = $FE.data[str($FE.targ.get_parent().name)][str($FE.targ.name)]
			$FE/Panel/VBoxContainer/posx/HSlider.value = dat["Posx"]
			$FE/Panel/VBoxContainer/posy/HSlider.value = dat["Posy"]
			$FE/Panel/VBoxContainer/sizx/HSlider.value = dat["Sizx"]
			$FE/Panel/VBoxContainer/sizy/HSlider.value = dat["Sizy"]
			$FE/Panel/VBoxContainer/modl.color = dat["Modl"]
			for x in range($FE/Panel/VBoxContainer/sprite.item_count):
				if $FE/Panel/VBoxContainer/sprite.get_item_text(x) == dat["Sprite"]:
					$FE/Panel/VBoxContainer/sprite.select(x)

func _on_new_scene_pressed() -> void:
	var w = $NewScene/Panel/ScrollContainer/VBoxContainer/GameName.text
	var scene = $PHolders/Scene.duplicate()
	var scscr = $PHolders/Scscr.duplicate()
	var tscn = $PHolders/Tscn.duplicate()
	var prscn = $PHolders/PrScn.duplicate()
	scene.name = w
	scscr.name = w
	tscn.name = w
	tscn.get_node("Title").text = w
	prscn.name = w
	$Objects/Objs.add_child(scene)
	$Scripts.add_child(scscr)
	if len($Objects/Objs/Scenesss.get_children()):
		tscn.get_node("Main").modulate = Color(0.952, 0.85, 1.0, 0.694)
	$Objects/Objs/Scenesss.add_child(tscn)
	$Project.add_child(prscn)
	var parent = $Project
	var last_index = parent.get_child_count() - 1
	parent.move_child($Project/UIelems, last_index)
	$NewScene.hide()
	save_proj()

func _on_new_obj_pressed() -> void:
	var scn = ""
	for x in $Objects/Objs.get_children():
		if x.visible:
			scn = str(x.name)
	var w = $NewObj/Panel/ScrollContainer/VBoxContainer/GameName.text
	if $Objects/Objs.get_node(scn).has_node(w):
		w += str(randi_range(1000, 9999))
	if len(w) < 2:
		return
	var mobj = $PHolders/Mobj.duplicate()
	var obj = $PHolders/Obj.duplicate()
	if $Scripts.get_node(scn).has_node(w):
		$Scripts.get_node(scn).get_node(w).queue_free()
	var scrip = $PHolders/Script.duplicate()
	$Project.get_node(scn).add_child(obj)
	obj.name = w
	$Objects/Objs.get_node(scn).add_child(mobj)
	mobj.name = w
	if $NewObj/Panel/ScrollContainer/VBoxContainer/Panel.visible:
		var spr = $PHolders/Sprite.duplicate()
		spr.name = w + "-spr"
		spr.get_node("Title").text = w + "-spr"
		spr.get_node("Panel/Icon").texture = $NewObj/Panel/ScrollContainer/VBoxContainer/Panel/Icon.texture
		$Files/Files/Hernya/Fles.add_child(spr)
		if not $FE.data.has(scn):
			$FE.data[scn] = {}
		$FE.data[scn][w] = {
			"Sprite" : w + "-spr",
			"Posx" : 0.0,
			"Posy" : 0.0,
			"Sizx" : 1.0,
			"Sizy" : 1.0,
			"Modl" : Color(1, 1, 1, 1)
		}
	mobj.get_node("Title").text = w
	$Scripts.get_node(scn).add_child(scrip)
	scrip.name = w
	$NewObj.hide()
	save_proj()

func nds(node, cnt):
	var dcnt = 0
	for x in node.get_children():
		dcnt += await nds(x, cnt)
	cnt += 1 + dcnt
	return cnt

func tickk() -> void:
	for x in $Scripts.get_children():
		x.position = Vector2(25, 100)
	$Debug/LT.text = "FPS : " + str(int(Engine.get_frames_per_second())) + " / FrameTime : " + str(delta) + "ms
 DOT : " + Dot.ver + " ( DV-" + str(Dot.dotver) + " )
 WND : " + str(DisplayServer.window_get_size().x) + "x" + str(DisplayServer.window_get_size().y) + "
 NODES : " + str(await nds(self, 0)) + "x
 RENDER : " + str(RenderingServer.get_current_rendering_driver_name())
	og += 0.2
	if FE != null:
		$FormulEdit.fr = str_to_var("[" + FE.text + "]")
		$FormulEdit.targ = FE
		$FormulEdit.cursor = len($FormulEdit.fr)
		for x in $FormulEdit/data.get_children():
			if x.visible:
				x.free()
		for x in $FormulEdit/objj.get_children():
			if "касается" in x.text and not x == $FormulEdit/objj/tcs:
				x.free()
		var vs = []
		var cursc = null
		for x in $Scripts.get_children():
			if x.visible:
				cursc = str(x.name)
		for x in $Project.get_node(cursc).get_children():
			var cant : bool = false
			for o in $Scripts.get_node(cursc).get_children():
				if o.visible and o.name == x.name:
					cant = true
			if cant:
				continue
			if not x is CharacterBody2D:
				continue
			var va : Button = $FormulEdit/objj/tcs.duplicate()
			va.text = " касается объекта " + x.name + " ? "
			$FormulEdit/objj.add_child(va)
			va.pressed.connect($FormulEdit.tcss.bind(x.name))
			va.show()
		for x in $Scripts.get_children():
			for y in x.get_children():
				for w in y.get_children():
					if (str(w.name).begins_with("setvar_") or str(w.name).begins_with("addlist_") or str(w.name).begins_with("adddict_")) and !vs.has(w.get_node("Pole/Scroll/LForms").text):
						var va : Button = $FormulEdit/data/var.duplicate()
						va.text = " " + w.get_node("Pole/Scroll/LForms").text + " "
						vs.append(w.get_node("Pole/Scroll/LForms").text)
						$FormulEdit/data.add_child(va)
						va.pressed.connect($FormulEdit.varr.bind(w.get_node("Pole/Scroll/LForms").text))
						va.show()
						va = $FormulEdit/data/listelem.duplicate()
						va.text = " элемент " + w.get_node("Pole/Scroll/LForms").text + " [ 1 ] "
						vs.append(w.get_node("Pole/Scroll/LForms").text)
						$FormulEdit/data.add_child(va)
						va.pressed.connect($FormulEdit.lelem.bind(w.get_node("Pole/Scroll/LForms").text))
						va.show()
					if str(w.name).begins_with("setlocalvar_") and !vs.has(w.get_node("Pole/Scroll/LForms").text):
						var va : Button = $FormulEdit/data/var.duplicate()
						va.text = " " + w.get_node("Pole/Scroll/LForms").text + " "
						vs.append(w.get_node("Pole/Scroll/LForms").text)
						$FormulEdit/data.add_child(va)
						va.pressed.connect($FormulEdit.lvarr.bind(w.get_node("Pole/Scroll/LForms").text))
						va.show()
						va = $FormulEdit/data/listelem.duplicate()
						va.text = " элемент " + w.get_node("Pole/Scroll/LForms").text + " [ 1 ] "
						vs.append(w.get_node("Pole/Scroll/LForms").text)
						$FormulEdit/data.add_child(va)
						va.pressed.connect($FormulEdit.lelem.bind(w.get_node("Pole/Scroll/LForms").text))
						va.show()
		FE = null
	
	if OCM != null:
		$OCM.offset = DisplayServer.mouse_get_position() - DisplayServer.window_get_position()
		$OCM.target = OCM
		$OCM.chosd = false
		if OCM is LineEdit:
			$OCM/Panel/Remove.position.y = 30
			$OCM/Panel/Add/addmodule.position.y = 0
			$OCM/Panel/Add.text = "добавить модуль"
			$OCM/Panel/Remove/remmodule.position.y = 30
			$OCM/Panel.size.y = 60
			if "Forms" in OCM.name:
				$OCM/Panel/Remove.visible = false
				$OCM/Panel.size.y -= 30
			else:
				$OCM/Panel/Remove.visible = true
		else:
			$OCM/Panel/Add.position.y = 0
			$OCM/Panel/Remove.position.y = 30
			$OCM/Panel/Add/addmodule.position.y = 0
			$OCM/Panel/Add.text = "заменить модуль"
			$OCM/Panel/Remove/remmodule.position.y = 30
			$OCM/Panel/Remove.visible = true
			$OCM/Panel.size.y = 60
		OCM = null


func sprit() -> void:
	var filedil : FileDialog = FileDialog.new()
	filedil.use_native_dialog = true
	filedil.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	filedil.add_filter("*.png, *.jpg, *.webp", "Иконка")
	filedil.access = FileDialog.ACCESS_FILESYSTEM
	filedil.popup()
	var fle : String = await filedil.file_selected
	var img : Image = Image.load_from_file(fle)
	$NewObj/Panel/ScrollContainer/VBoxContainer/Panel.show()
	$NewObj/Panel/ScrollContainer/VBoxContainer/Panel/Icon.texture = ImageTexture.create_from_image(img)
