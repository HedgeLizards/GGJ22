extends Node2D

var humidity = 1
var watered = false
var fullgrown = false

onready var Main = get_parent()
onready var Tooltip = Main.get_node('Tooltip')

func _ready():
	var DayNight = Main.get_node('DayNight')
	
	DayNight.get_node('DayEnd').connect('timeout', self, '_on_DayEnd_timeout')
	DayNight.get_node('NightEnd').connect('timeout', self, '_on_NightEnd_timeout')

func _on_DayEnd_timeout():
	update()
	
	set_process(false)
	
	$Area2D.input_pickable = false

func _on_NightEnd_timeout():
	set_process(true)
	
	$Area2D.input_pickable = true

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
	Main.hovered_plants.push_back(self)
	
	Tooltip.text = 'Click and hold to water the plant'

func _on_Area2D_mouse_exited():
	Main.hovered_plants.erase(self)
	
	if Main.hovered_plants.empty():
		Tooltip.text = 'Click and hold to plant a seed'

func _draw():
	if !Main.hovered_plants.empty() && Main.hovered_plants[0] == self && $Area2D.input_pickable:
		draw_rect(Rect2(-82, -52, 164, 10), Color.blue, false, 4)
		draw_rect(Rect2(-80, -50, 160 * humidity, 6), Color.blue)
