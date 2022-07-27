extends Area2D

signal entered_wind(angles)

export var player_path : NodePath

func _ready():
	connect("entered_wind", get_node("../Player"), "_on_Wind_entered_wind")
	connect("body_exited", get_node("../Player"), "_on_Wind_body_exited")

func _on_Wind_body_entered(body):
	emit_signal("entered_wind", rotation_degrees)
