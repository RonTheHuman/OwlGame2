extends Area2D

@export var wobble_speed = 0.015
@export var wobble_size = 0.1
@export var is_big = 0

var count = 0
var collected = false
var home_pos
var center_pos

var ret_dir
var ret_speed = 20
var ret_frames = 15
var ret_count = 0
var alpha = 1


func _ready():
	var rng = RandomNumberGenerator.new()
	body_entered.connect(Callable(get_node("../../Player"), \
				"_on_firefly_body_entered").bind(is_big))
	count = rng.randf_range(0, 2*PI)
	home_pos = get_node("../../FireflyHome").position
	center_pos = position
	#print(home_pos)

func _physics_process(_delta):
	if not collected:
		count += wobble_speed
		translate(Vector2(0, wobble_size*cos(count)*scale.y))
		if count > 2*PI:
			count = 0
	else:
		if ret_count < ret_frames:
			ret_count += 1
			if (home_pos-position).dot(ret_dir) >= 0:
				translate(ret_dir*ret_speed)
			alpha -= 1/float(ret_frames)
			$AnimatedSprite2D.set_modulate(Color(1, 1, 1, alpha))
			$PointLight2D.energy = alpha
		else:
			queue_free()

func _on_body_entered(_body):
	look_at(home_pos)
	rotate(PI/2)
	collected = true
	$GPUParticles2D.emitting = true
	ret_dir = (home_pos - position).normalized()
	print("looking")
	
	



