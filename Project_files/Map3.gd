extends Node2D

func _ready():
	pass # Replace with function body.

func _on_player_next_level():
	get_tree().change_scene("res://Map4.tscn")


func _on_player_restart_level():
	get_tree().change_scene("res://Map3.tscn")
