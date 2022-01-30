extends KinematicBody2D


export var day_speed = 250
export var night_speed = 750
export var max_cooldown = 0.5
var cooldown = 0
var recoil_dir = Vector2(0, 0)
var recoil = 0
var waggle_time = 0
var max_health = 1
var player_health = max_health
var collidingbunnies = 0

const Bullet = preload("res://scenes/Bullet.tscn")
const MuzzleFlash = preload("res://scenes/MuzzleFlash.tscn")

func _ready():
	z_index = position.y

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
	$Shotgun/Sprite.visible = false
	$Shotgun/FireSprite.visible = true
	$Shotgun/FireTimer.start()
	$Camera.shake(160)

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
	
	if collidingbunnies > 0 and is_night:
		player_health -= delta * collidingbunnies * 0.1
	elif is_night:
		player_health += delta * 0.01
	else:
		player_health += delta * 0.5
	
	if player_health < 0:
		get_tree().reload_current_scene()
	player_health = min(player_health, max_health)
	
	if inp.x > 0:
		$Body.scale.x = abs($Body.scale.x)
	elif inp.x < 0:
		$Body.scale.x = -abs($Body.scale.x)
	var vel = inp.normalized()
	if is_night:
		vel *= night_speed
	else:
		vel *= day_speed
	if recoil > 0:
		vel += recoil_dir * recoil
	self.move_and_slide(vel)
	z_index = position.y
	
	var mouse_position = get_global_mouse_position()
	$Shotgun.look_at(mouse_position)
	if mouse_position.x < $Shotgun.global_position.x:
		$Shotgun/Sprite.scale.y = -abs($Shotgun/Sprite.scale.y)
	else:
		$Shotgun/Sprite.scale.y = abs($Shotgun/Sprite.scale.y)
	
	if Input.is_action_pressed("shoot") and is_night and cooldown <= 0:
		shoot()
		cooldown = max_cooldown
	cooldown -= delta


func daychange(is_night):
	$Body/Day.visible = not is_night
	$Body/Night.visible = is_night
	$Shotgun.visible = is_night




func _on_FireTimer_timeout():
	$Shotgun/Sprite.visible = true
	$Shotgun/FireSprite.visible = false
	
func _on_Hitbox_body_entered(body):
	collidingbunnies += 1
	

func _on_Hitbox_body_exited(body):
	collidingbunnies -= 1
