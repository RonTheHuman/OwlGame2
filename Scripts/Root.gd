extends Node2D
var firefly_packed = preload("res://Scenes/Firefly.tscn")
var last_checkpoint
var discovered_chpts = false
var dia_box = preload("res://Scenes/DialogueBox.tscn")
var vis_dia_arr = []

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		#get_tree().quit()
		add_child(preload("res://Scenes/PauseMenu.tscn").instantiate())
		get_tree().paused = true
	if Input.is_action_just_pressed("ui_page_up"):
		save_game()
	if Input.is_action_just_pressed("restart"):
		load_game()

func _physics_process(_delta):
	var to_translate = $Player.position
	if to_translate.y > -256:
		to_translate.y = -256
	$Camera2D.translate(to_translate - $Camera2D.position)


func save_game(checkpoint = null):
	print("saving")
	var f_loc_arr = []
	if last_checkpoint != null and last_checkpoint != checkpoint:
		last_checkpoint.checkpoint_changed()
	last_checkpoint = checkpoint
	
	if last_checkpoint != null and not discovered_chpts:
			dia_box = dia_box.instantiate()
			dia_box.text = $DiaContainer.dia_dict["checkpoint"]
			add_child(dia_box)
			$Player._on_dia_trig_body_entered(null)
			discovered_chpts = true
	
	for f in $FireflyContainer.get_children():
		f_loc_arr.append([f.center_pos.x, f.center_pos.y, f.is_big])

	#print(f_loc_arr)
	var save_file = FileAccess.open("Scenes/SaveFile.txt", FileAccess.WRITE)
	save_file.store_string(JSON.stringify(
		{
		"discovered_chpts": discovered_chpts,
		"vis_dia_arr": vis_dia_arr,
		"f_count": $FireflyCounter.fireflies,
		"bf_count": $FireflyCounter.big_fireflies,
		"player_pos": [$Player.position.x, $Player.position.y],
		"f_loc_arr": f_loc_arr
		}))
	save_file.close()


func load_game():
	print("loading")
	for f in $FireflyContainer.get_children():
		f.queue_free()
	var save_file = FileAccess.open("Scenes/SaveFile.txt", FileAccess.READ)
	var save_data = JSON.parse_string(save_file.get_as_text())
	var f_loc_arr = save_data["f_loc_arr"]
	vis_dia_arr = save_data["vis_dia_arr"]
	#print(f_loc_arr)
	
	$Player.position = Vector2(save_data["player_pos"][0], save_data["player_pos"][1])
	$Player.velocity = Vector2.ZERO
	for f_loc in f_loc_arr:
		var firefly = firefly_packed.instantiate()
		firefly.position = Vector2(f_loc[0], f_loc[1])
		firefly.is_big = f_loc[2]
		if firefly.is_big:
			firefly.scale = Vector2(2.5, 2.5)
		$FireflyContainer.add_child(firefly)
	$FireflyCounter.set_f(save_data["f_count"])
	$FireflyCounter.set_bf(save_data["bf_count"])
	discovered_chpts = save_data["discovered_chpts"]
	
	for d in $DiaContainer.get_children():
		if (d.dia_name in vis_dia_arr):
			d.queue_free()
	

func _ready():
	#load_game()
	save_game()
