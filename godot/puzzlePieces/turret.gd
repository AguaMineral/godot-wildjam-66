extends StaticBody2D
@onready var ray_cast_down = $RayCastDown
@onready var ray_cast_lef = $RayCastLef
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_up = $RayCastUp

var tile_size = 128
var move_dir = Vector2.ZERO
var animation_speed = 3
var moving = false

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

func _physics_process(delta):
	
	move_dir = Vector2.ZERO
	var ray_right_hit = ray_cast_right.is_colliding()
	var ray_left_hit = ray_cast_lef.is_colliding()
	var ray_down_hit = ray_cast_down.is_colliding()
	var ray_up_hit = ray_cast_up.is_colliding()
	
	if ray_down_hit:
		move_dir = Vector2.UP
	elif ray_up_hit:
		move_dir = Vector2.DOWN
	elif ray_right_hit:
		move_dir = Vector2.LEFT
	elif ray_left_hit:
		move_dir = Vector2.RIGHT

func move_object():
	if moving:
		return
	var tween = create_tween()
	tween.tween_property(self, "position", position + move_dir * tile_size, 1.0/animation_speed ).set_trans(Tween.TRANS_SINE)
	moving = true
	await tween.finished
	moving = false
