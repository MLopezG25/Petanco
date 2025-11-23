extends Area2D

@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var rain_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

var last_position: Vector2 = Vector2.ZERO   # CAMBIO: guardamos última posición válida

func _ready():
	rain_sound.play()
	last_position = global_position
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	# Ejemplo: tormenta se mueve hacia la derecha
	global_position.x += 200 * delta

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		# CAMBIO: activar respawn del jugador
		body.do_respawn = true

		# CAMBIO: devolver tormenta a su última posición
		global_position = last_position

func save_position():
	# CAMBIO: puedes llamar a esto cuando quieras actualizar la posición guardada
	last_position = global_position
