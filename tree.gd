extends Sprite2D

@export var life: int = 15


var resource_type = Globals.resource_types.WOOD


func set_type(entity_key):
	match entity_key:
		"tree":
			resource_type = Globals.resource_types.WOOD
			
			match Globals.current_level:
				Globals.levels.GOBLINS:
					frame = 0
				Globals.levels.ROBOTS:
					frame = 1
		"gold":
			resource_type = Globals.resource_types.GOLD
			frame = 2


func mine():
	if !$AnimationPlayer.is_playing():
		life -= 1
		$AnimationPlayer.play("Hurt")


func _process(delta: float) -> void:
	if life <= 0 and !$AnimationPlayer.is_playing():
		self.queue_free()
