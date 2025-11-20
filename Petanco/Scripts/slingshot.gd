extends Node2D
@onready var line = $Line2D
var player

func start(p, mouse_pos):
	player = p
	line.clear_points()
	line.add_point(player.global_position)
	line.add_point(mouse_pos)

func update(mouse_pos):
	line.set_point_position(0, player.global_position)
	line.set_point_position(1, mouse_pos)

func release(mouse_pos):
	var dir = player.global_position - mouse_pos
	var force = clamp(dir.length() * 5, 0, 20000)
	player.apply_central_impulse(dir.normalized() * force)
	queue_free()
