extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	limit_right = get_node("/root/Main/RightEdge").position.x
	limit_bottom = get_node("/root/Main/BottomEdge").position.y
	
	get_viewport().connect('size_changed', self, 'change_zoom')
	change_zoom()
	

func change_zoom():
	var ratio = Vector2(2049, 2238.75) / OS.window_size
	
	zoom = min(min(ratio.x, ratio.y), 1.5) * Vector2.ONE

var shake_offset = Vector2.ZERO
var shake_intensity
	
func _process(delta):
	shake_offset.x = (randf() * 2 - 1) * (shake_intensity * $Timer.time_left)
	shake_offset.y = (randf() * 2 - 1) * (shake_intensity * $Timer.time_left)
	
	offset = shake_offset

func shake(intensity):
	set_process(true)
	
	shake_intensity = intensity
	
	$Timer.start()

func _on_Timer_timeout():
	set_process(false)
	
	shake_offset.x = 0
	shake_offset.y = 0
	
	offset = shake_offset
