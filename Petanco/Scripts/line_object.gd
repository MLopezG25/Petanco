extends Node2D
@onready var line = $Line2D
var RainScene = preload("res:///Escenas/lluvia.tscn")

func add_point(p): line.add_point(p)
func last_point(): return line.points[-1]
func is_empty(): return line.points.is_empty()

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

#region Activación LLuvia
	var rain = RainScene.instantiate()
	rain.position = a + dir * 0.5 + Vector2(0, 0)  # justo debajo
	rain.rotation = 0  # asegura que caiga hacia abajo
	add_child(rain)

func finalize(collision_container):
	if line.points.size() < 2:
		return

	for i in line.points.size() - 1:
		var a = line.to_global(line.points[i])
		var b = line.to_global(line.points[i + 1])
		add_segment(a, b, collision_container)
#endregion
