extends Node2D

@export var mouse_over: bool = false
	
func _on_area_2d_mouse_shape_entered(shape_idx: int) -> void:
	mouse_over = true

func _on_area_2d_mouse_shape_exited(shape_idx: int) -> void:
	mouse_over = false
