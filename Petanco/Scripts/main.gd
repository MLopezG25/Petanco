extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var player: RigidBody2D = $Player
@onready var line_container: Node2D = $LineContainer
@onready var collision_container: Node2D = $CollisionContainer
@onready var sling_container: Node2D = $SlingContainer
@onready var velocidad_label: Label = $CanvasLayer/VelocidadLabel
@onready var tiempo_label: Label = $CanvasLayer/TiempoLabel
var active_lines: int = 0
var rain_count: int = 0
var LineScene = preload("res://Escenas/line_object.tscn")
var SlingScene = preload("res://Escenas/slingshot.tscn")
var current_line: Node = null
var sling: Node = null
var min_point_distance: float = 1.0
var last_speed: float = 0.0
var tiempo_total: float = 0.0

func _physics_process(delta: float) -> void:
	tiempo_total += delta
	_update_velocity_text()
	_update_time_text()

func _update_velocity_text() -> void:
	var velocidad_actual = player.linear_velocity.length()
	velocidad_label.text = "Velocidad: " + str(round(velocidad_actual))

func _update_time_text() -> void:
	tiempo_label.text = "Tiempo: %.1f s" % tiempo_total
	var mat = tiempo_label.material
	if mat and mat is ShaderMaterial:
		mat.set_shader_parameter("tiempo", tiempo_total)

#region Cámara
func _ready():
	camera.make_current()

func _process(delta):
	camera.position = player.global_position

	# Explosión si el trigger es por cambio brusco
	var current_speed = player.linear_velocity.length()
	var speed_change = abs(current_speed - last_speed)
	last_speed = current_speed

	# Zoom dinámico según velocidad
	var speed = player.linear_velocity.length()
	var target_zoom = clamp(2.0 - speed * 0.001, 0.6, 0.9)
	var current_zoom = camera.zoom.x
	var new_zoom = lerp(current_zoom, target_zoom, 5 * delta)
	camera.zoom = Vector2(new_zoom, new_zoom)

	# Shake si hay choque o velocidad alta
	speed_change = abs(speed - last_speed)
	if speed_change > 600 or speed > 1000:
		var shake = 0.0015 * speed
		camera.offset = Vector2(randf_range(-shake, shake), randf_range(-shake, shake))

	# Guardar velocidad para el próximo frame
	last_speed = speed
#endregion

#region Input principal
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Crear nueva línea
				current_line = LineScene.instantiate()
				line_container.add_child(current_line)
				current_line.add_point(_mouse())
				current_line.start_sound()   # sonido propio de la línea
			else:
				if current_line:
					current_line.finalize(collision_container)
					current_line.stop_sound()   # fade out de esa línea
					current_line = null

		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				sling = SlingScene.instantiate()
				sling_container.add_child(sling)
				sling.start(player, _mouse())
			else:
				if sling:
					sling.release(_mouse())
					sling = null

	elif event is InputEventMouseMotion:
		if current_line:
			var p = _mouse()
			if current_line.is_empty() or current_line.last_point().distance_to(p) >= min_point_distance:
				var last = current_line.last_point()
				current_line.add_point(p)
				if not current_line.is_empty():
					current_line.add_segment(current_line.to_global(last), current_line.to_global(p), collision_container)
				current_line.update_pitch(p.distance_to(last))   # modula pitch de esa línea
		elif sling:
			sling.update(_mouse())

func _mouse() -> Vector2:
	return get_viewport().get_camera_2d().get_global_mouse_position()
#endregion
