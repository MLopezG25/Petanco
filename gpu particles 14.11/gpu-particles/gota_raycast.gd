extends Node2D

@onready var ray = $RayCast2D

func _process(delta):
	if ray.is_colliding():
		var splash = SplashScene.instantiate()
		splash.position = ray.get_collision_point()
		get_parent().add_child(splash)
		queue_free()

func _on_Timer_timeout():
	queue_free()
