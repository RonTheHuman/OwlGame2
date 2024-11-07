extends Area2D
@export var dia_name : String
@export var fireflies_needed : int

var dia_box = preload("res://Scenes/DialogueBox.tscn")
var entered_once = false
var entered_twice


signal dialogue_over

func _ready():
	body_entered.connect(Callable(get_node("../../Player"), \
		"_on_dia_trig_body_entered"))
	connect("dialogue_over", Callable(get_node("../../Player"), \
								"_on_dia_trig_dialogue_over"))

func _on_body_entered(_body):
	if not entered_once:
		entered_once = true
		dia_box = dia_box.instantiate()
		dia_box.text = get_parent().dia_dict[dia_name]
		get_node("../..").add_child(dia_box)
	else:
		if not entered_twice:
			entered_twice = true


func _on_body_exited(_body):
	if entered_twice:
		dialogue_over.emit()

func _physics_process(_delta):
	if get_node("../../FireflyCounter").big_fireflies >= fireflies_needed:
		queue_free()
