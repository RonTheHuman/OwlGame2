extends KinematicBody2D


export var walk_a : float
export var walk_f : float
export var max_walk_v : float
export var jump_a : float
export var gravity_a : float
export var glide_f : float
export var glide_jump_a : float


var velocity = Vector2.ZERO
var state = "fall"
var glide_jumped = false


func _physics_process(delta : float):
	var acceleration := Vector2.ZERO
	if state == "fall":
		if is_on_floor():
			state = "ground"
		if Input.is_action_just_pressed("down"):
			state = "glide"
	elif state == "ground":
		if Input.is_action_just_pressed("up"):
			state = "jump"
		elif not is_on_floor():
			state = "fall"
	elif state == "jump":
		if is_on_floor():
			state = "ground"
		if Input.is_action_just_pressed("down"):
			state = "glide"
	elif state == "glide":
		if Input.is_action_just_pressed("down"):
			state = "fall"
		if Input.is_action_just_pressed("up"):
			state = "glide_jump"
		if is_on_floor():
			state = "ground"
	elif state == "glide_jump":
		if velocity.y > 0:
			state = "glide"
		if Input.is_action_just_pressed("down"):
			state = "fall"
	
	if state == "fall" or state == "ground" or state == "jump" or state == "glide" or "glide_jump":
		if Input.is_action_pressed("right"):
			acceleration.x += walk_a
		if Input.is_action_pressed("left"):
			acceleration.x -= walk_a
		velocity.y += acceleration.y
		velocity.x *= walk_f
		velocity.x = clamp(velocity.x, -max_walk_v, max_walk_v)
		acceleration.y += gravity_a
	if state == "ground":
		glide_jumped = false
	if state == "jump":
		if is_on_floor():
			acceleration.y = jump_a
		if Input.is_action_just_released("up") and velocity.y < 0:
			velocity.y *= 0.6
	if state == "glide":
		velocity.y *= glide_f
	if state == "glide_jump":
		if Input.is_action_just_pressed("up") and not glide_jumped:
			velocity.y = 0
			acceleration.y = glide_jump_a
			glide_jumped = true
			
		
	velocity += acceleration
	print("state: ", state, ", acc: ", acceleration, ", vel: ", velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
