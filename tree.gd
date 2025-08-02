extends Sprite2D

@export var life: int = 5


func _ready() -> void:
	match Globals.current_level:
		Globals.levels.GOBLINS:
			frame = 0
		Globals.levels.ROBOTS:
			frame = 1
		


func being_mined():
	life -= 1
	$AnimationPlayer.play("Hurt")


func _process(delta: float) -> void:
	if life <= 0 and !$AnimationPlayer.is_playing():
		self.queue_free()
