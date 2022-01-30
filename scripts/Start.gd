extends VBoxContainer

func _input(event):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && !event.pressed:
		if OS.has_feature('web'):
			get_tree().change_scene_to(preload('res://scenes/Main.tscn'))
		else:
			get_tree().change_scene_to(preload('res://scenes/Cutscene.tscn'))

func _on_Play_mouse_entered():
	$Play.modulate = Color(111, 208, 35, 255) / 255.0

func _on_Play_mouse_exited():
	$Play.modulate = Color.white
