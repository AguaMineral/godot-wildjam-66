extends Node2D

@export var next_scene:PackedScene
@onready var audio_stream_player = $AudioStreamPlayer
@onready var audio_stream_player_2 = $AudioStreamPlayer2
@export var touchable = true

var life := 20

func _process(delta):
	if life <= 0:
		if audio_stream_player_2.playing == false and life > -1:
			audio_stream_player_2.play()
		

func hit_door():
	if audio_stream_player_2.playing == false and life >= 0:
		audio_stream_player.play()
	life -= 1


func _on_audio_stream_player_2_finished():
	if not touchable:
		GameManager.fade_to_next_scene_packed(next_scene)

func escape() -> bool:
	if touchable and life <= 0:
		GameManager.fade_to_next_scene_packed(next_scene)
		return true
	return false
