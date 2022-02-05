extends Node2D


func _process(delta):
	position = get_global_mouse_position()

func near_player():
	return not $NearPlayer.get_overlapping_areas().empty()

func can_plant():
	return $TooClose.get_overlapping_areas().empty() and not $InField.get_overlapping_areas().empty() and near_player()

func hovered_plants():
	var plants = []
	for area in $Plants.get_overlapping_areas():
		plants.push_back(area.get_parent())
	return plants

func update_hovered(_area):
	get_tree().call_group("hover_monitor", "update_hovered")
