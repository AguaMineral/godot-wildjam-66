extends Node2D

@onready var witch_appear_sound = $WitchAppearSound

func _ready():
	MusicAutoload.stop()
	Dialogic.signal_event.connect(_on_dialogic_signal)
	await get_tree().create_timer(1.5).timeout
	GameManager.play_dialog("dialog_witch_puzzle6_0")

func _on_dialogic_signal(argument:String):
	if argument == "dialog_ended":
		witch_appear_sound.play()

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		GameManager.fade_to_next_scene_by_path("res://scenes/Levels/level_room_3.tscn")
