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
	#TODO descomentar cuando no haga falta cambiar el tamaño de la bala
	b.scale = Vector2(0.2,0.2)
