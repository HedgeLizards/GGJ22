extends Timer



var max_rabbits = 6
var outside_spawn_distance = 40
var delay = 1

const Rabbit = preload("res://scenes/Rabbit.tscn")


func _on_Spawner_timeout():
	var ndays = get_node("/root/Main/DayNight").ndays
	if get_tree().get_nodes_in_group("bunnies").size() < ndays + 2:
		
		var bunny = Rabbit.instance()
		get_node("/root/Main").add_child(bunny)
		
		if randf() < 0.5:
			bunny.global_position.x = get_node("/root/Main/LeftEdge").position.x - outside_spawn_distance
		else:
			bunny.global_position.x = get_node("/root/Main/RightEdge").position.x + outside_spawn_distance
		var top_y = get_node("/root/Main/TopEdge").position.y + 100
		var bottom_y = get_node("/root/Main/BottomEdge").position.y
		bunny.global_position.y = top_y + randf() * (bottom_y - top_y)
		start(max(1, delay - ndays))
