extends Node2D

@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var main := get_node("/root/Main")

func _process(delta):
	var speed = main.player.linear_velocity.length()
	var speed_change = abs(speed - main.last_speed)

	if speed_change > 600:
		particles.emitting = true
