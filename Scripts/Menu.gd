extends Control
var ogo = 0.0
var allow = true
func _ready() -> void:
	$Info/Panel/Info.text += "
	" + Engine.get_license_text()
	get_window().title = "Dot - Главное меню"
	create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO).tween_property(self, "modulate", Color(1, 1, 1, 1), 1)
	var og = str_to_var(FileAccess.get_file_as_string("user://settings.txt"))
	if og:
		if og["UI"].has("Lang"):
			Dot.lang = og["UI"]["Lang"]
	transl(self)
	var type = "Vanilla"
	if Modcore.modded:
		type = "MODDED"
		if Modcore.mod_name != "NAME_HERE":
			type += " ( " + Modcore.mod_name + " )"
	$Inf.text = Dot.ver + "
	" + type
	DisplayServer.window_set_min_size(Vector2i(500, 800))
	if OS.get_name() == "Android":
		OS.request_permissions()
	var setts = str_to_var(FileAccess.get_file_as_string("user://settings.txt"))
	if setts:
		if not setts.has("Projs"):
			setts["Projs"] = {
				"last" : "none",
				"folder" : "user://Projects/"
			}
			FileAccess.open("user://settings.txt", FileAccess.WRITE).store_string(str(setts))
		else:
			if setts["Projs"]["last"] != "none":
				$MainMenu/LastProj/Cont.show()
				$MainMenu/LastProj/New.hide()
				$MainMenu/LastProj/Cont/Filename.text = setts["Projs"]["last"]
				var projdata = str_to_var(FileAccess.get_file_as_string("user://Projects/" + setts["Projs"]["last"] + "/data.txt"))
				if projdata:
					$MainMenu/LastProj/Cont/Title.text = projdata["Name"]
					$MainMenu/LastProj/Cont/Subtitle.text = projdata["Desc"]
					$MainMenu/LastProj/Cont/Ver.text = projdata["Ver"]
					$MainMenu/LastProj/Cont/Title.text = projdata["Name"]
					var ikonka = ImageTexture.create_from_image(Image.load_from_file("user://Projects/" + setts["Projs"]["last"] + "/icon.png"))
					$MainMenu/LastProj/Cont/Panel/Icon.texture = ikonka
					ikonka = null
					var time = projdata["Last"]
					var last = Time.get_unix_time_from_system() - time
					var schet = " сек."
					if time < 0.1:
						$MainMenu/LastProj/Cont/Time.text = "никогда "
					else:
						if last > (3600 * 24):
							last /= (3600 * 24)
							schet = " дн."
						elif last > 3600:
							last /= 3600
							schet = " ч."
						elif last > 60:
							last /= 60
							schet = " мин."
						$MainMenu/LastProj/Cont/Time.text = str(int(floor(last))) + schet + " назад "
				projdata = null
	var dir = DirAccess.open("user://")
	if dir and not dir.dir_exists("Projects"):
		dir.make_dir("Projects")
	dir = DirAccess.open("user://Projects")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				var time = 0
				var ikonka = ImageTexture.create_from_image(Image.load_from_file("user://Projects/" + str(file_name) + "/icon.png"))
				var proj = $Holders/Project.duplicate()
				proj.get_node("Filename").text = file_name
				var corereal = str_to_var(FileAccess.get_file_as_string("user://Projects/" + file_name + "/data.txt"))
				if corereal:
					if corereal["Arch"] != Dot.arch:
						proj.self_modulate = Color(1, 0.5, 0.5)
						proj.get_node("Butts/Error").show()
					elif corereal["Dotver"] > Dot.dotver:
						proj.self_modulate = Color(1, 0.5, 0.5)
						proj.get_node("Butts/Error").show()
						proj.get_node("Butts/Error/Label").text = "Возможно несовместимо"
					if not Modcore.modded:
						if corereal.has("Modded"):
							if corereal["Modded"]:
								proj.self_modulate = Color(1, 0.8, 0.8)
								proj.get_node("Butts/Error").show()
								proj.get_node("Butts/Error/Label").text = "Используйте мод " + corereal["Modname"] + " чтобы запустить проект"
					if corereal.has("Name"):
						proj.get_node("Title").text = str(corereal["Name"])
					else:
						proj.get_node("Title").text = file_name
					if corereal.has("Desc"):
						proj.get_node("Subtitle").text = str(corereal["Desc"])
					else:
						proj.get_node("Subtitle").text = ""
					if corereal.has("Ver"):
						proj.get_node("Ver").text = str(corereal["Ver"])
					else:
						proj.get_node("Ver").text = ""
					if corereal.has("Last"):
						time = corereal["Last"]
						var last = Time.get_unix_time_from_system() - time
						var schet = " сек."
						if time == 0:
							proj.get_node("Time").text = "никогда"
						else:
							if last > (3600 * 24 * 365):
								last /= (3600 * 24 * 365)
								schet = " год."
							if last > (3600 * 24 * 31):
								last /= (3600 * 24 * 31)
								schet = " мес."
							if last > (3600 * 24 * 14):
								last /= (3600 * 24 * 7)
								schet = " нед."
							elif last > (3600 * 24):
								last /= (3600 * 24)
								schet = " дн."
							elif last > 3600:
								last /= 3600
								schet = " ч."
							elif last > 60:
								last /= 60
								schet = " мин."
							proj.get_node("Time").text = str(int(floor(last))) + schet + " назад"
						
				else:
					proj.self_modulate = Color(1, 0.2, 0.2)
					proj.get_node("Butts/Error").show()
					proj.get_node("Butts/Error/Label").text = "Потеряно"
					proj.get_node("Title").text = file_name
				if len(proj.get_node("Title").text) > 20:
					var ok = ""
					for x in range(len(proj.get_node("Title").text)):
						var tex = proj.get_node("Title").text[x]
						if x > 20:
							ok += ".."
							break
						else:
							ok += tex
					proj.get_node("Title").text = ok
				proj.get_node("Panel/Icon").texture = ikonka
				ikonka = null
				corereal = null
				$MyProjs/Visual/Scroll/Projects.add_child(proj)
			file_name = dir.get_next()
		dir.list_dir_end()
	for x : Control in $MainMenu.get_children():
		x.position.x += 5000
		x.pivot_offset_ratio = Vector2(0.5, 0.5)
		x.rotation = 0.3
	for x in $MainMenu.get_children():
		await get_tree().create_timer(0.03).timeout
		create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).tween_property(x, "position", Vector2(x.position.x - 5000, x.position.y), 1.6)
		create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).tween_property(x, "rotation", 0, 1.6)

