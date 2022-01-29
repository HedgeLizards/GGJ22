extends KinematicBody2D


export var day_speed = 250
export var night_speed = 750
export var max_cooldown = 0.5
var cooldown = 0


const Bullet = preload("res://scenes/Bullet.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



#func _input(event):
	#if event.is_action_pressed("shoot") and get_node("/root/Main/DayNight").is_night():
		#shoot()


func shoot():
	for i in range(-1, 2):
		var bullet = Bullet.instance()
		bullet.global_transform = $Shotgun/Muzzle.global_transform
		bullet.rotation += i * PI * 0.04
		get_node("/root").add_child(bullet)

func _physics_process(delta):
	var is_night = get_node("/root/Main/DayNight").is_night()
	var inp = Vector2(
		int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")),
		int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	)
	
	var vel = inp.normalized()
	if is_night:
		vel *= night_speed
	else:
		vel *= day_speed
	self.move_and_slide(vel)
	
	var mouse_position = get_global_mouse_position()
	$Shotgun.look_at(mouse_position)
	
	if Input.is_action_pressed("shoot") and is_night and cooldown <= 0:
		shoot()
		cooldown = max_cooldown
	cooldown -= delta


func daychange(is_night):
	$Body/Day.visible = not is_night
	$Body/Night.visible = is_night


