extends Area2D

export var speed = 1600
export var distance = 600

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	move_local_x(speed * delta)
	distance -= speed * delta
	if distance < 0:
		queue_free()



func _on_Bullet_body_entered(body):
	if body.has_method("is_enemy") and body.is_enemy():
		body.health -= 5
		if body.health <= 0:
			body.die()
	queue_free()
