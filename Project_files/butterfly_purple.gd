extends KinematicBody2D

var screen_size = Vector2(800,400)

signal caught_a_butterfly

var tile_size = 16
onready var ray = $RayCast2D
onready var tween = $Tween
export var speed = 5

func _ready():
	randomize()
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	$AnimatedSprite.play("default")
	
func move(random_direction):
	ray.cast_to = random_direction * tile_size
	#var col = ray.get_collider()
	#if col is KinematicBody2D:
	#	ray.add_exception(col)
	ray.force_raycast_update()
	if !ray.is_colliding():
		move_tween(random_direction)

func move_tween(random_direction):
	var newposition = position + random_direction*tile_size
	newposition.x = clamp(newposition.x, tile_size/2, screen_size.x - tile_size/2)
	newposition.y = clamp(newposition.y, tile_size/2, screen_size.y - tile_size/2)
	tween.interpolate_property(self, "position", position, newposition, 1.0/speed, $Tween.TRANS_SINE, $Tween.EASE_IN_OUT)
	tween.start()

func _on_player_did_a_move(_position):
	choose_a_valid_move(_position)
	
func choose_a_valid_move(_position):
	if tween.is_active():
		return
	var possible_directions = []
	var potential_directions = [Vector2.ZERO,Vector2.RIGHT,Vector2.LEFT,Vector2.UP,Vector2.DOWN]
	for dir in potential_directions:
		ray.cast_to = dir * tile_size
		ray.force_raycast_update()
		if !ray.is_colliding() and within_bounds(dir):
			possible_directions.append(dir)
	if possible_directions.size() == 0:
		queue_free() #kill a dude if literally cannot move
	else:
		var random_direction = possible_directions[randi() % possible_directions.size()]
		move(random_direction)
	
func _on_player_used_bug_net(attackposition, pos):
	if attackposition == position or pos == position:
		$"/root/global".level_butterfly_count += 1
		emit_signal("caught_a_butterfly")
		queue_free()
	else:
		pass
	
func within_bounds(direction):
	var newpos = position + direction*tile_size
	if newpos.x >= tile_size/2 and newpos.x <= screen_size.x - tile_size/2 and newpos.y >= tile_size/2 and newpos.y <= screen_size.y - tile_size/2:
		return true
	else:
		return false
