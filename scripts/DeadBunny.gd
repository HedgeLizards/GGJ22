extends Node2D

var is_fading = false
var fade_speed = 1
var vis = 1.0

func daychange(is_night):
	if not is_night:
		$Corpse.visible = false
		$Carcass.visible = true
		$Timer.start(2 + randf() * 10)


func _process(delta):
	if is_fading:
		vis -= delta * fade_speed
		if vis <= 0:
			queue_free()
		else:
			modulate.a = vis
		

func _on_Timer_timeout():
	is_fading = true
