class_name MoveGridObjectComp extends Node2D

signal enable_shooter

@onready var ray_cast_down = $RayCastDown
@onready var ray_cast_lef = $RayCastLef
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_up = $RayCastUp

@onready var ray_cast_down_3 = $RayCastDown3
@onready var ray_cast_up_3 = $RayCastUp3
@onready var ray_cast_right_3 = $RayCastRight3
@onready var ray_cast_lef_3 = $RayCastLef3


@onready var ray_cast_down_2 = $RayCastDown2
@onready var ray_cast_up_2 = $RayCastUp2
@onready var ray_cast_right_2 = $RayCastRight2
@onready var ray_cast_lef_2 = $RayCastLef2

@onready var audio_stream_player = $AudioStreamPlayer

@export var object_to_move : Node2D
@export var shooterComp : Node

var move_dir = Vector2.ZERO
var tile_size = 128
var animation_speed = 3
var moving = false
var using_shooter = false

func _ready():
	object_to_move.position = object_to_move.position.snapped(Vector2.ONE * tile_size)
	object_to_move.position += Vector2.ONE * tile_size/2
	using_shooter = shooterComp != null

func _physics_process(delta):
	set_move_direction()

func set_move_direction():
	move_dir = Vector2.ZERO
	
	#  hit with player
	var ray_right_hit = ray_cast_right.is_colliding()
	var ray_left_hit = ray_cast_lef.is_colliding()
	var ray_down_hit = ray_cast_down.is_colliding()
	var ray_up_hit = ray_cast_up.is_colliding()
	
	var ray_right_hit_2 = ray_cast_right_3.is_colliding()
	var ray_left_hit_2 = ray_cast_lef_3.is_colliding()
	var ray_down_hit_2 = ray_cast_down_3.is_colliding()
	var ray_up_hit_2 = ray_cast_up_3.is_colliding()
	
	#hit with env
	var ray_right_hit_env = ray_cast_right_2.is_colliding()
	if using_shooter:
		var objCollided = ray_cast_right_2.get_collider()
		
	var ray_left_hit_env = ray_cast_lef_2.is_colliding()
	var ray_down_hit_env = ray_cast_down_2.is_colliding()
	var ray_up_hit_env = ray_cast_up_2.is_colliding()
	
	if (ray_down_hit or ray_down_hit_2) and not ray_up_hit_env:
		move_dir = Vector2.UP
	elif (ray_up_hit or ray_up_hit_2) and not ray_down_hit_env:
		move_dir = Vector2.DOWN
	elif (ray_right_hit or ray_right_hit_2) and not ray_left_hit_env:
		move_dir = Vector2.LEFT
	elif (ray_left_hit or ray_left_hit_2) and not ray_right_hit_env:
		move_dir = Vector2.RIGHT

func move_object() -> int:
	if moving:
		return -1
	var tween = create_tween()
	tween.tween_property(object_to_move, "position", object_to_move.position + move_dir * tile_size, 1.0/animation_speed ).set_trans(Tween.TRANS_SINE)
	moving = true
	audio_stream_player.pitch_scale = randf_range(0.8,1.2)
	audio_stream_player.play()
	await tween.finished
	moving = false
	if move_dir == Vector2.ZERO:
		return 0
	else:
		return 1
