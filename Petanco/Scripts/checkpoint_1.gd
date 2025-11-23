extends Area2D

func _on_body_entered(body: Node) -> void:
	if body is RigidBody2D and body.name == "Player":
		body.last_checkpoint = global_position
		print("Checkpoint activado en: ", global_position)
