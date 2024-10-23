extends Node2D
var firefly_packed = preload("res://Scenes/Firefly.tscn")


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		#get_tree().quit()
		add_child(preload("res://Scenes/PauseMenu.tscn").instantiate())
		get_tree().paused = true
	if Input.is_action_just_pressed("ui_page_up"):
		save_game()
	if Input.is_action_just_pressed("ui_page_down"):
		load_game()

func _physics_process(_delta):
	var to_translate = $Player.position
	if to_translate.y > -256:
		to_translate.y = -256
	$Camera2D.translate(to_translate - $Camera2D.position)


func save_game():
	print("saving")
	var f_loc_arr = []
	for f in $FireflyContainer.get_children():
		f_loc_arr.append([f.position.x, f.position.y, f.is_big])
	print(f_loc_arr)
	var save_file = FileAccess.open("Scenes/SaveFile.txt", FileAccess.WRITE)
	save_file.store_string(JSON.stringify(f_loc_arr))
	save_file.close()


func load_game():
	print("loading")
	for f in $FireflyContainer.get_children():
		f.queue_free()
	var f_loc_arr = []
	var save_file = FileAccess.open("Scenes/SaveFile.txt", FileAccess.READ)
	f_loc_arr = JSON.parse_string(save_file.get_as_text())
	print(f_loc_arr)
	for f_loc in f_loc_arr:
		var firefly = firefly_packed.instantiate()
		firefly.position = Vector2(f_loc[0], f_loc[1])
		firefly.is_big = f_loc[2]
		if firefly.is_big:
			firefly.scale = Vector2(2.5, 2.5)
		$FireflyContainer.add_child(firefly)