func impr():
	var dildo = FileDialog.new()
	dildo.use_native_dialog = true
	dildo.access = FileDialog.ACCESS_FILESYSTEM
	dildo.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dildo.popup()
	var path = await dildo.file_selected
	var reader = ZIPReader.new()
	var err = reader.open(path)
	
	
	if err != OK:
		return

	var pname = path.get_file().get_basename()
	var pat = "user://Projects/" + pname + "/"
	
	var files = reader.get_files()
	for f in files:
		var data = reader.read_file(f)
		var dath = pat + f.get_base_dir()
		if not DirAccess.dir_exists_absolute(dath):
			DirAccess.make_dir_recursive_absolute(dath)
			
		var out_file = FileAccess.open(pat + f, FileAccess.WRITE)
		out_file.store_buffer(data)
		
	var editor = load("res://game.tscn").instantiate()
	editor.projname = pname
	reader.close()
	get_parent().add_child(editor)
	queue_free()

func get_chld_o(node):
	if node is Label or node is RichTextLabel:
		mena(node)
		return
	for x in node.get_children():
		get_chld_o(x)

func mena(obj):
	if not obj.has_meta("BF"):
		obj.set_meta("BF", obj.get_theme_font_size("normal_font_size"))
	if not obj.has_meta("BY"):
		obj.set_meta("BY", obj.size.y)
	if not obj.has_meta("BX"):
		obj.set_meta("BX", obj.size.x)
	obj.scale = Vector2(1, 1) / Disp.mod
	obj.size.y = obj.get_meta("BY") * Disp.mod
	obj.size.x = obj.get_meta("BX") * Disp.mod
	obj.add_theme_font_size_override("normal_font_size",obj.get_meta("BF") * Disp.mod)
	
	pass


