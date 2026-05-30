extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Create.disabled = len($Setts/MainSetts/Setts/GameName.text) < 1
	$Setts/Scroll/Projects/Project/Title.text = $Setts/MainSetts/Setts/GameName.text
	$Setts/Scroll/Projects/Project/Subtitle.text = $Setts/MainSetts/Setts/GameDesc.text
	$Setts/Scroll/Projects/Project/Panel/Icon.texture = $Setts/MainSetts/Setts/IconIcon/Icon.texture
	$Setts/MainSetts/Setts/Path.text = " Projects/" + anglifi($Setts/MainSetts/Setts/GameName.text)
	for x in $Setts/Scroll/Projects.get_children():
		x.custom_minimum_size.x = Disp.x - 70
		x.size.x = Disp.x - 70
	for x in $Setts/MainSetts/Setts.get_children():
		x.custom_minimum_size.x = Disp.x - 80
		x.size.x = Disp.x - 80
		$Setts/MainSetts/Setts/IconIcon.custom_minimum_size.x = 131
	$Setts/MainSetts/Setts/IconIcon.size.x = 131


func _on_icon_pressed() -> void:
	var fdil = FileDialog.new()
	fdil.access = FileDialog.ACCESS_FILESYSTEM
	fdil.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	fdil.use_native_dialog = true
	fdil.add_filter("*.png, *.jpg, *.webp", "Icon")
	fdil.popup()
	var path = await fdil.file_selected
	var img = Image.load_from_file(path)
	var tex = ImageTexture.create_from_image(img)
	$Setts/MainSetts/Setts/IconIcon/Icon.texture = tex

func anglifi(text : String):
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
