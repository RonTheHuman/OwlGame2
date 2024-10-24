extends Node
class_name Dialogue
var num = 0
var dia_dict = {}

func _ready():
	var dia_text_file = FileAccess.open("Scenes/Dialogues/expo.txt", FileAccess.READ)
	dia_dict["expo"] = JSON.parse_string(dia_text_file.get_as_text())
	dia_text_file.close()

	dia_text_file = FileAccess.open("Scenes/Dialogues/glide_t.txt", FileAccess.READ)
	dia_dict["glide_t"] = JSON.parse_string(dia_text_file.get_as_text())
	dia_text_file.close()
	
	dia_text_file = FileAccess.open("Scenes/Dialogues/checkpoint.txt", FileAccess.READ)
	dia_dict["checkpoint"] = JSON.parse_string(dia_text_file.get_as_text())
	dia_text_file.close()