func _on_button_pressed() -> void:
	$Click.play()
	$Title.hide()
	$MainMenu.visible = false
	$MyProjs.visible = true
	$MyProjs/Visual.position.y = 95
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property($MyProjs/Visual, "position", Vector2(25, 85), 0.5)


func _on_back_pressed() -> void:
	$Title.show()
	$Click.play()
	$MainMenu.visible = true
	$MyProjs.visible = false
	$NewProj.visible = false
	$Setts.visible = false
	$Info.visible = false
	Disp.bod = $Setts/Setts/MainSetts/Setts/Overall/Cont/Scal.value
	Disp.sepr = $Setts/Setts/MainSetts/Setts/Overall/Cont/Tab.value
	if $Setts/Setts/MainSetts/Setts/Overall/Cont/FSc.button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	if $Setts/Setts/MainSetts/Setts/Overall/Cont/Vsync.button_pressed == true:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	Engine.max_fps = $Setts/Setts/MainSetts/Setts/Overall/Cont/MFP.value
	pass # Replace with function body.
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.key_label == KEY_F11 and ogo > 0.2:
			ogo = 0
			if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		if event.key_label == KEY_F9 and ogo > 0.2:
			ogo = 0
			impr()


func _on_exit_pressed() -> void:
	$Click.play()
	get_tree().quit()
	pass # Replace with function body.


func _on_new_pressed() -> void:
	$Click.play()
	$MainMenu.visible = false
	$MyProjs.visible = false
	$NewProj.visible = true
	$NewProj/Setts.position.y = 210
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property($NewProj/Setts, "position", Vector2(25, 200), 0.5)
	pass # Replace with function body.

func anglifi(text):
	text = text.to_lower()
	var table = {
		"й" : "y",
		"ц" : "ts",
		"у" : "u",
		"к" : "k",
		"е" : "e",
		"н" : "n",
		"г" : "g",
		"ш" : "sh",
		"щ" : "sh",
		"з" : "z",
		"х" : "h",
		"ъ" : "i",
		"ф" : "f",
		"ы" : "y",
		"в" : "v",
		"а" : "a",
		"п" : "p",
		"р" : "r",
		"о" : "o",
		"л" : "l",
		"д" : "d",
		"ж" : "j",
		"э" : "e",
		"я" : "ya",
		"ч" : "ch",
		"с" : "s",
		"м" : "m",
		"и" : "i",
		"т" : "t",
		"ь" : "'",
		"б" : "b",
		"ю" : "yu",
		" " : "_"
	}
	var ang = ""
	for x in text:
		if table.has(x):
			ang += table[x]
		if x in "qwertyuiopasdfghjklzxcvbnm-1234567890":
			ang += x
	return ang

func _on_create_pressed() -> void:
	$Click.play()
	allow = true
	var projname = await anglifi($NewProj/Setts/MainSetts/Setts/GameName.text)
	if DirAccess.dir_exists_absolute("user://Projects/" + projname):
		allow = false
		$Projex.show()
	else:
		var pat = "user://Projects/" + projname + "/"
		var imag = $NewProj/Setts/MainSetts/Setts/IconIcon/Icon.texture.get_image()
		var dir = DirAccess.open("user://")
		if not dir.dir_exists("Projects"):
			dir.make_dir("Projects")
		
		dir = DirAccess.open("user://Projects/")
		if not dir.dir_exists(projname):
			dir.make_dir(projname)
		imag.save_png("user://Projects/" + projname + "/icon.png")
		var alldanni = {"Formulas" : $NewProj/Setts/MainSetts/Setts/Frs.button_pressed, "Modded" : Modcore.modded, "Modname" : Modcore.mod_name, "Compat" : Modcore.can_vanilla, "Dotver": Dot.dotver, "Name": $NewProj/Setts/MainSetts/Setts/GameName.text, "Desc": $NewProj/Setts/MainSetts/Setts/GameDesc.text, "Arch": Dot.arch, "Last": Time.get_unix_time_from_system(), "Ver" : ""}
		FileAccess.open(pat + "data.txt", FileAccess.WRITE).store_string(str(alldanni))
		var editor = load("res://game.tscn").instantiate()
		editor.projname = projname
		get_parent().add_child(editor)
		queue_free()
	pass

