extends Node2D
@onready var camera: Camera2D = $Camera2D
@onready var player: RigidBody2D = $Player
@onready var line_container: Node2D = $LineContainer
@onready var collision_container: Node2D = $CollisionContainer
@onready var sling_container: Node2D = $SlingContainer

func _ready():
	camera.make_current() 
func _process(delta):
	camera.position = player.global_position  #  seguir al jugador

	var speed = player.linear_velocity.length()
	var target_zoom = clamp(1.0 + speed * 0.001, 1.0, 2.0)
	var current_zoom = camera.zoom.x
	var new_zoom = lerp(current_zoom, target_zoom, 5 * delta)
	camera.zoom = Vector2(new_zoom, new_zoom)
	
var LineScene = preload("res://line_object.tscn")
var SlingScene = preload("res://slingshot.tscn")

var current_line: Node = null
var sling: Node = null
var min_point_distance: float = 1.0



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				current_line = LineScene.instantiate()
				line_container.add_child(current_line)
				current_line.add_point(_mouse())
			else:
				if current_line:
					current_line.finalize(collision_container)
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
		elif sling:
			sling.update(_mouse())

func _mouse() -> Vector2:
	return get_viewport().get_camera_2d().get_global_mouse_position()
