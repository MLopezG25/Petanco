extends Node2D

@onready var line = $Line2D
@onready var mat: ShaderMaterial
var RainScene = preload("res://Escenas/lluvia.tscn")
@onready var brush_sound1: AudioStreamPlayer = $BrushSound1
@onready var brush_sound2: AudioStreamPlayer = $BrushSound2
var active: bool = false

func add_point(p): 
	line.add_point(p)

func last_point(): 
	return line.points[-1]

func is_empty(): 
	return line.points.is_empty()

var age := 0.0

#region Edad de líneas
func _ready():
	# CAMBIO: clona el material para que cada línea tenga su propio shader
	line.material = line.material.duplicate()
	mat = line.material

func _process(delta):
	age += delta
	mat.set_shader_parameter("age", age)

	if age >= 8.0:
		queue_free()
#endregion

func add_segment(a: Vector2, b: Vector2, collision_container: Node) -> void:
	var dir = b - a
	var length = dir.length()
	var angle = dir.angle()

	#region Collider
	var body = StaticBody2D.new()
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(length, 10)
	shape.shape = rect
	shape.rotation = angle
	shape.position = a + dir * 0.5
	body.add_child(shape)
	collision_container.add_child(body)
	#endregion

	#region Activación Lluvia
	var rain = RainScene.instantiate()
	rain.position = a + dir * 0.5 + Vector2(0, 0)
	rain.rotation = 0
	add_child(rain)
	#endregion

func finalize(collision_container):
	if line.points.size() < 2:
		return

	# recorrer los puntos
	for i in range(line.points.size() - 1):
		var a = line.to_global(line.points[i])
		var b = line.to_global(line.points[i + 1])
		add_segment(a, b, collision_container)

#region Sonido
func start_sound():
	active = true
	brush_sound2.pitch_scale = randf_range(0.8, 2) # Pitch random al empezar cada iteración de línea
	brush_sound1.play()
	brush_sound2.play()

func update_pitch(velocidad_ratón: float):
	if active:
		var pitch_value = clamp(1 + velocidad_ratón * 0.01, 0.8, 2.0)
		brush_sound1.pitch_scale = pitch_value

# Fade out de sonido
func stop_sound():
	if not active:
		return
	active = false
	var tween = create_tween()
	if brush_sound1:
		tween.tween_property(brush_sound1, "volume_db", -40, 0.2)
		tween.tween_callback(Callable(brush_sound1, "stop"))
	if brush_sound2:
		tween.tween_property(brush_sound2, "volume_db", -40, 0.35)
		tween.tween_callback(Callable(brush_sound2, "stop"))
#endregion
