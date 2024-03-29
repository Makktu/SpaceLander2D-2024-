extends Node2D

@onready var thrust_start = %thrust_sound_start
@onready var thrust_mid = %thrust_sound_mid
@onready var thrust_end = %thrust_sound_end
@onready var thrust_flames = %thrust_flames

var player_is_thrusting = false
var thrusting_for = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func thrust_pressed():
	if thrusting_for == 50:
		print(thrusting_for)
		$"../Camera2D".thrust_shaking = true
		$"../Camera2D".shake_camera(1.8, 2)
	if !player_is_thrusting:	
		player_is_thrusting = true
		#thrust_mid.play()
		%thrust_flames.visible = true
		$thrust_flames.play()
	thrusting_for += 1
	

func thrust_released():
		$"../Camera2D".shake_camera(0, 0)
		thrusting_for = 0
		$"../Camera2D".thrust_shaking = false
		player_is_thrusting = false
		%thrust_sound_start.stop()
		%thrust_sound_mid.stop()
		#%thrust_sound_end.play()
		%thrust_flames.visible = false
		%thrust_flames.stop()
