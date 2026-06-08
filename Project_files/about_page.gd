extends Node2D

func _ready():
	pass # Replace with function body.
	
func _on_TextureButton_pressed():
	get_tree().change_scene("res://titlescreen.tscn")
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_down") or event.is_action_pressed("ui_up"):
		$TextureButton.grab_focus()
