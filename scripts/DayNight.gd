extends Node



var time = 0

var day = true
var initialized = false
var nbeats = 0
var ndays = 0 # The first day this is immidiately incremented so ndays 1 is the first day

onready var HUD = get_node("/root/Main/HUD")

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
	$DayOutro.play(0.0)
	HUD.get_node("Heart").visible = true
	HUD.get_node("HeartLabel").visible = true
	HUD.get_node("Moon").visible = false
	HUD.get_node("MoonLabel").visible = false
	HUD.get_node("Plant").visible = false
	HUD.get_node("PlantLabel").visible = false
	VisualServer.set_default_clear_color(Color.black)

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
	ndays += 1
	$DayEnd.start()
	get_tree().call_group("dual", "daystart")
	get_tree().call_group("dual", "daychange", false)
	$NightMusic.stop()
	$BeatTimer.stop()
	$DayMusic.play(0.0)
	if initialized:
		$NightOutro.play(0.0)
		HUD.get_node("Heart").visible = false
		HUD.get_node("HeartLabel").visible = false
		HUD.get_node("Moon").visible = true
		HUD.get_node("MoonLabel").text = str(ndays - 1)
		HUD.get_node("MoonLabel").visible = true
		HUD.get_node("Plant").visible = true
		HUD.get_node("PlantLabel").visible = true
	VisualServer.set_default_clear_color(Color(155, 246, 255, 255) / 255.0)

func _on_DayEnd_timeout():
	pass

func _on_NightMusic_finished():
	turn_day()
	
func _on_DayMusic_finished():
	turn_night()


func _on_BeatTimer_timeout():
	#get_tree().call_group("onbeat", "onbeat")
	pass
