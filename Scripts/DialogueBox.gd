extends CanvasLayer

signal dialogue_over

var text
var cur_row = 0
var visible_chars = 0
@export var portraits : Dictionary
@export var text_speed = 0.5
@onready var DialogueLabel = $PanelContainer/HBoxContainer/DialogueLabel
@onready var PortraitText = $PanelContainer/HBoxContainer/CharContainer/Portrait
@onready var NameLabel = $PanelContainer/HBoxContainer/CharContainer/MarginContainer/NameLabel

func _ready():
	if text == null:
		print("no text given")
		queue_free()
	else:
		show_line(text[cur_row][0], text[cur_row][1])
	connect("dialogue_over", Callable(get_node("../Player"), \
								 "_on_dia_trig_dialogue_over"))

func _physics_process(_delta):
	if DialogueLabel.visible_ratio < 1:
		visible_chars += text_speed
		DialogueLabel.visible_characters = floor(visible_chars)
		if Input.is_action_just_pressed("jump") or \
				Input.is_key_pressed(KEY_F2):
			#print("skipped")
			DialogueLabel.visible_ratio = 1
	else:
		if Input.is_action_just_pressed("jump") or \
				Input.is_key_pressed(KEY_F2):
			cur_row += 1
			if text[cur_row][0] != "_end":
				show_line(text[cur_row][0], text[cur_row][1])
			else:
				dialogue_over.emit()
				queue_free()

func show_line(char_name, line):
	DialogueLabel.visible_characters = 0;
	visible_chars = 0
	DialogueLabel.text = line
	PortraitText.texture = portraits[char_name]
	NameLabel.text = char_name
	

