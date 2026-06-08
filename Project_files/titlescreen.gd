extends Node2D

func _ready():
	buttonchoice = 2

var buttonchoice = 2

func _input(event):
	if event.is_action_pressed("ui_down"):
		$Control/TextureButton2.grab_focus()
		$Control/TextureButton.release_focus()
		buttonchoice = 1
	if event.is_action_pressed("ui_up"):
		$Control/TextureButton.grab_focus()
		$Control/TextureButton2.release_focus()
		buttonchoice = 0
	if event.is_action_pressed("ui_select"):
		if buttonchoice == 0:
			$Control/TextureButton.emit_signal("pressed")
		elif buttonchoice == 1:
			$Control/TextureButton2.emit_signal("pressed")

func _on_TextureButton_pressed():
	get_tree().change_scene("res://play_game.tscn")

func _on_TextureButton2_pressed():
	get_tree().change_scene("res://about_page.tscn")

func _on_TextureButton_mouse_entered():
	$Control/TextureButton2.release_focus()
	buttonchoice = 2

func _on_TextureButton2_mouse_entered():
	$Control/TextureButton.release_focus()
	buttonchoice = 2