func _on_open_setts_pressed() -> void:
	$Title.hide()
	$Click.play()
	$MainMenu.visible = false
	$Setts.visible = true
	$Setts/Setts.position.y = 35
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property($Setts/Setts, "position", Vector2(25, 25), 0.5)
	pass # Replace with function body.




func _on_itch_pressed() -> void:
	OS.shell_open("https://martiiimay.itch.io/pocketdot")
	pass # Replace with function body.


func _on_tg_pressed() -> void:
	OS.shell_open("https://t.me/Engine_Dot")
	pass # Replace with function body.



func _on_cancel_new_pressed() -> void:
	$Projex.hide()
	pass # Replace with function body.


func _on_re_new_pressed() -> void:
	var projname = await anglifi($NewProj/Setts/MainSetts/Setts/GameName.text)
	$Projex.hide()
	allow = true
	var pat = "user://Projects/" + projname + "/"
	var fl = FileAccess.open(pat + "script.txt", FileAccess.WRITE_READ)
	fl.store_string("{}")
	fl.close()
	var imag = $NewProj/Setts/MainSetts/Setts/IconIcon/Icon.texture.get_image()
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("Projects"):
		dir.make_dir("Projects")
	
	dir = DirAccess.open("user://Projects/")
	if not dir.dir_exists(projname):
		dir.make_dir(projname)
	imag.save_png("user://Projects/" + projname + "/icon.png")
	var alldanni = {"Formulas" : $NewProj/Setts/MainSetts/Setts/Frs.button_pressed, "Modded" : Modcore.modded, "Modname" : Modcore.mod_name, "Compat" : Modcore.can_vanilla, "Dotver": Dot.dotver, "Name": $NewProj/Setts/MainSetts/Setts/GameName.text, "Desc": $NewProj/Setts/MainSetts/Setts/GameDesc.text, "Arch": Dot.arch, "Last": Time.get_unix_time_from_system(), "Ver" : ""}
	FileAccess.open(pat + "data.txt", FileAccess.WRITE).store_string(str(alldanni))
	var editor = load("res://game.tscn").instantiate()
	editor.projname = projname
	get_parent().add_child(editor)
	queue_free()
	pass # Replace with function body.


func _on_ds_pressed() -> void:
	OS.shell_open("https://discord.gg/xkWp6Zvan")
	pass # Replace with function body.


func _on_docs_pressed() -> void:
	pass # Replace with function body.


func _on_proj_fold_pressed() -> void:
	OS.shell_open(OS.get_user_data_dir() + "/Projects")
	pass # Replace with function body.


func _on_info_pressed() -> void:
	$Info.show()
	pass # Replace with function body.


func _on_yt_pressed() -> void:
	OS.shell_open("https://www.youtube.com/@engine_dot")
	pass # Replace with function body.

func transl(node):
	if "text" in node:
		for w in Dot.table:
			node.text = node.text.replace(w, Dot.table[w][Dot.lang])
	for x in node.get_children():
		transl(x)
			


func tickk() -> void:
	anchor_bottom = 1 / Disp.mod
	anchor_right = 1 / Disp.mod
	scale = Vector2(Disp.mod, Disp.mod)
	ogo += 0.15
	$Title/Particles.position.x = Disp.x / 2


func secret() -> void:
	var editor = load("res://prikol.tscn").instantiate()
	get_parent().add_child(editor)
	queue_free()
	pass # Replace with function body.
