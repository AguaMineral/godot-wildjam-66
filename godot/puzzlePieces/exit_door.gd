extends Node2D

@export var next_scene:PackedScene

var life := 10

func _process(delta):
	if life <= 0:
		get_tree().change_scene_to_packed(next_scene)

func hit_door():
	life -= 1
