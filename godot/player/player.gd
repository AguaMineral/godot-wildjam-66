extends CharacterBody2D

@onready var interact_label = $InteractionComponents/InteractLabel

@onready var all_interactions = []

@export var speed = 400  # speed in pixels/sec

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

func _physics_process(delta):
	handle_movement()
	handle_input()

func handle_movement():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	
	move_and_slide()

func handle_input():
	if Input.is_action_just_pressed("interact"):
		execute_interaction()

# Interactions

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
