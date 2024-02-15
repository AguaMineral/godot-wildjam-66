extends Sprite2D

@export var speed = 1500
@export var facing_right = true

func _physics_process(delta):
	if facing_right:
		position += transform.x * speed * delta
	else:
		position -= transform.x * speed * delta

func _on_timer_timeout():
	queue_free()
