extends Area2D
@export var dia_name : String
var dia_box = preload("res://Scenes/DialogueBox.tscn")
var entered_once = false

func _ready():
	body_entered.connect(Callable(get_node("../../Player"), \
		"_on_dia_trig_body_entered"))

func _on_body_entered(body):
	if not entered_once:
		entered_once = true
		body_entered.disconnect(Callable(get_node("../../Player"), \
			"_on_dia_trig_body_entered"))
		dia_box = dia_box.instantiate()
		match(dia_name):
			"D1":
				dia_box.text = Dialogue.D1
			"TestDia":
				dia_box.text = Dialogue.D2
		get_node("../..").add_child(dia_box)
	
