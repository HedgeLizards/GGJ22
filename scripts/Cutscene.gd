extends VideoPlayer

func _unhandled_key_input(event):
	if event.scancode == KEY_ESCAPE:
		get_tree().change_scene_to(load('res://scenes/Start.tscn'))

func _on_Cutscene_finished():
	get_tree().change_scene_to(preload('res://scenes/Main.tscn'))

func _on_Skip_pressed():
	_on_Cutscene_finished()

func _on_Skip_mouse_entered():
	$Skip.modulate = Color(111, 208, 35, 255) / 255.0

func _on_Skip_mouse_exited():
	$Skip.modulate = Color.white
