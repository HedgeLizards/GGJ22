extends Node



var time = 0

var day = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	time += delta



func is_day():
	return day

func is_night():
	return not is_day()



func _on_DayEnd_timeout():
	day = false
	$NightEnd.start()


func _on_NightEnd_timeout():
	day = true
	$DayEnd.start()
