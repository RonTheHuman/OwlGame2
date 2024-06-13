extends Control

var text = Dialogue.text
var cur_row = 0
var visible_chars = 0
@export var portraits : Dictionary
@export var text_speed = 0.5
@onready var DialogueLabel = $PanelContainer/HBoxContainer/DialogueLabel
@onready var PortraitText = $PanelContainer/HBoxContainer/CharContainer/Portrait
@onready var NameLabel = $PanelContainer/HBoxContainer/CharContainer/NameLabel

func _ready():
	show_line(text[cur_row][0], text[cur_row][1])

func _physics_process(_delta):
	if DialogueLabel.visible_ratio < 1:
		visible_chars += text_speed
		DialogueLabel.visible_characters = floor(visible_chars)
		if Input.is_action_just_pressed("jump"):
			print("skipped")
			DialogueLabel.visible_ratio = 1
	else:
		if Input.is_action_just_pressed("jump"):
			cur_row += 1
			if text[cur_row][0] != "_end":
				show_line(text[cur_row][0], text[cur_row][1])
			else:
				queue_free()

func show_line(name, line):
	DialogueLabel.visible_characters = 0;
	visible_chars = 0
	DialogueLabel.text = line
	PortraitText.texture = portraits[name]
	NameLabel.text = name
	

