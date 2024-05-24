extends Control


func _ready():
	get_tree().paused = false


func _on_StartButton_pressed():
	get_tree().change_scene_to_file("res://Scenes/Root.tscn")


func _on_ExitButton_pressed():
	print("aaa")
	get_tree().quit()
