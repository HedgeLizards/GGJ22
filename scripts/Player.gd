extends KinematicBody2D


export var speed = 250


const Bullet = preload("res://scenes/Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()


func shoot():
	var bullet = Bullet.instance()
	
	bullet.global_transform = $Body.global_transform
	get_node("/root").add_child(bullet)

func _physics_process(delta):
	var inp = Vector2(
		int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")),
		int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	)
	
	var vel = inp.normalized() * speed
	self.move_and_slide(vel)
	
	var mouse_position = get_global_mouse_position()
	$Body.look_at(mouse_position)
	
	
