extends Label

const Plant = preload('res://scenes/Plant.tscn')

enum { IDLE, PLANTING, WATERING, HARVESTING }

var action = IDLE
var active_plant
var animation = 0
var camera_offset
var mouse_position_global
var mouse_position
var can_plant = true

onready var Main = get_parent().get_parent()
onready var Player = Main.get_node('Player')
onready var Pointer = Main.get_node('Pointer')
onready var Camer = Player.get_node('Camera')

func daychange(is_night):
	if is_night:
		release_action()
		
		Input.set_default_cursor_shape(CURSOR_ARROW)
		
		visible = false
	
	set_process(not is_night)
	set_process_input(not is_night)

func _process(delta):
	
	if Main.hovered_plants.empty() and Pointer.get_overlapping_bodies().size() > 0:
		can_plant = false
	else:
		can_plant = true
	if action == IDLE:
		update_position_and_visibility()
	else:
		var current_camera_offset = Player.get_viewport().canvas_transform.origin
		
		if current_camera_offset != camera_offset:
			rect_position += current_camera_offset - camera_offset
			
			camera_offset = current_camera_offset

func update_position_and_visibility():
	camera_offset = Player.get_viewport().canvas_transform.origin
	
	mouse_position_global = get_global_mouse_position()
	mouse_position = (mouse_position_global - camera_offset) * Camer.zoom
	
	if mouse_position.distance_to(Player.position) < 500 && !(mouse_position.y < 750 && Main.hovered_plants.empty()) and can_plant:
		rect_position = mouse_position_global - Vector2(rect_size.x / 2, rect_size.y + 20)
		
		Input.set_default_cursor_shape(CURSOR_POINTING_HAND)
		
		visible = true
	else:
		Input.set_default_cursor_shape(CURSOR_ARROW)
		
		visible = false

func _input(event):
	if visible && event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		
		if event.pressed:
			percent_visible = 0
			
			#visible = true
			if Main.hovered_plants.empty():
				if Pointer.get_overlapping_bodies().size() == 0:
					action = PLANTING
					
					$Tween.interpolate_property(self, 'animation', 0, 1, 1)
					$Tween.start()
			elif Main.hovered_plants[0].stage == 0:
				action = WATERING
				
				active_plant = Main.hovered_plants[0]
				active_plant.watered = true
			else:
				action = HARVESTING
				
				active_plant = Main.hovered_plants[0]
				
				$Tween.interpolate_property(self, 'animation', 0, 1, 1)
				$Tween.start()
		else:
			release_action()

func release_action():
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
	if action == WATERING:
		active_plant.watered = false
	else:
		match action:
			PLANTING:
				var new_plant = Plant.instance()
				
				new_plant.position = mouse_position
				
				Main.add_child(new_plant)
			HARVESTING:
				active_plant._on_Area2D_mouse_exited()
				active_plant.queue_free()
				
				Main.plants_harvested += 1
		
		action = IDLE
		
		update_position_and_visibility()
		update()

func _draw():
	var color_end
	
	match action:
		PLANTING:
			color_end = Color.green
		HARVESTING:
			color_end = Color.yellow
		_:
			return
		
	var color_start = color_end
	
	color_start.r /= 2
	color_start.g /= 2
	color_start.b /= 2
	
	draw_rect(Rect2(rect_size.x / 2 - 62, rect_size.y - 12, 124, 10), color_start, false, 4)
	
	draw_polygon([
		Vector2(rect_size.x / 2 - 60, rect_size.y - 10),
		Vector2(rect_size.x / 2 - 60 + 120 * animation, rect_size.y - 10),
		Vector2(rect_size.x / 2 - 60 + 120 * animation, rect_size.y - 10 + 6),
		Vector2(rect_size.x / 2 - 60, rect_size.y - 10 + 6)
	], [
		color_start,
		color_end,
		color_end,
		color_start
	])
