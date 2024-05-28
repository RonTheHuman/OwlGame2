extends Area2D

signal entered_wind(angles)

func _ready():
	connect("entered_wind", Callable(get_node("../../Player"), "_on_wind_entered_wind"))
	connect("body_exited", Callable(get_node("../../Player"), "_on_wind_body_exited"))

func _on_Wind_body_entered(_body):
	print(global_position)
	emit_signal("entered_wind", rotation_degrees)
