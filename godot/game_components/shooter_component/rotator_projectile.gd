extends Sprite2D

@export var speed = 750
@export var facing_right = true
@onready var cpu_particles_2d = $CPUParticles2D

func _physics_process(delta):
	if facing_right:
		position += transform.x * speed * delta
	else:
		position -= transform.x * speed * delta

func _on_timer_timeout():
	queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("ExitDoor"):
		emit_butterfly_particles()
		call_deferred("queue_free")
		print("door hit")
		area.get_parent().hit_door()


func _on_area_2d_body_entered(body):
	if body.is_in_group("environment"):
		emit_butterfly_particles()
		call_deferred("queue_free")
	if body.is_in_group("Player"):
		GameManager.player_projectile_vertical_hit.emit(global_position.x)
		emit_butterfly_particles(false)
	if body.is_in_group("turret"):
		call_deferred("queue_free")
	if body.is_in_group("only_movable"):
		call_deferred("queue_free")

func emit_butterfly_particles(destroy = true):
	if (destroy):
		remove_child(cpu_particles_2d)
		get_parent().add_child(cpu_particles_2d)
	cpu_particles_2d.position = position
	cpu_particles_2d.emitting = true
