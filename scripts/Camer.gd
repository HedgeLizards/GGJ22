extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	limit_right = get_node("/root/Main/RightEdge").position.x
	limit_bottom = get_node("/root/Main/BottomEdge").position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
