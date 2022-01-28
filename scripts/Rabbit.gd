extends KinematicBody2D


enum Status {IDLE, MOVE}

var status = Status.IDLE
var direction = Vector2(0, 0)
var speed = 200
var evil = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_RethinkTimer_timeout():
	if status == Status.IDLE:
		status = Status.MOVE
		direction = Vector2(1, 0).rotated(randf() * 2 * PI)
	else:
		status = Status.IDLE
	$RethinkTimer.wait_time = 0.5+randf()




func _physics_process(delta):
	var is_night = get_node("/root/Main/DayNight").is_night()
	if not evil and is_night:
		turn_evil()
	elif evil and not is_night:
		turn_peaceful()
	
	if not evil and status == Status.MOVE:
		move_and_slide(direction * speed)
	
	if evil:
		direction = (get_node("/root/Main/Player").position - position).normalized()
		move_and_slide(direction * speed)
		

func turn_evil():
	evil = true
	$Day.visible = false
	$Night.visible = true

func turn_peaceful():
	evil = false
	$Day.visible = true
	$Night.visible = false

