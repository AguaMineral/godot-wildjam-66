extends Node

signal player_projectile_hit(y_coord : float)
signal player_projectile_vertical_hit(x_coord : float)

func fade_to_next_scene_by_path(scene_path:String):
	await Fade.fade_out().finished
	get_tree().change_scene_to_file(scene_path)
	Fade.fade_in()

func fade_to_next_scene_packed(packed_scene:PackedScene):
	await Fade.fade_out().finished
	get_tree().change_scene_to_packed(packed_scene)
	Fade.fade_in()

func fade_and_quit():
	await Fade.fade_out().finished
	get_tree().quit()

func play_dialog(timeline:String):
	if Dialogic.current_timeline != null:
		print("Error, no existe la timeline " + timeline)
		return
	else:
		Dialogic.start(timeline)
		get_viewport().set_input_as_handled()
