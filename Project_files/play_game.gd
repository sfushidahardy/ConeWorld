extends Node2D

var buttonchoice = 3

func _ready():
	var data = load_data("user://save_data.tres")
	if data == null:
		$continue.disabled = true
	else:
		$continue.disabled = false

func load_data(file_name):
	if ResourceLoader.exists(file_name):
		var data = ResourceLoader.load(file_name)
		if data.level_count != 0:
			return data

func _on_newgame_pressed():
	var data = savedata.new()
	data.total_butterfly_count = 0
	data.death_count = 0
	data.level_count = 0
	$"/root/global".total_butterfly_count = 0
	$"/root/global".level_butterfly_count = 0
	$"/root/global".death_count = 0
	$"/root/global".level_count = 0
	$"/root/global".transition_coordinates = Vector2.ZERO
	ResourceSaver.save("user://save_data.tres", data)
	get_tree().change_scene("res://Map0.tscn")


func _on_continue_pressed():
	var data = load_data("user://save_data.tres")
	$"/root/global".total_butterfly_count = data.total_butterfly_count
	$"/root/global".level_butterfly_count = 0
	$"/root/global".transition_coordinates = data.level_starting_coordinates
	$"/root/global".level_count = data.level_count
	go_to_level(data.level_count)

func go_to_level(n):
	if n == 0:
		get_tree().change_scene("res://Map0.tscn")
	if n == 1:
		get_tree().change_scene("res://Map1.tscn")
	if n == 2:
		get_tree().change_scene("res://Map2.tscn")
	if n == 3:
		get_tree().change_scene("res://Map3.tscn")
	if n == 4:
		get_tree().change_scene("res://Map4.tscn")
	if n == 5:
		get_tree().change_scene("res://Map5.tscn")

func _on_back_pressed():
	get_tree().change_scene("res://titlescreen.tscn")

func _input(event):
	if $continue.disabled == true:
		simplebuttonchoice(event)
	else:
		trickybuttonchoice(event)

func simplebuttonchoice(event):
	if event.is_action_pressed("ui_down"):
		$back.grab_focus()
		$newgame.release_focus()
		buttonchoice = 1
	if event.is_action_pressed("ui_up"):
		$newgame.grab_focus()
		$back.release_focus()
		buttonchoice = 0
	if event.is_action_pressed("ui_select"):
		if buttonchoice == 0:
			$newgame.emit_signal("pressed")
		elif buttonchoice == 1:
			$back.emit_signal("pressed")
			
func trickybuttonchoice(event):
	if buttonchoice == 3:
		choosebutton_3(event)
	elif buttonchoice == 0:
		choosebutton_0(event)
	elif buttonchoice == 1:
		choosebutton_1(event)
	elif buttonchoice == 2:
		choosebutton_2(event)

func choosebutton_3(event):
	if event.is_action_pressed("ui_down") or event.is_action_pressed("ui_up") or event.is_action_pressed("ui_select"):
		$continue.grab_focus()
		$newgame.release_focus()
		$back.release_focus()
		buttonchoice = 1

func choosebutton_0(event):
	if event.is_action_pressed("ui_up"):
		pass
	elif event.is_action_pressed("ui_down"):
		$continue.grab_focus()
		$newgame.release_focus()
		$back.release_focus()
		buttonchoice = 1
	elif event.is_action_pressed("ui_select"):
		$newgame.emit_signal("pressed")

func choosebutton_1(event):
	if event.is_action_pressed("ui_up"):
		$continue.release_focus()
		$newgame.grab_focus()
		$back.release_focus()
		buttonchoice = 0
	elif event.is_action_pressed("ui_down"):
		$continue.release_focus()
		$newgame.release_focus()
		$back.grab_focus()
		buttonchoice = 2
	elif event.is_action_pressed("ui_select"):
		$continue.emit_signal("pressed")

func choosebutton_2(event):
	if event.is_action_pressed("ui_up"):
		$continue.grab_focus()
		$newgame.release_focus()
		$back.release_focus()
		buttonchoice = 1
	elif event.is_action_pressed("ui_down"):
		pass
	elif event.is_action_pressed("ui_select"):
		$back.emit_signal("pressed")

func _on_newgame_mouse_entered():
	$continue.release_focus()
	$back.release_focus()
	buttonchoice = 3

func _on_continue_mouse_entered():
	$newgame.release_focus()
	$back.release_focus()
	buttonchoice = 3
	
func _on_back_mouse_entered():
	$newgame.release_focus()
	$continue.release_focus()
	buttonchoice = 3
