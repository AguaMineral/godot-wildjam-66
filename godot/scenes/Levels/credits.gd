extends Node

func _ready():
	await get_tree().create_timer(7).timeout
	GameManager.fade_and_quit()
