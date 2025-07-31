extends Node2D


func _ready() -> void:
	window()


func window():
	var size = Vector2i(640, 360) * 2
	get_window().size = size
	get_window().move_to_center()
