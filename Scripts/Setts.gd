extends Control
var intr = 0.0
var interval = 10
var ogo = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ogo = str_to_var(FileAccess.get_file_as_string("user://settings.txt"))
	if ogo:
		pass
	else:
		ogo = {
			"UI" : {
				"Scale" : 1.2,
				"Fullscreen" : false,
				"Tabsize" : 60,
				"Lang" : "ru"
			},
			"GRAPH": {
				"MaxFPS" : round(DisplayServer.screen_get_refresh_rate()),
				"VSync" : true
			},
			"SYS" : {
				"ProjPath" : "user:/",
				"AutoSaveInterval" : 10
			}
		}
	interval = ogo["SYS"]["AutoSaveInterval"]
	$Setts/MainSetts/Setts/Overall/Cont/Scal.value = ogo["UI"]["Scale"]
	Disp.bod = ogo["UI"]["Scale"]
	if not ogo["UI"].has("Lang"):
		ogo["UI"]["Lang"] = "ru"
	if not ogo.has("Custom"):
		ogo["Custom"] = {
			"Bgmod" : "b444ff",
			"ButBord" : "cc96ff87",
			"ButBg" : "9101cf56",
			"DevBlockBord" : "ff9d7b",
			"DevBlockBg" : "ff9d7b",
			"PhyBlockBord" : "0000e3",
			"PhyBlockBg" : "3d00fd",
			"EveBlockBord" : "f19b00",
			"EveBlockBg" : "ffab00",
			"FilBlockBord" : "ef9e00",
			"FilBlockBg" : "ffb400",
			"LogBlockBord" : "0db47b",
			"LogBlockBg" : "58cb74",
			"MovBlockBord" : "4ca4ff",
			"MovBlockBg" : "70b7ff",
			"VarBlockBord" : "ff445c",
			"VarBlockBg" : "ff5c6e",
			"LookBlockBord" : "a901dd",
			"LookBlockBg" : "bf12ff",
			"BluModuleBord" : "00daf1",
			"BluModuleBg" : "53e7ff",
			"CyaModuleBord" : "00d8b5",
			"CyaModuleBg" : "00e6c2",
			"GreModuleBord" : "00c451",
			"GreModuleBg" : "00cb5b",
			"PurModuleBord" : "9671ff",
			"PurModuleBg" : "9c7eff",
			"VarModuleBord" : "ff2f50",
			"VarModuleBg" : "ff4252",
			"FontColor" : "e6a9ff"
		}
	get_parent().get_node("BG").modulate = ogo["Custom"]["Bgmod"]
	load("res://UIpanel.tres").border_color = ogo["Custom"]["ButBord"]
	load("res://UIpanel.tres").bg_color = ogo["Custom"]["ButBg"]
	okras(get_parent(), ogo["Custom"]["FontColor"])
	if not ogo["UI"].has("Tabsize"):
		ogo["UI"]["Tabsize"] = 60
	$Setts/MainSetts/Setts/Overall/Cont/Tab.value = ogo["UI"]["Tabsize"]
	await get_tree().process_frame
	if ogo["UI"]["Fullscreen"] == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	if ogo["GRAPH"]["VSync"] == true:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	$Setts/MainSetts/Setts/Overall/Cont/MFP.max_value = round(DisplayServer.screen_get_refresh_rate())
	$Setts/MainSetts/Setts/Overall/Cont/MFP.value = ogo["GRAPH"]["MaxFPS"]
	#Engine.max_fps = ogo["GRAPH"]["MaxFPS"]

	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Setts/MainSetts/Setts/Overall.size.x = Disp.x - 90
	$Setts/MainSetts/Setts/System.size.x = Disp.x - 90
	intr += delta
	if intr > interval:
		intr = 0.0
		ogo["UI"]["Scale"] = $Setts/MainSetts/Setts/Overall/Cont/Scal.value
		ogo["UI"]["Fullscreen"] = $Setts/MainSetts/Setts/Overall/Cont/FSc.button_pressed
		ogo["UI"]["Tabsize"] = $Setts/MainSetts/Setts/Overall/Cont/Tab.value
		ogo["GRAPH"]["VSync"] = $Setts/MainSetts/Setts/Overall/Cont/Vsync.button_pressed
		var fl = FileAccess.open("user://settings.txt", FileAccess.WRITE)
		fl.store_string(str(ogo))
		fl.close()
	$Setts/MainSetts/Setts/Overall/Cont/MFP.max_value = round(DisplayServer.screen_get_refresh_rate())
	$Setts/MainSetts/Setts/Overall/Cont/Alert.offset_left = $Setts/MainSetts/Setts/Overall/Cont/Tab.value
	$Setts/MainSetts/Setts/Overall/Cont/Scl/Mash.text = "( " + str(int(round($Setts/MainSetts/Setts/Overall/Cont/Scal.value * 100))) + "% )"
	$Setts/MainSetts/Setts/Overall/Cont/MF/Mash.text = "( " + str(int(round($Setts/MainSetts/Setts/Overall/Cont/MFP.value))) + " )"
	$Setts/MainSetts/Setts/Overall/Cont/Tb/Mash.text = "( " + str(int(round($Setts/MainSetts/Setts/Overall/Cont/Tab.value))) + " )"
	#$Setts/MainSetts/Setts/System/Cont/ASIN/Mash.text = "( " + str(int(round($Setts/MainSetts/Setts/System/Cont/ASIN.value))) + "с )"

func okras(o, f):
	for x in o.get_children():
		if x is Label:
			if x.label_settings:
				if x.label_settings.font_color != Color(1, 1, 1, 1):
					x.label_settings.font_color = f
		if x is TextureRect and x.name != "BG":
			if x.modulate != Color(1, 1, 1, 1):
				x.modulate = f
		okras(x, f)
