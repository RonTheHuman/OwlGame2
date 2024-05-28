extends Node2D


func _ready():
	pass


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().quit()
		add_child(preload("res://Scenes/PauseMenu.tscn").instantiate())
		get_tree().paused = true

func _physics_process(_delta):
	$Camera2D.translate($Player.position - $Camera2D.position)
