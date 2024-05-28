extends Area2D

@export var wobble_speed = 0.015
@export var wobble_size = 0.1
@export var is_big = 0

var count = 0


func _ready():
	var rng = RandomNumberGenerator.new()
	body_entered.connect(Callable(get_node("../../Player"), \
				"_on_firefly_body_entered").bind(is_big))
	count = rng.randf_range(0, 2*PI)

func _physics_process(_delta):
	count += wobble_speed
	translate(Vector2(0, wobble_size*cos(count)*scale.y))
	if count > 2*PI:
		count = 0

func _on_body_entered(_body):
	$GPUParticles2D.emitting = true
	$AnimatedSprite2D.visible = false
	$PointLight2D.visible = false

func _on_gpu_particles_2d_finished():
	queue_free()



