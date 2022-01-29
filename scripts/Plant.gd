extends Node2D

var health = 1
var new = true
var watered = false
var color = Color.blue
var colliding_bunnies = 0

onready var Main = get_node("/root/Main")
onready var Tooltip = Main.get_node('CanvasLayer/Tooltip')

func daychange(is_night):
	if is_night:
		if new:
			new = false
			
			$Sprite.texture = preload('res://assets/night_plant_growing.png')
		else:
			$Sprite.texture = preload('res://assets/night_plant_grown.png')
			
		$Area2D.input_pickable = false
		$Light.visible = true
		
		color = Color.red
	elif !new:
		$Sprite.texture = preload('res://assets/day_plant_grown.png')
		$Area2D.input_pickable = true
		$Light.visible = false
		
		color = Color.blue

func _process(delta):
	if $Area2D.input_pickable:
		if watered:
			health = min(health + delta / 2, 1)
		elif new:
			health = max(health - delta / 20, 0)
	else:
		health -= delta / 10 * colliding_bunnies
		
		if health < 0:
			_on_Area2D_mouse_exited()
			queue_free()
	
	update()

func _on_Area2D_body_entered(body):
	colliding_bunnies += 1

func _on_Area2D_body_exited(body):
	colliding_bunnies -= 1

func _on_Area2D_mouse_entered():
	Main.hovered_plants.push_back(self)
	
	Tooltip.text = 'Click and hold to %s the plant' % ('water' if new else 'harvest')

func _on_Area2D_mouse_exited():
	Main.hovered_plants.erase(self)
	
	if Main.hovered_plants.empty():
		Tooltip.text = 'Click and hold to plant a seed'

func _draw():
	var active = !Main.hovered_plants.empty() and Main.hovered_plants[0] == self
	
	draw_rect(Rect2(-82, 18, 164, 16), Color.white if active else color, false, 4)
	draw_rect(Rect2(-80, 20, 160 * health, 12), color)
