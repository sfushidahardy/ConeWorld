extends KinematicBody2D

var screen_size = Vector2(800,400)
signal send_attack(pos,posduplicate)

var tile_size = 16
onready var ray = $RayCast2D
onready var tween = $Tween
export var speed = 6

var previous_direction = Vector2.DOWN

func _ready():
	randomize()
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	$AnimatedSprite.play("default")

func move_tween(direction):
	if direction.x < 0:
		$AnimatedSprite.play("left")
		$Timer.start()
	elif direction.x > 0:
		$AnimatedSprite.play("right")
		$Timer.start()
	var newposition = position + direction*tile_size
	tween.interpolate_property(self, "position", position, newposition, 1.0/speed, $Tween.TRANS_SINE, $Tween.EASE_IN_OUT)
	emit_signal("send_attack", newposition, newposition+position)
	previous_direction = direction
	tween.start()

func _on_player_did_a_move(_position):
	choose_a_valid_move(_position)
	
func choose_a_valid_move(_position):
	if tween.is_active():
		return
	var rotationmatrix = Transform2D()
	rotationmatrix[0] = Vector2(0,1)
	rotationmatrix[1] = Vector2(-1,0)
	rotationmatrix[2] = Vector2(0,0)
	var rotate_once = rotationmatrix * previous_direction
	var rotate_twice = rotationmatrix * rotate_once
	ray.cast_to = previous_direction * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding() and within_bounds(previous_direction):
		move_tween(previous_direction)
	else:
		ray.cast_to = rotate_once * tile_size
		ray.force_raycast_update()
		if !ray.is_colliding() and within_bounds(rotate_once):
			move_tween(rotate_once)
		else:
			ray.cast_to = rotate_twice * tile_size
			ray.force_raycast_update()
			if !ray.is_colliding() and within_bounds(rotate_twice):
				move_tween(rotate_twice)
			else:
				queue_free()
	
func within_bounds(direction):
	var newpos = position + direction*tile_size
	if newpos.x >= tile_size/2 and newpos.x <= screen_size.x - tile_size/2 and newpos.y >= tile_size/2-1 and newpos.y <= screen_size.y - tile_size/2:
		return true
	else:
		return false


func _on_Timer_timeout():
	$AnimatedSprite.play("default")
