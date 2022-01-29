extends KinematicBody2D


export var day_speed = 250
export var night_speed = 750
export var max_cooldown = 0.5
var cooldown = 0
var recoil_dir = Vector2(0, 0)
var recoil = 0
var waggle_time = 0

const Bullet = preload("res://scenes/Bullet.tscn")
const MuzzleFlash = preload("res://scenes/MuzzleFlash.tscn")


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
	$Shotgun/Bang.play()
	var flash = MuzzleFlash.instance()
	flash.global_transform = $Shotgun/Muzzle.global_transform
	get_node("/root").add_child(flash)
	recoil_dir = Vector2(-5000, 0).rotated($Shotgun/Muzzle.global_rotation)
	recoil = 0.2

func _physics_process(delta):
	var is_night = get_node("/root/Main/DayNight").is_night()
	var inp = Vector2(
		int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")),
		int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	)
	if inp.length():
		waggle_time += delta
	else:
		waggle_time = 0
	$Body.rotation = sin(waggle_time * (10 + int(is_night) * 10))/(10 - int(is_night) * 5)
	
	recoil -= delta
	
	var vel = inp.normalized()
	if is_night:
		vel *= night_speed
	else:
		vel *= day_speed
	if recoil > 0:
		vel += recoil_dir * recoil
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
	$Shotgun.visible = is_night


