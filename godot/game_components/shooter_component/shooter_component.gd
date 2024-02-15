extends Marker2D

@export var Bullet : PackedScene
@export var facing_right = true

func _on_timer_timeout():
	shoot()

func shoot():
	var b = Bullet.instantiate()
	add_child(b)
	b.facing_right = facing_right
	b.transform = transform


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		GameManager.player_projectile_hit.emit()
