extends Node2D


func _ready():
	pass


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		add_child(preload("res://Scenes/PauseMenu.tscn").instance())
		get_tree().paused = true
