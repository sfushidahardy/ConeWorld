extends Node2D

func _ready():
	$buttcount.text = str($"/root/global".total_butterfly_count)
	$deathcount.text = str($"/root/global".death_count)
	$scorecount.text = str($"/root/global".total_butterfly_count - $"/root/global".death_count)

func _on_backbutton_pressed():
	get_tree().change_scene("res://titlescreen.tscn")
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_down") or event.is_action_pressed("ui_up"):
		$backbutton.grab_focus()
	if event.is_action_pressed("ui_select"):
		$backbutton.emit_signal("pressed")


