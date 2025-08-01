extends Node2D

@export var life: int = 10

func being_mined():
	life -= 1
	
func _process(delta: float) -> void:
	if life <= 0:
		self.queue_free()
