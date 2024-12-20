extends CharacterBody2D

# Enemy notes:
# dormant when not on screen
# is triggered by player proximity to start 'phantoming'
# i.e., phasing in and firing maser cannon at player
# then phasing out
# is only vulnerable whilst phasing

var phased_out = true
var time_to_next_phase_in = 4.0 # time in seconds to next appearance on map
@onready var phase_timer = $PhaseTimer
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var the_player = get_tree().get_nodes_in_group("player")[0]

var enemy_speed = 20
var target_position
var rotation_speed = 0.1
var this_enemy_shot := 0
var this_enemy_killed_at := 3
var this_enemy_onscreen = false
var player_in_range = false
var extinction_triggered = false
var extinction_timer_value = 2
var distance_from_player

# Called when the node enters the scene tree for the first time.
func _ready():
	# start with sprite invisible
	sprite.modulate.a = 0.0
	# create tween to fade in sprite after X seconds	
	phase_timer.start()
	
func _physics_process(delta):
	#if $"/root/Global".smart_bomb_active and this_enemy_onscreen:
		#_on_extinction_timer_timeout()
	rotation_degrees += rotation_speed
	var direction = global_position.direction_to(the_player.global_position)
	velocity = direction * enemy_speed * delta
	move_and_collide(velocity)
	
	if player_in_range and rotation_speed < 4:
		rotation_speed += 0.1			
	
	var collided := move_and_collide(velocity * delta)
	if collided and rotation_speed <= 4:
		rotation_speed += 0.25
		
	var player_position = the_player.global_position
	var mine_position = global_transform.origin
	#distance_from_player = player_position.distance_to(mine_position)
	#if distance_from_player < 300 and !player_in_range:
		#player_in_range = true
		#rotation_speed += 3
	#if distance_from_player >= 300 and player_in_range:
		#player_in_range = false
		#rotation_speed = 0.1
	#if distance_from_player < 150 and !extinction_triggered:
		#extinction_triggered = true
		#$ExtinctionTimer.wait_time = extinction_timer_value
		#rotation_speed += 6
		#enemy_speed = 150
		#$ExtinctionTimer.start()
	
	
func fade_in():
	# create Tween object
	var tween = get_tree().create_tween()
	# Fade in the sprite by tweening the alpha value of its modulate property
	tween.tween_property(
		sprite, 
		"modulate:a", 
		1.0,       # Target alpha value
		5.0,       # Duration in seconds
		).set_ease(Tween.EASE_IN_OUT)
	phased_out = false
	phase_timer.start()
	
func fade_out():
	# create Tween object
	var tween = get_tree().create_tween()
	# Tween the alpha value back to 0
	tween.tween_property(
		sprite, 
		"modulate:a", 
		0.0,  # Target alpha
		5.0   # Duration in seconds
		).set_ease(Tween.EASE_IN_OUT)
	phased_out = true
	phase_timer.start()


func _on_phase_timer_timeout():
	if phased_out:
		fade_in()
	else:
		fade_out()
		

func start_shimmer():
	# Create a Tween for scaling
	var scale_tween = get_tree().create_tween()
	scale_tween.tween_property(sprite, "scale", Vector2(1.1, 1.1), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	scale_tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	scale_tween.set_loops()
	
	# Create a Tween for modulate property
	var modulate_tween = get_tree().create_tween()
	modulate_tween.tween_property(sprite, "modulate", Color(1.2, 1.2, 1.2), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	modulate_tween.tween_property(sprite, "modulate", Color(1.0, 1.0, 1.0), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	modulate_tween.set_loops()
