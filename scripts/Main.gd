extends Node

var hovered_plants = []
var plants_harvested = 0 setget set_plants_harvested

func set_plants_harvested(new_value):
	plants_harvested = new_value
	
	$HUD/PlantLabel.text = str(plants_harvested)
