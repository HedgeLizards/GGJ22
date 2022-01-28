extends Node2D

var humidity = 1
var watered = false
var fullgrown = false

onready var Main = get_parent()
onready var Tooltip = Main.get_node('Tooltip')

func _process(delta):
	if watered:
		humidity = min(humidity + delta / 2, 1)
	else:
		humidity -= delta / 20
		
		if humidity <= 0:
			_on_Area2D_mouse_exited()
			
			queue_free()
	
	update()

func _on_Area2D_mouse_entered():
	Main.hovered_plant = self
	
	Tooltip.text = 'Click and hold to water the plant'

func _on_Area2D_mouse_exited():
	if Main.hovered_plant == self:
		Main.hovered_plant = null
		
		Tooltip.text = 'Click and hold to plant a seed'

func _draw():
	if Main.hovered_plant == self:
		draw_rect(Rect2(-82, -52, 164, 10), Color.blue, false, 4)
		draw_rect(Rect2(-80, -50, 160 * humidity, 6), Color.blue)
