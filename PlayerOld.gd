extends CharacterBody2D


@export var walk_a : float
@export var walk_f : float
@export var max_walk_v : float
@export var jump_a : float
@export var gravity_a : float
@export var glide_f : float
@export var glide_jump_a : float
@export var wind_a : float
@export var direction_change_s : float

var state = "fall"
var jumps = 2
var wind_angles = 0
var in_wind = 0
var tar_angle
var dir = 1
@onready var cur_angle = $AnimatedSprite2D.rotation_degrees


func update_state():
	# ------------------------------ state transitions
	if state == "fall":
		if is_on_floor():
			state = "ground"
		if Input.is_action_just_pressed("glide"):
			state = "glide"
		if Input.is_action_just_pressed("up"):
			state = "jump"
			
	elif state == "ground":
		if Input.is_action_just_pressed("up"):
			state = "jump"
		if Input.is_action_pressed("down"):
			state = "crouch"
		if not is_on_floor():
			state = "fall"
			
	elif state == "crouch":
		if Input.is_action_just_released("down"):
			state = "ground"
			
	elif state == "jump":
		if is_on_floor():
			state = "ground"
		if Input.is_action_just_pressed("glide"):
			state = "glide"
			
	elif state == "glide":
		if Input.is_action_just_pressed("glide"):
			state = "fall"
		if Input.is_action_just_pressed("up"):
			state = "glide_jump"
		if is_on_floor():
			if Input.is_action_pressed("down"):
				state = "crouch"
			else:
				state = "ground"
		if in_wind > 0:
			state = "wind"
			
	elif state == "glide_jump":
		if velocity.y > 0:
			state = "glide"
		if Input.is_action_just_pressed("down"):
			state = "fall"
	
	elif state == "wind":
		if in_wind == 0:
			state = "glide"
		if Input.is_action_just_pressed("glide"):
			state = "fall"

func _physics_process(delta : float):
	var acceleration := Vector2.ZERO
	update_state()
	# ------------------------------ state behaviour
	if Input.is_action_pressed("right"):
		acceleration.x += walk_a
		dir = 1
		$AnimatedSprite2D.flip_h = false
	if Input.is_action_pressed("left"):
		acceleration.x -= walk_a
		dir = -1
		$AnimatedSprite2D.flip_h = true
	velocity.y += acceleration.y
	velocity.x *= walk_f
	velocity.x = clamp(velocity.x, -max_walk_v, max_walk_v)
	acceleration.y += gravity_a
		
	if state == "ground" or state == "crouch":
		jumps = 2
		
	if state == "ground":
		$StandingCollision2D.disabled = false
		$CrouchCollision2D.disabled = true
		$FlightCollision2D.disabled = true
		
	if state == "crouch":
		$AnimatedSprite2D.rotation_degrees = 0
		$AnimatedSprite2D.animation = "crouch"
		$StandingCollision2D.disabled = true
		$CrouchCollision2D.disabled = false
		$FlightCollision2D.disabled = true
	
	if state == "jump" or state == "crouch":
		if Input.is_action_just_pressed("up") and jumps > 0:
			if is_on_floor():
				if state == "crouch":
					acceleration.y = jump_a*0.7
				else:
					acceleration.y = jump_a
			else:
				acceleration.y = glide_jump_a
			velocity.y = 0
			jumps -= 1
		if Input.is_action_just_released("up") and velocity.y < 0:
			velocity.y *= 0.6
			
	if state == "glide" or state == "wind":
		print(cur_angle, " ", tar_angle)
		if velocity.y > 0:
			velocity.y *= glide_f
			tar_angle = 20 * dir
#			$AnimatedSprite.set_rotation_degrees(cur_angle + direction_change_s * (tar_angle - cur_angle))
		elif velocity.y < -100:
			tar_angle = (9000/-velocity.y - 90 + 20) * dir
#			$AnimatedSprite.set_rotation_degrees(cur_angle + direction_change_s * (tar_angle - cur_angle))
		else:	
			tar_angle = 5
#			$AnimatedSprite.set_rotation_degrees(cur_angle + direction_change_s * (tar_angle - cur_angle))
	
			
	if state == "wind":
		var final_wind_a = Vector2(0, wind_a).rotated(deg_to_rad(wind_angles))
#		print(final_wind_a)
		final_wind_a.x *= 2
		acceleration += final_wind_a
#		print("state: ", state, ", acc: ", acceleration, ", vel: ", velocity)

	if state == "glide_jump":
		if Input.is_action_just_pressed("up") and jumps > 0:
			acceleration.y = glide_jump_a
			velocity.y = 0
			jumps -= 1
			
	if state == "glide":
		$AnimatedSprite2D.animation = "flight"
		$StandingCollision2D.disabled = true
		$CrouchCollision2D.disabled = true
		$FlightCollision2D.disabled = false
	elif state == "fall" or state == "jump" or state == "ground":
		$AnimatedSprite2D.rotation_degrees = 0
		$AnimatedSprite2D.animation = "walk"
		if state == "ground" and abs(velocity.x) > 200:
			$AnimatedSprite2D.play()
		else:
			$AnimatedSprite2D.stop()
	
	print(state, " ", velocity.x)
	velocity += acceleration
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity
	cur_angle = $AnimatedSprite2D.rotation_degrees


func _on_Wind_entered_wind(angles):
	wind_angles = angles
	in_wind += 1


func _on_Wind_body_exited(body):
	in_wind -= 1
