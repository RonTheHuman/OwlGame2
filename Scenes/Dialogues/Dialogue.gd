extends Node
class_name Dialogue
var num = 0
var D1
var D2

func _ready():
	var dia_text_file = FileAccess.open("Scenes/Dialogues/D1.txt", FileAccess.READ)
	D1 = JSON.parse_string(dia_text_file.get_as_text())
	dia_text_file.close()

	dia_text_file = FileAccess.open("Scenes/Dialogues/D2.txt", FileAccess.READ)
	D2 = JSON.parse_string(dia_text_file.get_as_text())
	dia_text_file.close()
