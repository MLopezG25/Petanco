extends Node2D

@onready var explosion: CPUParticles2D = $CPUParticles2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"): # espacio
		explosion.restart()   # reinicia el sistema de partículas
		explosion.emitting = true
