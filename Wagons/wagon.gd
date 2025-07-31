extends Node2D

@export var mouse_over: bool = false

func _ready() -> void:
	$Control.connect("mouse_entered", set_mouse.bind(true))
	$Control.connect("mouse_exited", set_mouse.bind(false))


func set_mouse(overlapping : bool):
	mouse_over = overlapping


func _physics_process(delta: float) -> void:
	pass
	#if mouse_over:
		#$ColorRect.modulate = Color.GREEN
	#else:
		#$ColorRect.modulate = Color.RED
