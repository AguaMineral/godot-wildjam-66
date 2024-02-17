extends Sprite2D

@export var speed = 750
@export var facing_right = true

func _physics_process(delta):
	if facing_right:
		position += transform.x * speed * delta
	else:
		position -= transform.x * speed * delta

func _on_timer_timeout():
	queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("ExitDoor"):
		queue_free()
		print("door hit")
		area.get_parent().hit_door()


func _on_area_2d_body_entered(body):
	if body.is_in_group("environment"):
		queue_free()
	if body.is_in_group("Player"):
		GameManager.player_projectile_vertical_hit.emit(global_position.x)
