extends Label

var animation = 0

onready var Player = $'../Player'
onready var viewport = get_viewport()

func update_position_and_visibility(mouse_position):
	if mouse_position.distance_to(Player.position) < 200:
		rect_position = mouse_position - Vector2(rect_size.x / 2, rect_size.y + 20)
		
		Input.set_default_cursor_shape(CURSOR_POINTING_HAND)
		
		visible = true
	else:
		Input.set_default_cursor_shape(CURSOR_ARROW)
		
		visible = false

func _input(event):
	if event is InputEventMouseMotion && animation == 0:
		update_position_and_visibility(event.position)
	elif event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		if event.pressed:
			visible_characters = 0
			
			$Tween.interpolate_property(self, 'animation', null, 1, 2)
			$Tween.start()
		else:
			visible_characters = -1
			
			if animation > 0:
				$Tween.remove_all()
				
				_on_Tween_tween_completed(null, null)

func _on_Tween_tween_step(object, key, elapsed, value):
	update()

func _on_Tween_tween_completed(object, key):
	animation = 0
	
	update_position_and_visibility(viewport.get_mouse_position())
	update()

func _draw():
	draw_rect(Rect2(rect_size.x / 2 - 80, 0, 160 * animation, rect_size.y), Color.green)
