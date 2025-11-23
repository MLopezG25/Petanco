extends CanvasLayer

@onready var pause_audio: AudioStreamPlayer = $"SonidoMenú"

func _ready():
	hide()   # el menú empieza oculto

func _input(event):
	if event.is_action_pressed("ui_cancel"): 
		visible = not visible
		get_tree().paused = visible
		if visible:
			pause_audio.play()   
		else:
			pause_audio.stop()   
func _on_reanudar_pressed() -> void:
	hide()
	get_tree().paused = false
	if visible:
		pause_audio.play()   
	else:
		pause_audio.stop() 
func _on_reiniciar_pressed() -> void:
	get_tree().paused = false   
	get_tree().reload_current_scene()

func _on_salir_al_menú_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Escenas/menu_principal.tscn")



func _on_opciones_pressed() -> void:
	pass # Replace with function body.
