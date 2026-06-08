extends KinematicBody2D

var screen_size = Vector2(800,400)
signal send_chonky_attack(bottom_left_corner)

var tile_size = 16
export var speed = 5
export var initial_position = Vector2(34,14)

var movecount = -1
var drop_location = Vector2.ZERO
var old_pos = Vector2.ZERO

func _ready():
	randomize()
	position = initial_position*tile_size
	$AnimatedSprite.play("default")
	$shadow_sprite.show()
	
func circle_of_positions(radius, center):
	var possible_positions = []
	var diameter = range(-radius, radius)
	for vector_x in diameter:
		for vector_y in diameter:
			if pow(vector_x, 2) + pow(vector_y, 2) <= pow(radius, 2):
				possible_positions.append(Vector2(vector_x,vector_y))
	for n in len(possible_positions):
		possible_positions[n] += center
	return possible_positions

func _on_player_did_a_move(pos):
	movecount += 1
	if movecount % 3 == 0:
		choose_new_position(pos)
	elif movecount % 3 == 1:
		grow_shadow(drop_location)
	elif movecount % 3 == 2:
		drop_to_position()
		emit_signal("send_chonky_attack", drop_location)
	
func choose_new_position(pos):
	var possible_positions = circle_of_positions(6,initial_position)
	var player_pos = (pos + Vector2(-1,1)*tile_size/2)/tile_size
	var closest_place_to_player = Vector2(0,0)
	var min_distance_to_player = 1000
	for places in possible_positions:
		var distance_to_player = sqrt(pow(places.x - player_pos.x, 2) + pow(places.y - player_pos.y, 2))
		if distance_to_player <= min_distance_to_player:
			closest_place_to_player = places
			min_distance_to_player = distance_to_player
	var refined_positions = circle_of_positions(2, closest_place_to_player - Vector2(1,-1))
	refined_positions.append_array(circle_of_positions(1, closest_place_to_player - Vector2(1,-1)))
	var random_position = refined_positions[randi() % refined_positions.size()]
	drop_location = random_position
	old_pos = position
	position = drop_location*tile_size
	$AnimatedSprite.position = old_pos - position
	$shadow_sprite.position = old_pos - position
	jump_diagonally_up(old_pos)
	move_shadow_to_position(old_pos)

func grow_shadow(drop_loc):
	$shadow_tween2.interpolate_property($shadow_sprite, "scale", Vector2(0.5,0.5), Vector2(1,1), 0.2, Tween.TRANS_LINEAR)
	$shadow_tween2.start()
	$shadow_tween.interpolate_property($shadow_sprite, "position", Vector2(32,-16)*(1-0.5), Vector2.ZERO, 0.2, $shadow_tween.TRANS_LINEAR)
	$shadow_tween.start()
	pass
	
func drop_to_position():
	$sprite_tween.interpolate_property($AnimatedSprite, "position", Vector2(0,-6)*tile_size, Vector2(0,0), 0.2, $sprite_tween.TRANS_LINEAR)
	$sprite_tween.start()
	$shadow_sprite.position = Vector2(0,0)
	$sprite_fade_tween.interpolate_property($AnimatedSprite, "modulate", 
	  Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.2, 
	  Tween.TRANS_LINEAR)
	$sprite_fade_tween.start()
	pass

func jump_diagonally_up(pos):
	$sprite_tween.interpolate_property($AnimatedSprite, "position", pos - position, Vector2(0,-6)*tile_size , 0.2, $sprite_tween.TRANS_LINEAR)
	$sprite_tween.start()
	$sprite_fade_tween.interpolate_property($AnimatedSprite, "modulate", 
	  Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.2, 
	  Tween.TRANS_LINEAR)
	$sprite_fade_tween.start()
	
func move_shadow_to_position(pos):
	$shadow_tween.interpolate_property($shadow_sprite, "position", pos - position, Vector2(32,-16)*(1-0.5), 0.2, $shadow_tween.TRANS_LINEAR)
	$shadow_tween2.interpolate_property($shadow_sprite, "scale", Vector2(1,1), Vector2(0.5,0.5), 0.2, Tween.TRANS_LINEAR)
	$shadow_tween.start()
	$shadow_tween2.start()
	pass
