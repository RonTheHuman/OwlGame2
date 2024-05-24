extends CharacterBody2D


@export var walk_a : float
@export var walk_f : float
@export var walk_v : float
@export var jump_a : float
@export var gravity_a : float
@export var glide_f : float
@export var glide_jump_a : float
@export var wind_a : float
@export var direction_change_s : float

var gliding = false
var jumps = 2
var wind_angles = 0
var in_wind = 0
var tar_angle
var dir = 1
@onready var cur_angle = $AnimatedSprite2D.rotation_degrees

func _physics_process(delta : float):
	var acceleration = Vector2.ZERO
	if not gliding:
		if Input.is_action_pressed("right"):
			position.x += walk_v
		if Input.is_action_pressed("left"):
			position.x -= walk_v
		if not is_on_floor():
			acceleration.y += gravity_a
		if Input.is_action_just_pressed("jump"):
			acceleration.y = jump_a
		elif Input.is_action_just_released("jump"):
			velocity.y *= 0.5
		if Input.is_action_just_pressed("down"):
			$AnimatedSprite2D.play("crouch")
			$StandingCollision2D.disabled = true
			$CrouchCollision2D.disabled = false
		elif Input.is_action_just_released("down"):
			$AnimatedSprite2D.play("walk")
			$StandingCollision2D.disabled = false
			$CrouchCollision2D.disabled = true
	velocity += acceleration
	print(velocity)
	move_and_slide()
	cur_angle = $AnimatedSprite2D.rotation_degrees


func _on_Wind_entered_wind(angles):
	wind_angles = angles
	in_wind += 1


func _on_Wind_body_exited(body):
	in_wind -= 1
