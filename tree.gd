extends Node2D

@export var life: int = 10

func being_mined():
	life -= 1
	
func _process(delta: float) -> void:
	if not life:
		self.queue_free()
