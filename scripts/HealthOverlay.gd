extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var time = 0
var health_ratio = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	draw_health_overlay()

func _process(delta):
	time += delta
	health_ratio = cos(time) / 2 + 0.5
	draw_health_overlay()


func draw_health_overlay():
	var size = get_viewport().size
	$HurtTexture.rect_size = (1 + 2*health_ratio) * size
	$HurtTexture.rect_position = -size * health_ratio
