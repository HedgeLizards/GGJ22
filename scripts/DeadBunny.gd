extends Node2D


func daychange(is_night):
	if is_night:
		queue_free()
	else:
		$Corpse.visible = false
		$Carcass.visible = true
