extends CharacterBody2D
var gravity = Vector2(0, 0)
var damp = 0.9
var freeze = true
var bounce = 0.6
var hitmod = 1
var mycol = []
@onready var locl = get_tree().root.get_node("Game/PHolders/Loclu").duplicate()
@onready var light = $Light
func _ready() -> void:
	if str(get_parent().name) != "PHolders":
		get_parent().add_child(locl)
func _physics_process(delta: float) -> void:
	light.scale = Vector2(1 / scale.x, 1 / scale.y)
	#light.position = position
	locl.position = position
	locl.skew = skew
	locl.rotation = rotation
	if get_parent().name != "PHolders":
		get_parent().get_parent().get_parent().colls[name] = mycol
	if not freeze:
		velocity += gravity * delta * 100
		var coll = move_and_slide()
		print(coll)
		if coll:
			var collision = get_last_slide_collision()
			print(collision)
			if collision:
				velocity = velocity.bounce(collision.get_normal()) * bounce
				move_and_slide()
	else:
		velocity = Vector2.ZERO
	var base = Vector2(0, 0)
	if $Sprite.texture:
		base = $Sprite.texture.get_size()
	$Touch.scale = base / 128
	locl.scale = Vector2(scale.x, scale.y)
	var ocl : OccluderPolygon2D = locl.occluder
	ocl.polygon[0] = Vector2(base.x / 2, base.y / 2)
	ocl.polygon[1] = Vector2(base.x / 2, -base.y / 2)
	ocl.polygon[2] = Vector2(-base.x / 2, -base.y / 2)
	ocl.polygon[3] = Vector2(-base.x / 2, base.y / 2)
	$Hit.scale = base / 128 * hitmod
	$Area/Hit.scale = base / 128 * hitmod

func _on_area_area_entered(area: Area2D) -> void:
	if area.get_parent().get_parent() == get_parent():
		mycol.append(area.get_parent().name)
	pass # Replace with function body.


func _on_area_area_exited(area: Area2D) -> void:
	if area.get_parent().get_parent() == get_parent():
		mycol.remove_at(mycol.find(area.get_parent().name))
	pass # Replace with function body.
