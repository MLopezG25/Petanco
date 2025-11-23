extends RigidBody2D
@export var max_speed: float = 3000.0
var exploded: bool = false
var last_checkpoint: Vector2 = Vector2.ZERO   # Posición de último checkpoint
var do_respawn: bool = false

func _physics_process(delta: float) -> void:
	_limit_velocity()
	if linear_velocity.length() < 0.001:
		linear_velocity = Vector2(0.001, 0).rotated(randf() * TAU) #empujón necesario para físicas
	if Input.is_action_just_pressed("respawn"):
		if last_checkpoint != Vector2.ZERO:
			do_respawn = true
func _limit_velocity() -> void:
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed

# DETECCIÓN DE COLISIÓN
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if not exploded:
		for i in range(state.get_contact_count()):
			var collider = state.get_contact_collider(i)
			if collider  and is_instance_valid(collider) and collider is StaticBody2D:
				_trigger_explosion()
				break
	if do_respawn:
		state.transform.origin = last_checkpoint   # CAMBIO: mover con el motor de físicas
		state.linear_velocity = Vector2.ZERO       # CAMBIO: reset velocidad
		state.angular_velocity = 0.0               # CAMBIO: reset rotación
		do_respawn = false                         # CAMBIO: limpiar flag
		
func _trigger_explosion() -> void:
	exploded = true
