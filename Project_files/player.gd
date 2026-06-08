extends Area2D

signal do_a_move(position)
signal use_bugnet(attackposition, position)
signal game_over(pos)
signal next_level
signal restart_level

var screen_size = Vector2(800,400)
var tile_size = 16
var inputs = {"ui_right": Vector2.RIGHT,
			"ui_left": Vector2.LEFT,
			"ui_up": Vector2.UP,
			"ui_down": Vector2.DOWN}
			
onready var ray = $RayCast2D
onready var tween = $Tween
export var speed = 5
var hitbox_position
var overlap_position

var attack_direction = Vector2.RIGHT
var is_attack_cooleddown = 1

enum{
	alive
	dead
}
var state = alive

func _ready():
	randomize()
	if $"/root/global".level_count == 0: 
		position = position.snapped(Vector2.ONE * tile_size)
		position += Vector2.ONE * tile_size/2
	else:
		position = $"/root/global".transition_coordinates
	$AnimatedSprite.play("default")

func _physics_process(delta):
	if state == alive:
		if tween.is_active() or is_attack_cooleddown == 0:
			return
		for dir in inputs.keys():
			if Input.is_action_pressed("attack"):
				determineattack()
			elif Input.is_action_pressed(dir):
				$animationtimer.start()
				if inputs[dir].x != 0:
					$AnimatedSprite.animation = "rightwalk"
					$AnimatedSprite.flip_h = inputs[dir].x < 0
				elif inputs[dir].y != 0: 
					$AnimatedSprite.animation = "downwalk"
				attack_direction = inputs[dir]
				move(dir)
func _unhandled_input(event):
	if state == alive:
		if tween.is_active() or is_attack_cooleddown == 0:
			return
		for dir in inputs.keys():
			if event.is_action_pressed("attack"):
				determineattack()
			elif event.is_action_pressed(dir):
				$animationtimer.start()
				if inputs[dir].x != 0:
					$AnimatedSprite.animation = "rightwalk"
					$AnimatedSprite.flip_h = inputs[dir].x < 0
				elif inputs[dir].y != 0: 
					$AnimatedSprite.animation = "downwalk"
				attack_direction = inputs[dir]
				move(dir)

func determineattack():
	if is_attack_cooleddown == 0:
		return
	is_attack_cooleddown = 0
	$animationtimer.start()
	$attackcooldown.start()
	if attack_direction.x != 0:
		$AnimatedSprite.animation = "attack_right"
		$AnimatedSprite.flip_h = attack_direction.x < 0
	elif attack_direction == Vector2.DOWN:
		$AnimatedSprite.animation = "attack_down"
	elif attack_direction == Vector2.UP:
		$AnimatedSprite.animation = "attack_up"
	emit_signal("use_bugnet", position + attack_direction*tile_size, position)
	play_random_swoosh()

func play_random_swoosh():
	var n = randi() % 4 + 1
	if n == 1:
		$Node2D/swoosh1.play()
	elif n == 2:
		$Node2D/swoosh2.play()
	elif n == 3:
		$Node2D/swoosh3.play()
	elif n == 4:
		$Node2D/swoosh4.play()
func move(dir):
	ray.cast_to = inputs[dir] * tile_size
	var col = ray.get_collider()
	if col is PhysicsBody2D:
		ray.add_exception(col)
	ray.force_raycast_update()
	if !ray.is_colliding() and within_range(dir) == 1:
		move_tween(dir)

func within_range(dir):
	var newposition = position + inputs[dir]*tile_size
	if newposition.x >= tile_size/2 and newposition.x <= screen_size.x + tile_size/2 and newposition.y >= tile_size/2 and newposition.y <= screen_size.y - tile_size/2:
		return 1
	else:
		return 0
func move_tween(dir):
	var newposition = position + inputs[dir]*tile_size
	tween.interpolate_property(self, "position", position, newposition, 1.0/speed, $Tween.TRANS_SINE, $Tween.EASE_IN_OUT)
	hitbox_position = newposition
	overlap_position = position+newposition
	emit_signal("do_a_move", newposition)
	if newposition.x == screen_size.x + tile_size/2:
		$"/root/global".total_butterfly_count += $"/root/global".level_butterfly_count
		$"/root/global".level_butterfly_count = 0
		$"/root/global".transition_coordinates = Vector2(newposition.x - screen_size.x, newposition.y)
		$"/root/global".level_count += 1
		emit_signal("next_level")
		autosave()
	else:
		tween.start()

func autosave():
	var data = savedata.new()
	data.total_butterfly_count = $"/root/global".total_butterfly_count
	data.death_count = $"/root/global".death_count
	data.level_count = $"/root/global".level_count
	data.level_starting_coordinates = $"/root/global".transition_coordinates
	ResourceSaver.save("user://save_data.tres", data)

func _on_animationtimer_timeout():
	$AnimatedSprite.animation = "default"

func _on_attackcooldown_timeout():
	is_attack_cooleddown = 1

func _on_send_attack(pos,overlap_pos):
	if pos == hitbox_position or overlap_pos == overlap_position:
		state = dead
		$"/root/global".level_butterfly_count = 0
		$"/root/global".death_count += 1
		death_animation()
		game_over_sequence()
		
func _on_send_chonky_attack(bottom_left_corner):
	var adjusted_corner = bottom_left_corner * tile_size + Vector2(1,-1)*tile_size / 2
	var all_the_dangerous_regions = []
	for x in 4:
		for y in 2:
			all_the_dangerous_regions.append(adjusted_corner + Vector2(x,-y)*tile_size)
	if all_the_dangerous_regions.has(hitbox_position):
		state = dead
		$"/root/global".level_butterfly_count = 0
		$"/root/global".death_count += 1
		death_animation()
		game_over_sequence()
	
func death_animation():
	$animationtimer.stop()
	$AnimatedSprite.animation = "death"

func game_over_sequence():
	$gameovertimer.start()
	emit_signal("game_over", hitbox_position)
	$Camera2D.current = false

func _on_gameovertimer_timeout():
	emit_signal("restart_level")
