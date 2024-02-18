extends Node2D

func _ready():
	MusicAutoload.play()

func _on_first_dialog_timer_timeout():
	GameManager.play_dialog("dialog_puzzle0_0")
