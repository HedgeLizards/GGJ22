extends Node2D

enum Stage {Seed = 0, Growing = 1, Grown = 2}
export (Stage) var stage = Stage.Seed
var health = 0.1
var extrahealth = 0
var watered = false
var colliding_bunnies = 0

onready var Main = get_node('/root/Main')
onready var Tooltip = Main.get_node('HUD/Tooltip')

func _ready():
	z_index = position.y
	if stage != Stage.Seed:
		health = 1

func daychange(is_night):
	if is_night and stage <= Stage.Seed:
		stage = Stage.Growing
	elif stage == Stage.Growing:
		stage = Stage.Grown
	
	if is_night:
		if stage == Stage.Growing:
			$Sprite.texture = preload('res://assets/night_flower_growing.png')
			$Light.scale.x = 0.6
			$Light.scale.y = 0.6
		elif stage == Stage.Grown:
			$Sprite.texture = preload('res://assets/night_flower_grown.png')
			$Light.scale.x = 1
			$Light.scale.y = 1
		
		$Area2D.input_pickable = false
		$Light.visible = true
	else:
		if stage == Stage.Grown:
			$Sprite.texture = preload('res://assets/day_flower_grown_.png')
		
		$Area2D.input_pickable = true
		$Light.visible = false
	

func _process(delta):
	if $Area2D.input_pickable:
		if watered:
			health = min(health + delta * 0.5, 1)
			extrahealth = 3
		elif stage == Stage.Seed:
			if extrahealth > 0:
				extrahealth -= delta
			else:
				health = max(health - delta * 0.02, 0.1)
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
	
	Tooltip.text = 'Click and hold to %s the plant' % ('water' if stage == Stage.Seed else 'harvest')

func _on_Area2D_mouse_exited():
	Main.hovered_plants.erase(self)
	
	if Main.hovered_plants.empty():
		Tooltip.text = 'Click and hold to plant a seed'

func _draw():
	var color_end = Color.blue if stage == Stage.Seed else Color.red
	var color_start

	if $Area2D.input_pickable && (Main.hovered_plants.empty() || Main.hovered_plants[0] != self):
		color_end.a = 0.4
		
		color_start = color_end
	else:
		color_start = color_end
		
		color_start.r /= 2
		color_start.g /= 2
		color_start.b /= 2
	
	draw_rect(Rect2(-82, 43, 164, 16), color_start, false, 4)
	
	draw_polygon([
		Vector2(-80, 45),
		Vector2(-80 + 160 * health, 45),
		Vector2(-80 + 160 * health, 45 + 12),
		Vector2(-80, 45 + 12)
	], [
		color_start,
		color_end,
		color_end,
		color_start
	])
