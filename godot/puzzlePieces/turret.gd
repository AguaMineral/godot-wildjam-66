extends StaticBody2D

@export var face_left = false

@onready var shooter_component = $ShooterComponent
@onready var sprite_2d = $Sprite2D

func _ready():
	if(face_left):
		flip_horz()

func flip_horz():
	shooter_component.facing_right = false
	shooter_component.scale = Vector2(-1,1)
	sprite_2d.scale = Vector2(-1,1)
