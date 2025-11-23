extends Control

@onready var opciones_menu: Control = $VBoxContainer/Opciones
@onready var ajustes_menu: Control = $Control/Ajustes

func _ready():
	ajustes_menu.hide()
	opciones_menu.show()   # CAMBIO: aseguramos que el menú principal esté visible al inicio

func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/Main.tscn")

func _on_opciones_pressed() -> void:
	opciones_menu.hide() 
	ajustes_menu.show()     

func _on_salir_pressed() -> void:
	get_tree().quit()

func _on_volver_pressed() -> void:
	ajustes_menu.hide()    
	opciones_menu.show()    

func _on_musica_slider_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Música")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))

func _on_efectos_slider_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Efectos")
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
