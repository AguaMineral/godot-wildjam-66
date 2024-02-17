extends CharacterBody2D

@onready var interact_label = $InteractionComponents/InteractLabel
@onready var knockback_timer = $KnockbackTimer
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D

@onready var audio_stream_player_2d = $AudioStreamPlayer2D

@onready var all_interactions = []

@export var speed = 400  # speed in pixels/sec
var knockback : Vector2 = Vector2(0,0)
var knockbackTween
var in_knockback = false
var disable_input = false
# specify in nodes to load data
# from save game for this node
func load_data(data:Dictionary) -> void:
	print(data.hello) 
	
# specify in nodes to save data
# of this node to the save game
func save_data() -> Dictionary:
	return {
		"hello": "Hello Godot!"
	}

func _ready():
	interact_label.text = ""
	GameManager.player_projectile_hit.connect(_on_player_hit)
	GameManager.player_projectile_vertical_hit.connect(_on_player_vertical_hit)
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _physics_process(delta):
	handle_movement()
	handle_input()

func handle_movement():
	if not disable_input:
		var direction = Vector2.ZERO
		#if (knockback == Vector2.ZERO):
		if(knockback_timer.time_left <= 0.0):
			direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
		if direction == Vector2.ZERO:
			animation_player.play("player_idle")
		
		if direction != Vector2.ZERO:
			if direction.x < 0:
				sprite_2d.flip_h = false
			elif direction.x > 0:
				sprite_2d.flip_h = true
		elif knockback_timer.time_left <= 0.0:
			animation_player.play("player_walking")
		velocity = (direction * speed) + knockback
		knockback = lerp(knockback, Vector2.ZERO, 0.2)
		move_and_slide()

func handle_input():
	if Input.is_action_just_pressed("interact") and not disable_input:
		execute_interaction()
	if Input.is_action_just_pressed("restart_level"):
		get_tree().reload_current_scene()

func _on_interaction_area_area_entered(area):
	all_interactions.insert(0,area)
	update_interactions()


func _on_interaction_area_area_exited(area):
	all_interactions.erase(area)
	update_interactions()

func update_interactions():
	if all_interactions:
		interact_label.text = all_interactions[0].interact_label
	else:
		interact_label.text = ""

func execute_interaction():
	if all_interactions:
		var current_interaction = all_interactions[0]
		match current_interaction.interact_type:
			"print_text": print(current_interaction.interact_value)
			"dialog_test": 
				if Dialogic.current_timeline != null:
					return
				else:
					Dialogic.start("test_timeline")
					get_viewport().set_input_as_handled()
			"move_object":
				if current_interaction.interaction_parent != null:
					if current_interaction.interaction_parent.has_method("move_object"):
						var result = await current_interaction.interaction_parent.move_object()
						if result == 0 and all_interactions.size() > 1:
							current_interaction = all_interactions[1]
							current_interaction.interaction_parent.move_object()
			"dialog_witch_room0_0": 
				if Dialogic.current_timeline != null:
					return
				else:
					Dialogic.start("dialog_witch_room0_0")
					get_viewport().set_input_as_handled()

func _on_player_hit(y_coord : float):
	hit(y_coord)

func _on_player_vertical_hit(x_coord : float):
	hit_vertical(x_coord)

func hit(y_coord : float):
	animation_player.stop()
	animation_player.play("player_boing")
	if y_coord > global_position.y:
		knockback = Vector2.UP * 2000
	elif y_coord < global_position.y:
		knockback = Vector2.DOWN * 2000
	print(knockback)
	knockback_timer.start()
	#knockback = -velocity.normalized() * 2000

func hit_vertical(x_coord : float):
	animation_player.stop()
	animation_player.play("player_boing")
	if x_coord > global_position.x:
		knockback = Vector2.LEFT * 2000
	elif x_coord < global_position.x:
		knockback = Vector2.RIGHT * 2000
	print(knockback)
	knockback_timer.start()
	#knockback = -velocity.normalized() * 2000

func play_footstep():
	audio_stream_player_2d.pitch_scale = randf_range(0.8, 1.2)
	audio_stream_player_2d.play()

func _on_dialogic_signal(argument:String):
	if argument == "dialog_started":
		disable_input = true
		if animation_player.is_playing():
			animation_player.stop()
	elif argument == "dialog_ended":
		disable_input = false
