extends Node2D

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		#get_tree().quit()
		add_child(preload("res://Scenes/PauseMenu.tscn").instantiate())
		get_tree().paused = true

func _physics_process(_delta):
	var to_translate = $Player.position
	if to_translate.y > -256:
		to_translate.y = -256
	$Camera2D.translate(to_translate - $Camera2D.position)
