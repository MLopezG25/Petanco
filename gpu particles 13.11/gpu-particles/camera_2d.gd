extends Camera2D

@export var player: RigidBody2D
@export var min_zoom: Vector2 = Vector2(1, 1)   # zoom normal
@export var max_zoom: Vector2 = Vector2(2, 2)   # zoom alejado
@export var max_speed: float = 1200.0           # velocidad máxima del jugador

func _process(delta: float) -> void:
	if player:
		var speed = player.linear_velocity.length()
		# Normalizar velocidad entre 0 y 1
		var t = clamp(speed / max_speed, 0.0, 1.0)
		# Interpolar entre min_zoom y max_zoom
		zoom = min_zoom.lerp(max_zoom, t)
