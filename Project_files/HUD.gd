extends CanvasLayer


func _ready():
	$Label.text = str($"/root/global".total_butterfly_count + $"/root/global".level_butterfly_count)
	
func update_butterfly_count():
	$Label.text = str($"/root/global".total_butterfly_count + $"/root/global".level_butterfly_count)

func _on_pause_button_pressed():
	get_tree().paused = true
	$pause_screen.show()

func _on_pause_screen_unpause():
	$pause_screen.hide()
	get_tree().paused = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		$pause_button.emit_signal("pressed")
