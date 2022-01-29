extends KinematicBody2D


enum Status {IDLE, MOVE}

var status = Status.IDLE
var direction = Vector2(0, 0)
var speed = 200
var evil = false
var health = 10


const DeadBunny = preload("res://scenes/DeadBunny.tscn")

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


func is_enemy():
	return true


func die():
	var corpse = DeadBunny.instance()
	corpse.global_transform = global_transform
	get_parent().add_child(corpse)
	queue_free()



func _physics_process(delta):
	#var is_night = get_node("/root/Main/DayNight").is_night()
	#if not evil and is_night:
		#turn_evil()
	#elif evil and not is_night:
		#turn_peaceful()
	
	if not evil and status == Status.MOVE:
		move_and_slide(direction * speed)
	
	if evil:
		direction = (get_node("/root/Main/Player").position - position).normalized()
		move_and_slide(direction * speed)
		

func daychange(is_night):
	evil = is_night
	$DaySprite.visible = not is_night
	$NightSprite.visible = is_night
	$DayShape.disabled = is_night
	$NightShape.disabled = not is_night
	if not is_night:
		health = 10
	

