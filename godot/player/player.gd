extends CharacterBody2D

@onready var interact_label = $InteractionComponents/InteractLabel
@onready var knockback_timer = $KnockbackTimer
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D

@onready var all_interactions = []

@export var speed = 400  # speed in pixels/sec
var knockback : Vector2 = Vector2(0,0)
var knockbackTween
var in_knockback = false

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

func _physics_process(delta):
	handle_movement()
	handle_input()

func handle_movement():
	var direction = Vector2.ZERO
	#if (knockback == Vector2.ZERO):
	if(knockback_timer.time_left <= 0.0):
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction != Vector2.ZERO:
		if direction.x < 0:
			sprite_2d.flip_h = false
		elif direction.x > 0:
			sprite_2d.flip_h = true
	elif knockback_timer.time_left <= 0.0 and !animation_player.is_playing():
		animation_player.play("player_walking")
	velocity = (direction * speed) + knockback
	knockback = lerp(knockback, Vector2.ZERO, 0.2)
	move_and_slide()

func handle_input():
	if Input.is_action_just_pressed("interact"):
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
						current_interaction.interaction_parent.move_object()

func _on_player_hit(y_coord : float):
	hit(y_coord)

func hit(y_coord : float):
	animation_player.stop()
	animation_player.play("player_boing")
	if y_coord >= global_position.y:
		knockback = Vector2.UP * 2000
	else:
		knockback = Vector2.DOWN * 2000
	knockback_timer.start()
	#knockback = -velocity.normalized() * 2000
	#if abs(knockback) == Vector2.ZERO:
		#pass
