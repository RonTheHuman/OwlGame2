extends CanvasLayer
var fireflies = 0
var big_fireflies = 0

func add_f():
	fireflies += 1
	$PanelContainer/MarginContainer/HBoxContainer/FLabel.text = "גחליליות: %d" % fireflies

func add_bf():
	big_fireflies += 1
	$PanelContainer/MarginContainer/HBoxContainer/BFLabel.text = "גחליליות גדולות: %d" % big_fireflies
