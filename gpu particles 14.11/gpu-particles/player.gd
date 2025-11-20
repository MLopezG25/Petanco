extends RigidBody2D

@export var move_force: float = 400.0
@export var jump_impulse: float = 800.0
@export var max_speed: float = 1200.0

@onready var explosion_particles: CPUParticles2D = $CPUParticles2D
var exploded: bool = false

func _physics_process(delta: float) -> void:
	_handle_move()
	_handle_restart()

func _handle_move() -> void:
	if Input.is_action_pressed("ui_left"):
		apply_central_force(Vector2(-move_force, 0))
	if Input.is_action_pressed("ui_right"):
		apply_central_force(Vector2(move_force, 0))

	if abs(linear_velocity.x) > max_speed:
		linear_velocity.x = sign(linear_velocity.x) * max_speed

	if Input.is_action_just_pressed("ui_up"):
		apply_central_impulse(Vector2(0, -jump_impulse))

func _handle_restart() -> void:
	if Input.is_action_just_pressed("restart"):
		global_position = Vector2(0, 0)
		linear_velocity = Vector2.ZERO
		angular_velocity = 0.0
		rotation = 0.0
		exploded = false
		explosion_particles.emitting = false

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
