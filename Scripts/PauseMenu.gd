extends CanvasLayer


func _ready():
	pass


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		_on_ResumeButton_pressed()


func _on_ResumeButton_pressed():
	queue_free()
	get_tree().paused = false


func _on_QuitButton_pressed():
	get_tree().change_scene_to_file("res://Scenes/StartMenu.tscn")
	get_tree().paused = false
