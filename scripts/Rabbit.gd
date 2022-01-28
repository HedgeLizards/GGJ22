extends KinematicBody2D


enum Status {IDLE, MOVE}

var status = Status.IDLE
var direction = Vector2(0, 0)
var speed = 200

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
	if status == Status.MOVE:
		move_and_slide(direction * speed)
