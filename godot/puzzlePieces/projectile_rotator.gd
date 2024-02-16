extends StaticBody2D
@onready var marker_2d = $Marker2D
@export var Bullet : PackedScene
@onready var timer = $Timer

func _on_area_2d_area_entered(area):
	call_deferred("shoot")

func shoot():
	
	if timer.time_left <= 0.0:
		var b = Bullet.instantiate()
		marker_2d.add_child(b)
		timer.start()
		b.transform = marker_2d.transform
	#TODO descomentar cuando no haga falta cambiar el tamaño de la bala
		b.scale = Vector2(0.2,0.2)
