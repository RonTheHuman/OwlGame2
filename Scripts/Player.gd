extends CharacterBody2D


@export var walk_v : float
@export var ground_f : float
@export var jump_a : float
@export var gravity_a : float
@export var air_f : float
@export var glide_a : float
@export var max_glide_v : float
@export var fly_v : float
@export var wind_a : float
@export var direction_change_s : float

var gliding = false
var jumps = 1
var wind_angles = 0
var in_wind = 0
var tar_angle
var dir = 1
@onready var cur_angle = $AnimatedSprite2D.rotation_degrees

func _physics_process(delta : float):
	var acceleration = Vector2.ZERO
	
	if Input.is_action_just_pressed("glide"):
		gliding = not gliding
		if not gliding:
			$AnimatedSprite2D.play("walk")
		print(gliding)
	
	if not is_on_floor():
			acceleration.y += gravity_a
	
	if not gliding:
		if Input.is_action_pressed("right"):
			velocity.x = walk_v
			$AnimatedSprite2D.flip_h = false
		elif Input.is_action_pressed("left"):
			velocity.x = -walk_v
			$AnimatedSprite2D.flip_h = true
		if is_on_floor():
			jumps = 1
		if (not (Input.is_action_pressed("right") or 
		Input.is_action_pressed("left"))) or abs(velocity.x) > walk_v:
			velocity.x *= ground_f
		if Input.is_action_just_pressed("jump") and jumps > 0:
			acceleration.y = jump_a
			jumps -= 1
		elif Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y *= 0.5
		if Input.is_action_just_pressed("down"):
			$AnimatedSprite2D.play("crouch")
			$StandingCollision2D.disabled = true
			$CrouchCollision2D.disabled = false
		elif Input.is_action_just_released("down"):
			$AnimatedSprite2D.play("walk")
			$StandingCollision2D.disabled = false
			$CrouchCollision2D.disabled = true
	else:
		$AnimatedSprite2D.play("flight")
		if is_on_floor():
			gliding = false
			$AnimatedSprite2D.play("walk")
		else:
			velocity.y *= air_f
			if Input.is_action_pressed("right"):
				velocity.x += glide_a
				$AnimatedSprite2D.flip_h = false
			if Input.is_action_pressed("left"):
				velocity.x -= glide_a
				$AnimatedSprite2D.flip_h = true
			if (abs(velocity.x) > max_glide_v):
				if (velocity.x > 0):
					velocity.x = max_glide_v
				else:
					velocity.x  = -max_glide_v
	
	velocity += acceleration
	move_and_slide()
	cur_angle = $AnimatedSprite2D.rotation_degrees


func _on_Wind_entered_wind(angles):
	wind_angles = angles
	in_wind += 1


func _on_Wind_body_exited(body):
	in_wind -= 1
