extends Label

const Plant = preload('res://scenes/Plant.tscn')

enum { IDLE, PLANTING, WATERING, HARVESTING }

var action = IDLE
var active_plant
var animation = 0

onready var viewport = get_viewport()
onready var Main = get_parent()
onready var Player = Main.get_node('Player')

func _process(delta):
	if action == IDLE:
		update_position_and_visibility()

func update_position_and_visibility():
	var mouse_position = viewport.get_mouse_position()
	
	if mouse_position.distance_to(Player.position) < 200:
		rect_position = mouse_position + Vector2(-rect_size.x / 2, 20)
		
		Input.set_default_cursor_shape(CURSOR_POINTING_HAND)
		
		visible = true
	else:
		Input.set_default_cursor_shape(CURSOR_ARROW)
		
		visible = false

func _input(event):
	if visible && event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		if event.pressed:
			percent_visible = 0
			
			if Main.hovered_plants.empty():
				$Tween.interpolate_property(self, 'animation', 0, 1, 2)
				$Tween.start()
				
				action = PLANTING
			elif Main.hovered_plants.front().fullgrown:
				action = HARVESTING
			else:
				action = WATERING
				
				active_plant = Main.hovered_plants.front()
				active_plant.watered = true
		else:
			percent_visible = 1
			
			if action != IDLE:
				$Tween.remove_all()
				
				match action:
					WATERING:
						active_plant.watered = false
					PLANTING:
						update_position_and_visibility()
						update()
				
				action = IDLE

func _on_Tween_tween_step(object, key, elapsed, value):
	update()

func _on_Tween_tween_completed(object, key):
	match action:
		WATERING:
			active_plant.watered = false
		PLANTING:
			update_position_and_visibility()
			update()
			
			action = IDLE
			
			var new_plant = Plant.instance()
			
			new_plant.position = rect_position - Vector2(-rect_size.x / 2, 20)
			
			Main.add_child(new_plant)

func _draw():
	if action == PLANTING:
		draw_rect(Rect2(rect_size.x / 2 - 82, rect_size.y - 12, 164, 10), Color.green, false, 4)
		draw_rect(Rect2(rect_size.x / 2 - 80, rect_size.y - 10, 160 * animation, 6), Color.green)
