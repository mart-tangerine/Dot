extends Node
var bod = 1.5
var mod = bod
var x = DisplayServer.window_get_size().x / mod
var y = DisplayServer.window_get_size().y / mod
var si = DisplayServer.window_get_size() / mod
var sepr = 60
var projpath = "user:/"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mod = bod
	x = DisplayServer.window_get_size().x / mod
	y = DisplayServer.window_get_size().y / mod
	si = DisplayServer.window_get_size() / mod
	pass
