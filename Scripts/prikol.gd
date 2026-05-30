extends Node2D
var balls = 0
func _ready() -> void:
	get_window().title = "Dot - Прикалюшечка)"
func _process(_delta: float) -> void:
	$Rig.position.x = DisplayServer.window_get_size().x
	$Dn.position.y = DisplayServer.window_get_size().y
	$dot.position.x = DisplayServer.window_get_size().x / 2.0
	$Label.size = DisplayServer.window_get_size()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if not event.pressed:
			return
		balls += 1
		var ogo : RigidBody2D = $dot.duplicate()
		ogo.freeze = false
		add_child(ogo)
		if balls > 10:
			$Label.text = "Ну чтож..."
		if balls > 20:
			$Label.text = "Не знаю как ты меня нашел , но..."
		if balls > 30:
			$Label.text = "Нет времени объяснять, встретимся в r2"
		if balls > 40:
			$Label.hide()
