extends KinematicBody2D


enum Status {IDLE, MOVE}

var status = Status.IDLE
var direction = Vector2(0, 0)
var speed = 250
var night_speed = 750
var evil = false
var health = 10
var edge_distance = 100


const DeadBunny = preload("res://scenes/DeadBunny.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = position.y
	
	daychange(get_node("/root/Main/DayNight").is_night())

func _on_RethinkTimer_timeout():
	if status == Status.IDLE:
		status = Status.MOVE
	else:
		status = Status.IDLE
	rethink()

func onbeat():
	status = Status.MOVE
	rethink()

func rethink():
	if evil:
		if status == Status.MOVE:
			move_evil()
		else:
			idle_evil()
		
	else:
		if status == Status.MOVE:
			move_peace()
		elif avoid_edge():
			# bunny is near/beyond an edge
			move_peace()
		else:
			idle_peace()

func idle_peace():
	status = Status.IDLE
	direction = Vector2(0, 0)
	$RethinkTimer.start(3+randf()*2)

func move_peace():
	status = Status.MOVE
	direction = Vector2(1, 0).rotated(randf() * 2 * PI)
	avoid_edge()
	$RethinkTimer.start(0.25)

func idle_evil():
	status = Status.IDLE
	direction = Vector2(0, 0)
	#$RethinkTimer.start(0.25)
	$RethinkTimer.stop()

func move_evil():
	status = Status.MOVE
	direction = get_node("/root/Main/Player").position - position
	for plant in get_tree().get_nodes_in_group("plants"):
		var plant_direction = plant.position - position
		if plant_direction.length_squared() < direction.length_squared():
			direction = plant_direction
	$RethinkTimer.start(0.25)



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


func die(direction):
	var corpse = DeadBunny.instance()
	corpse.vel = 0.2
	corpse.dir = Vector2(10, 0).rotated(direction)
	corpse.global_transform = global_transform
	corpse.scale.x = $Body.scale.x
	corpse.z_index = z_index
	get_parent().add_child(corpse)
	queue_free()



func _physics_process(delta):
	
	if status == Status.MOVE:
		
		if direction.x > 0:
			$Body.scale.x = -1
		elif direction.x < 0:
			$Body.scale.x = 1
		var vel = direction.normalized()
		if evil:
			vel *= night_speed
		else:
			vel *= speed
		move_and_slide(vel)
		z_index = position.y
		
		

func daychange(is_night):
	evil = is_night
	$Body/DaySprite.visible = not is_night
	$Body/NightSprite.visible = is_night
	$DayShape.disabled = is_night
	$NightShape.disabled = not is_night
	if not is_night:
		health = 10
	status = Status.IDLE
	rethink()
	

