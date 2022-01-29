extends Node2D

var stage = 0
var health = 1
var watered = false
var color = Color.blue

onready var Main = get_parent()
onready var Tooltip = Main.get_node('Tooltip')

func _ready():
	var DayNight = Main.get_node('DayNight')
	
	DayNight.get_node('DayEnd').connect('timeout', self, '_on_DayEnd_timeout')
	DayNight.get_node('NightEnd').connect('timeout', self, '_on_NightEnd_timeout')

func _on_DayEnd_timeout():
	set_process(false)
	
	update()
	
	color = Color.red
	
	$Area2D.input_pickable = false

func _on_NightEnd_timeout():
	if (stage < 2):
		stage += 1
		
		$Sprite.scale.y = [1, 1.5, 2][stage]
		$Sprite.position.y = -$Sprite.scale.y * $Sprite.texture.get_height() / 2
	
	if (stage < 2):
		set_process(true)
	else:
		update()
	
	color = Color.blue
	
	$Area2D.input_pickable = true

func _process(delta):
	if watered:
		health = min(health + delta / 2, 1)
	else:
		health -= delta / 20
		
		if health <= 0:
			_on_Area2D_mouse_exited()
			
			queue_free()
	
	update()

func _on_Area2D_mouse_entered():
	Main.hovered_plants.push_back(self)
	
	Tooltip.text = 'Click and hold to %s the plant' % ('water' if stage < 2 else 'harvest')

func _on_Area2D_mouse_exited():
	Main.hovered_plants.erase(self)
	
	if Main.hovered_plants.empty():
		Tooltip.text = 'Click and hold to plant a seed'

func _draw():
	if !$Area2D.input_pickable || (!Main.hovered_plants.empty() && Main.hovered_plants[0] == self):
		draw_rect(Rect2(-82, 12, 164, 10), color, false, 4)
		draw_rect(Rect2(-80, 14, 160 * health, 6), color)
