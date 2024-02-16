class_name ShooterComponent extends Marker2D

@export var Bullet : PackedScene
@export var facing_right = true
@export var disabled = false
@export var moveGridComp : Node

func _ready():
	if moveGridComp != null:
		moveGridComp.enable_shooter.connect(_on_shooter_enabled)

func _on_timer_timeout():
	if not disabled:
		shoot()

func shoot():
	var b = Bullet.instantiate()
	add_child(b)
	b.facing_right = facing_right
	b.transform = transform
	#TODO descomentar cuando no haga falta cambiar el tamaño de la bala
	b.scale = Vector2(0.2,0.2)

func _on_shooter_enabled():
	disabled = false
