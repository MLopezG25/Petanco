extends RigidBody2D
@export var max_speed: float = 3000.0
@onready var velocidad_label: Label = $CanvasLayer/VelocidadLabel #velocidad en pantallaa
@onready var explosion_particles: CPUParticles2D = $CPUParticles2D
var exploded: bool = false

func _physics_process(delta: float) -> void:
	_update_velocity_text()
	_limit_velocity()
	
func _update_velocity_text() -> void:
	var velocidad_actual = linear_velocity.length()
	velocidad_label.text = "Velocidad: " + str(round(velocidad_actual))

func _limit_velocity() -> void:
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed

# DETECCIÓN DE COLISIÓN
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if not exploded:
		for i in range(state.get_contact_count()):
			var collider = state.get_contact_collider(i)
			if collider is StaticBody2D:   # las líneas que dibujas
				_trigger_explosion()
				break

func _trigger_explosion() -> void:
	exploded = true
	explosion_particles.emitting = true
