extends CanvasLayer

#@onready var energy_bar = $Control/EnergyBar

var warning_showing = false
var warning_times = 0

var basic_damage = 10

var energy_is_low = false

# Called when the node enters the scene tree for the first time.
func _ready():
	%EnergyBar.value = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func show_warning():
	warning_showing = true
	$warning.visible = true
	$WarningTimer.start()
	

func show_velocity(x, y, delta):
	var combined_velocity = x * y * delta
	if combined_velocity < 0:
		combined_velocity = -combined_velocity
	$velocity/Label.text = str(snapped(combined_velocity, 0.1))
	
func show_energy(energy):
	$energy/Label.text = str(energy)

func _on_warning_timer_timeout():
	warning_times += 1
	if warning_times <= 6:
		$WarningTimer.start()
		if $warning.visible:
			$warning.visible = false
		else:
			$warning.visible = true
	else:
		$warning.visible = false
		return


func _on_player_energy_change(energy):
	%EnergyBar.value = energy
	if energy <= 15 and !energy_is_low:
		energy_is_low = true
		%LowEnergy.play("low_energy")
	if energy > 15 and energy_is_low:
		energy_is_low = false
		%LowEnergy.play("RESET")
