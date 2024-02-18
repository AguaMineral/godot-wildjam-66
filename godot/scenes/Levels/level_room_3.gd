extends Node2D

@onready var animation_player = $AnimationPlayer

func _ready():
	MusicAutoload.stop()
	Dialogic.signal_event.connect(_on_dialogic_signal)
	await get_tree().create_timer(1.5).timeout
	GameManager.play_dialog("dialog_level3_0")

func _on_dialogic_signal(argument:String):
	if argument == "dialog_ended":
		GameManager.fade_to_next_scene_by_path("res://scenes/Levels/credits.tscn")
