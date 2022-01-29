extends KinematicBody2D


enum Status {IDLE, MOVE}

var status = Status.IDLE
var direction = Vector2(0, 0)
var speed = 200
var evil = false
var health = 10
var edge_distance = 150


const DeadBunny = preload("res://scenes/DeadBunny.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	daychange(get_node("/root/Main/DayNight").is_night())

func _on_RethinkTimer_timeout():
	rethink()

func rethink():
	if status == Status.MOVE and not avoid_edge():
		status = Status.IDLE
		direction = Vector2(0, 0)
	else:
		status = Status.MOVE
		direction = Vector2(1, 0).rotated(randf() * 2 * PI)
		avoid_edge()
	$RethinkTimer.wait_time = 0.5+randf()


func avoid_edge():
	var Main = get_node("/root/Main")
	if position.y < Main.get_node("TopEdge").position.y + edge_distance:
		direction.y += 2
		return true
	if position.y > Main.get_node("BottomEdge").position.y - edge_distance:
		direction.y -= 2
		return true
	if position.x < Main.get_node("LeftEdge").position.x + edge_distance:
		direction.x += 2
		return true
	if position.x > Main.get_node("RightEdge").position.x - edge_distance:
		direction.x -= 2
		return true
	return false

func is_enemy():
	return true


func die():
	var corpse = DeadBunny.instance()
	corpse.global_transform = global_transform
	get_parent().add_child(corpse)
	queue_free()



func _physics_process(delta):
	
	if not evil and status == Status.MOVE:
		move_and_slide(direction.normalized() * speed)
	
	if evil:
		direction = get_node("/root/Main/Player").position - position
		move_and_slide(direction.normalized() * speed)
		

func daychange(is_night):
	evil = is_night
	$DaySprite.visible = not is_night
	$NightSprite.visible = is_night
	$DayShape.disabled = is_night
	$NightShape.disabled = not is_night
	if not is_night:
		health = 10
	rethink()
	

