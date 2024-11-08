extends Node
class_name Dialogue
var num = 0
var dia_dict = {}

func _ready():
	load_dialogue("expo")
	load_dialogue("glide_t")
	load_dialogue("checkpoint")
	load_dialogue("barrier")
	load_dialogue("pun_1")
	load_dialogue("pun_2")


func load_dialogue(f_name):
	var dia_text_file = FileAccess.open("Scenes/Dialogues/%s.txt"%f_name, FileAccess.READ)
	dia_dict[f_name] = JSON.parse_string(dia_text_file.get_as_text())
	dia_text_file.close()
