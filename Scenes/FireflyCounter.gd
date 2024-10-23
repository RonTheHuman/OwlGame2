extends CanvasLayer
var fireflies = 0
var big_fireflies = 0


func set_f(f):
	fireflies = f
	$PanelContainer/MarginContainer/HBoxContainer/FLabel.text = "גחליליות: %d" % fireflies


func set_bf(bf):
	big_fireflies = bf
	$PanelContainer/MarginContainer/HBoxContainer/BFLabel.text = "גחליליות גדולות: %d" % big_fireflies


func add_f():
	fireflies += 1
	$PanelContainer/MarginContainer/HBoxContainer/FLabel.text = "גחליליות: %d" % fireflies

func add_bf():
	big_fireflies += 1
	$PanelContainer/MarginContainer/HBoxContainer/BFLabel.text = "גחליליות גדולות: %d" % big_fireflies
