extends Control

func _ready():
	await get_tree().create_timer(5).timeout
	get_tree().quit()
