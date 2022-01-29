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
	get_tree().call_group("dual", "nightstart")
	get_tree().call_group("dual", "daychange", true)


func _on_NightEnd_timeout():
	day = true
	$DayEnd.start()
	get_tree().call_group("dual", "daystart")
	get_tree().call_group("dual", "daychange", false)
