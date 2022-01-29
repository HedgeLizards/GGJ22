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


func turn_night():
	if not day:
		return
	day = false
	get_tree().call_group("dual", "nightstart")
	get_tree().call_group("dual", "daychange", true)
	$NightMusic.play(0.0)

func _input(event):
	if Input.is_action_just_pressed("skip"):
		if day:
			turn_night()
		else:
			turn_day()

func turn_day():
	if day:
		return
	day = true
	$DayEnd.start()
	get_tree().call_group("dual", "daystart")
	get_tree().call_group("dual", "daychange", false)
	$NightMusic.stop()

func _on_DayEnd_timeout():
	turn_night()

func _on_NightMusic_finished():
	turn_day()
