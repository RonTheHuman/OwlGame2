extends Node
class_name Dialogue
var num = 0
var D1
var D2

func _ready():
	var dia_text = FileAccess.open("Scenes/Dialogues/D1.txt", FileAccess.READ).get_as_text()
	D1 = JSON.parse_string(dia_text)

	dia_text = FileAccess.open("Scenes/Dialogues/D2.txt", FileAccess.READ).get_as_text()
	D2 = JSON.parse_string(dia_text)
