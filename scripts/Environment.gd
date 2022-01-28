extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_DayEnd_timeout():
	$Day.visible = false
	$Night.visible = true


func _on_NightEnd_timeout():
	$Day.visible = true
	$Night.visible = false
