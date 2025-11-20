extends Node2D

@onready var line: Line2D = $Line2D
var colliders: Array = []
var age: float = 0.0

func _ready():
	line.width = 6
	var mat = ShaderMaterial.new()
	mat.shader = preload("res://line_heat.gdshader")
	line.material = mat

func add_point(world_pos: Vector2):
	line.add_point(line.to_local(world_pos))

func is_empty() -> bool:
	return line.points.is_empty()

func last_point() -> Vector2:
	return line.to_global(line.points[-1])

func finalize(collision_container: Node):
	if line.points.size() < 2:
		return
	for i in range(line.points.size() - 1):
		var a_global = line.to_global(line.points[i])
		var b_global = line.to_global(line.points[i + 1])
		var segment = StaticBody2D.new()
		var shape = CollisionShape2D.new()
		var seg_shape = SegmentShape2D.new()
		seg_shape.a = a_global
		seg_shape.b = b_global
		shape.shape = seg_shape
		segment.add_child(shape)
		collision_container.add_child(segment)
		colliders.append(segment)

func _process(delta: float):
	age += delta
	var mat = line.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("age", age)

	if age >= 8.0:
		for c in colliders:
			if is_instance_valid(c):
				c.queue_free()
		colliders.clear()
		queue_free()
