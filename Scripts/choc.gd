extends Panel
@onready var advanced = [
	$ScrollContainer/VBoxContainer/Device/VBoxContainer/Unixtime,
	$ScrollContainer/VBoxContainer/Text/VBoxContainer/Tobase64,
	$ScrollContainer/VBoxContainer/Text/VBoxContainer/Frombase64,
	$ScrollContainer/VBoxContainer/Text/VBoxContainer/Tomd5,
	$ScrollContainer/VBoxContainer/Math/VBoxContainer/Inf,
	$ScrollContainer/VBoxContainer/Math/VBoxContainer/Pi,
	$ScrollContainer/VBoxContainer/Logic/VBoxContainer/Partin
	]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for x in advanced:
		if x:
			x.visible = $ShowAdvanced.button_pressed
	pass
