extends Node2D

var is_fading = false
var fade_speed = 1
var vis = 1.0
var dir = Vector2(0, 0)
var vel = 0

func daychange(is_night):
	if not is_night:
		$Corpse.visible = false
		$Carcass.visible = true
		$Timer.start(2 + randf() * 10)


func _physics_process(delta):
	if vel > 0:
		position += dir
	vel -= delta
	if is_fading:
		vis -= delta * fade_speed
		if vis <= 0:
			queue_free()
		else:
			modulate.a = vis
		

func _on_Timer_timeout():
	is_fading = true
