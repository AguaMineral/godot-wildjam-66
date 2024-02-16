extends StaticBody2D
@onready var marker_2d = $Marker2D
@export var Bullet : PackedScene
@onready var timer = $Timer
@onready var bullet_detection_area = $BulletDetectionArea

func _on_area_2d_area_entered(area):
	if !area.is_in_group("rotator_projectile"):
		call_deferred("shoot")
	
	var area_parent = area.get_parent().get_parent()
	if area_parent != marker_2d:
		area.get_parent().queue_free()

func shoot():
	
	if timer.time_left <= 0.0:
		var b = Bullet.instantiate()
		marker_2d.add_child(b)
		timer.start()
		b.transform = marker_2d.transform
	#TODO descomentar cuando no haga falta cambiar el tamaño de la bala
		b.scale = Vector2(0.2,0.2)
