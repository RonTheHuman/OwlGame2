extends CharacterBody2D


@export var walk_v : float
@export var ground_f : float
@export var jump_a : float
@export var gravity_a : float

@export var v_air_f : float
@export var h_air_f : float
@export var glide_a : float
@export var max_glide_v : float

@export var fly_v : float
@export var wind_a : float

@export var coyote_frames : float
@export var fly_frames : float

var gliding = false
var jumps = 1
var wind_angles = 0
var in_wind = 0

var was_on_floor = false
var coyote_count = 0
var fly_count = 0

@onready var cur_angle = $AnimatedSprite2D.rotation_degrees

func _physics_process(delta : float):
	var acceleration = Vector2.ZERO
	
	if Input.is_action_just_pressed("glide"):
		gliding = not gliding
		if gliding:
			$AnimatedSprite2D.play("flight")
		else:
			$AnimatedSprite2D.play("walk")
	
	if not is_on_floor():
			if coyote_count < coyote_frames:
				coyote_count += 1
			else:
				was_on_floor = false
			acceleration.y += gravity_a
	else:
		was_on_floor = true
		coyote_count = 0
	
	if not gliding:
		if Input.is_action_pressed("right"):
			velocity.x = walk_v
			$AnimatedSprite2D.flip_h = false
		elif Input.is_action_pressed("left"):
			velocity.x = -walk_v
			$AnimatedSprite2D.flip_h = true
		if is_on_floor():
			jumps = 1
			fly_count = 0
		if (not (Input.is_action_pressed("right") or 
		Input.is_action_pressed("left"))) or abs(velocity.x) > walk_v:
			velocity.x *= ground_f
		if Input.is_action_just_pressed("jump") and jumps > 0 and was_on_floor:
			velocity.y = 0
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
		if is_on_floor():
			gliding = false
			$AnimatedSprite2D.play("walk")
		else:
			if in_wind > 0:
				velocity += Vector2(0, wind_a).rotated(deg_to_rad(wind_angles))
				if wind_angles == 0:
					fly_count = min(fly_count, fly_frames/2)
			if velocity.y > 0:
				velocity.y *= v_air_f
			velocity.x *= h_air_f
			if Input.is_action_pressed("right"):
				acceleration.x += glide_a
				$AnimatedSprite2D.flip_h = false
			if Input.is_action_pressed("left"):
				acceleration.x -= glide_a
				$AnimatedSprite2D.flip_h = true
			if Input.is_action_pressed("jump") and fly_count < fly_frames \
					and not in_wind:
				velocity.y = -fly_v
				fly_count += 1
				if $AnimatedSprite2D.animation != "flap":
					$AnimatedSprite2D.play("flap")
			if Input.is_action_just_released("jump") or fly_count == fly_frames:
				$AnimatedSprite2D.play("flight")
				
				
			if (abs(acceleration.x) > max_glide_v):
				if (acceleration.x > 0):
					acceleration.x = max_glide_v
				else:
					acceleration.x  = -max_glide_v
			
	
	velocity += acceleration
	move_and_slide()
	cur_angle = $AnimatedSprite2D.rotation_degrees


func _on_Wind_entered_wind(angles):
	wind_angles = angles
	in_wind += 1
	print(in_wind)


func _on_Wind_body_exited(body):
	in_wind -= 1
	print(in_wind)
