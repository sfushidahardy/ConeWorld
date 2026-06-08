extends Node2D

func _ready():
	$Camera2D.current = false

var tile_size = 16
func _on_player_game_over(pos):
	position = pos
	$Camera2D.current = true
	position = $Camera2D.get_camera_screen_center()
	$AnimationPlayer.play("gameover")
