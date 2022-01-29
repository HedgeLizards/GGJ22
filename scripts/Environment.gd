extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func daychange(is_night):
	$Day.visible = not is_night
	$Night.visible = is_night

