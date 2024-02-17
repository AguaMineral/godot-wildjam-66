extends Node2D
@onready var part_witch_appear_timer = $ParticleWitchAppearTimer
@onready var witch = $Witch
@onready var cpu_particles_2d = $CPUParticles2D
@onready var witch_appear_timer = $WitchAppearTimer
@onready var point_light_2d = $Witch/PointLight2D
@onready var witch_appear_sound = $WitchAppearSound
@onready var color_rect = $UI/ParallaxLayer/ParallaxLayer/ColorRect

@onready var animation_player_player = $Player/AnimationPlayer
@onready var animation_player_witch = $Witch/AnimationPlayer
@onready var animation_player = $AnimationPlayer

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	color_rect.modulate = Color(0, 0.682, 0.988, 0)

func _on_init_scene_timer_timeout():
	if Dialogic.current_timeline != null:
		return
	else:
		Dialogic.start("dialog_test_0")
		get_viewport().set_input_as_handled()

func _on_dialogic_signal(argument:String):
	if argument == "dialog_test_0_ended":
		color_rect.modulate = Color(0, 0.682, 0.988)
		animation_player.play("fog_fade_in")
		part_witch_appear_timer.start()
	if argument == "dialog_witch_room0_0_ended":
		animation_player_witch.play("witch_fade_out")
		if animation_player_player.is_playing():
			animation_player_player.stop()
		animation_player_player.play("player_fade_out")
		witch_appear_sound.play()
		await get_tree().create_timer(5).timeout
		await Fade.fade_out().finished
		get_tree().change_scene_to_file("res://test/test_scene.tscn")
		Fade.fade_in()

func _on_particle_witch_appear_timer_timeout():
	cpu_particles_2d.emitting = true
	witch_appear_sound.play()
	witch_appear_timer.start()

func _on_witch_appear_timer_timeout():
	animation_player.play("witch_fade_in")

