extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	limit_right = get_node("/root/Main/RightEdge").position.x
	limit_bottom = get_node("/root/Main/BottomEdge").position.y
	
	get_viewport().connect('size_changed', self, 'change_zoom')
	change_zoom()
	

func change_zoom():
	var ratio = Vector2(2049, 2238.75) / OS.window_size
	
	zoom = min(min(ratio.x, ratio.y), 1.5) * Vector2.ONE

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
