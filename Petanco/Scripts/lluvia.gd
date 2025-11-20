extends Node2D

@onready var lluvia: GPUParticles2D = $Lluvia

func _ready():
	lluvia.emitting = true
	add_to_group("Rain")

	await get_tree().create_timer(7.0).timeout
	lluvia.emitting = false
