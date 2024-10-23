extends Area2D


func _on_body_entered(_body):
	$Sprite2D.region_rect.position.x = 576
	$PointLight2D.enabled = true
	get_parent().get_parent().save_game(self)


func checkpoint_changed():
	$Sprite2D.region_rect.position.x = 512
	$PointLight2D.enabled = false
