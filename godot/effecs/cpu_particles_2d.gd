extends CPUParticles2D

@onready var point_light_2d = $PointLight2D

func _on_finished():
	queue_free()

func _process(delta):
	if emitting == false:
		point_light_2d.visible = false
	else:
		point_light_2d.visible = true
