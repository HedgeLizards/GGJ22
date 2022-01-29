extends Timer



export var max_rabbits = 5
export var outside_spawn_distance = 40

const Rabbit = preload("res://scenes/Rabbit.tscn")


func _on_Spawner_timeout():
	if get_tree().get_nodes_in_group("bunnies").size() < max_rabbits:
		
		var bunny = Rabbit.instance()
		get_node("/root").add_child(bunny)
		
		if randf() < 0.5:
			bunny.global_position.x = get_node("/root/Main/LeftEdge").position.x #- outside_spawn_distance
		else:
			bunny.global_position.x = get_node("/root/Main/RightEdge").position.x + outside_spawn_distance
		var top_y = get_node("/root/Main/TopEdge").position.y + 5
		var bottom_y = get_node("/root/Main/BottomEdge").position.y
		bunny.global_position.y = top_y + randf() * (bottom_y - top_y)
