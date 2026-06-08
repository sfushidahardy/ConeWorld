extends Node2D

func _ready():
	pass # Replace with function body.

func _on_player_next_level():
	get_tree().change_scene("res://Map1.tscn")

func _on_player_restart_level():
	get_tree().change_scene("res://Map0.tscn")

func _on_player_game_over(_pos):
	$HUD/pause_button.hide()
	$HUD/Sprite.hide()
	$HUD/Label.hide()
