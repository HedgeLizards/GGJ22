extends Node



var time = 0

var day = true
var initialized = false
var nbeats = 0

#var startspeed = 2
#var endspeed = 5

func _process(delta):
	if not initialized:
		turn_day()
		initialized = true
	time += delta
	if not day:
		var length = $NightMusic.stream.get_length()
		#var n = $NightMusic.get_playback_position() / length + startspeed
		if nbeats < $NightMusic.get_playback_position() * 2:
			get_tree().call_group("onbeat", "onbeat")
			nbeats += 1
			

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
	nbeats = 0
	$BeatTimer.start()
	$DayMusic.stop()

func _input(event):
	if event.is_action_pressed("skip"):
		if day:
			turn_night()
		else:
			turn_day()

func turn_day():
	if day and initialized:
		return
	day = true
	$DayEnd.start()
	get_tree().call_group("dual", "daystart")
	get_tree().call_group("dual", "daychange", false)
	$NightMusic.stop()
	$BeatTimer.stop()
	$DayMusic.play(0.0)

func _on_DayEnd_timeout():
	pass

func _on_NightMusic_finished():
	turn_day()
	
func _on_DayMusic_finished():
	turn_night()


func _on_BeatTimer_timeout():
	#get_tree().call_group("onbeat", "onbeat")
	pass
