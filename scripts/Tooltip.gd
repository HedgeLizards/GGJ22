extends Label

enum { IDLE, PLANTING, WATERING, HARVESTING }

var action = IDLE
var plant
var animation = 0

onready var Player = $'../Player'
onready var Main = get_parent()
onready var viewport = get_viewport()

func update_position_and_visibility(mouse_position):
	if mouse_position.distance_to(Player.position) < 200:
		rect_position = mouse_position + Vector2(-rect_size.x / 2, 20)
		
		Input.set_default_cursor_shape(CURSOR_POINTING_HAND)
		
		visible = true
	else:
		Input.set_default_cursor_shape(CURSOR_ARROW)
		
		visible = false

func _input(event):
	if event is InputEventMouseMotion && action == IDLE:
		update_position_and_visibility(event.position)
	elif visible && event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		if event.pressed:
			percent_visible = 0
			
			if Main.hovered_plant == null:
				$Tween.interpolate_property(self, 'animation', 0, 1, 2)
				$Tween.start()
				
				action = PLANTING
			elif Main.hovered_plant.fullgrown:
				action = HARVESTING
			else:
				action = WATERING
				
				plant = Main.hovered_plant
				plant.watered = true
		else:
			percent_visible = 1
			
			if action != IDLE:
				$Tween.remove_all()
				
				_on_Tween_tween_completed(null, null)
				
				action = IDLE

func _on_Tween_tween_step(object, key, elapsed, value):
	update()

func _on_Tween_tween_completed(object, key):
	match action:
		WATERING:
			plant.watered = false
		PLANTING:
			action = IDLE
			
			update_position_and_visibility(viewport.get_mouse_position())
			update()

func _draw():
	if action == PLANTING:
		draw_rect(Rect2(rect_size.x / 2 - 82, -2, 164, 10), Color.green, false, 4)
		draw_rect(Rect2(rect_size.x / 2 - 80, 0, 160 * animation, 6), Color.green)
