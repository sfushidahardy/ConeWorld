extends Popup
var buttonchoice = 2
signal unpause

func _on_back_pressed():
	emit_signal("unpause")

func _on_title_screen_pressed():
	emit_signal("unpause")
	get_tree().change_scene("res://titlescreen.tscn")


func _input(event):
	if game_is_paused():
		do_button_stuff(event)

func do_button_stuff(event):
	if event.is_action_pressed("ui_down"):
		$Panel/title_screen.grab_focus()
		$Panel/back.release_focus()
		buttonchoice = 1
	if event.is_action_pressed("ui_up"):
		$Panel/back.grab_focus()
		$Panel/title_screen.release_focus()
		buttonchoice = 0
	if event.is_action_pressed("ui_select"):
		if buttonchoice == 0:
			$Panel/back.emit_signal("pressed")
		elif buttonchoice == 1:
			$Panel/title_screen.emit_signal("pressed")

func _on_back_mouse_entered():
	$"Panel/title_screen".release_focus()
	buttonchoice = 2

func _on_title_screen_mouse_entered():
	$Panel/back.release_focus()
	buttonchoice = 2
	
func game_is_paused():
	if get_tree().paused == true:
		return true
