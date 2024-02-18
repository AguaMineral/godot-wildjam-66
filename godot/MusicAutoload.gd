extends Node2D
@onready var audio_stream_player = $AudioStreamPlayer

func play():
	audio_stream_player.play()

func stop():
	if audio_stream_player.playing:
		audio_stream_player.stop()
