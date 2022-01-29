extends Area2D

export var speed = 8000
export var distance = 1200

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = position.y


func _physics_process(delta):
	move_local_x(speed * delta)
	z_index = position.y
	distance -= speed * delta
	if distance < 0:
		queue_free()



func _on_Bullet_body_entered(body):
	if body.has_method("is_enemy") and body.is_enemy():
		body.health -= 5
		if body.health <= 0:
			body.die()
	queue_free()

func daychange(is_night):
	queue_free()
