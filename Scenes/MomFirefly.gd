extends Area2D

@export var wobble_speed = 0.015
@export var wobble_size = 0.1

var count = 0


func _ready():
	$CollisionShape2D.disabled = true
	
func _physics_process(delta):
	count += wobble_speed
	translate(Vector2(0, wobble_size*cos(count)*scale.y))
	if count > 2*PI:
		count = 0
	
	



