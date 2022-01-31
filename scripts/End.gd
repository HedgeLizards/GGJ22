extends VBoxContainer

func _ready():
	$VBoxContainer/Plant/Label.text = $VBoxContainer/Plant/Label.text % Stats.plants_harvested
	$VBoxContainer/Moon/Label.text = $VBoxContainer/Moon/Label.text % Stats.nights_survived
	$VBoxContainer/Rabbit/Label.text = $VBoxContainer/Rabbit/Label.text % Stats.rabbits_killed

func _on_Retry_pressed():
	get_tree().change_scene_to(load('res://scenes/Main.tscn'))

func _on_Retry_mouse_entered():
	$Retry.modulate = Color(111, 208, 35, 255) / 255.0

func _on_Retry_mouse_exited():
	$Retry.modulate = Color.white
