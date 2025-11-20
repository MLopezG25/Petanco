extends Node2D

@onready var line: Line2D = $Line2D
var player: RigidBody2D
var active: bool = true

func _ready():
	line.default_color = Color.RED

func start(player_ref: RigidBody2D, mouse_pos: Vector2):
	player = player_ref
	line.clear_points()
	line.add_point(player.global_position)
	line.add_point(mouse_pos)

func update(mouse_pos: Vector2):
	if active:
		line.set_point_position(0, player.global_position)
		line.set_point_position(1, mouse_pos)

func release(mouse_pos: Vector2):
	if active:
		var dir = player.global_position - mouse_pos
		var strength = clamp(dir.length() * 5, 0, 2000)
		player.apply_central_impulse(dir.normalized() * strength)
		queue_free()
		active = false
