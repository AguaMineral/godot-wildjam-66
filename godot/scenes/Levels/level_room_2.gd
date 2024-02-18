extends Node2D
@onready var animation_player_witch = $Witch/AnimationPlayer
@onready var animation_player = $AnimationPlayer
@onready var witch_appear_sound = $WitchAppearSound

func _ready():
	MusicAutoload.stop()
	Dialogic.signal_event.connect(_on_dialogic_signal)
	animation_player.play("fog_fade_in")
	animation_player.play("witch_fade_in")
	await get_tree().create_timer(1.5).timeout
	GameManager.play_dialog("dialog_witch_room2_0")

func _on_dialogic_signal(argument:String):
	if argument == "dialog_ended":
		animation_player_witch.play("witch_fade_out")
		witch_appear_sound.play()

func _on_animation_player_animation_finished(anim_name):
	GameManager.fade_to_next_scene_by_path("res://scenes/Levels/puzzle_6.tscn")
