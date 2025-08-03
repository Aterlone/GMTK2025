extends Node2D


var is_grunt = true

var targetWagon = null

func _ready() -> void:
	$AnimationPlayer.play("Walk")
	$AttackDelay.connect("timeout", timeout)


func getNearestWagon():
	var wagon_positions = {}
	for entity in Globals.MAIN.ENTITIES.get_children():
		if entity.name.contains("wagon"):
			wagon_positions[entity.global_position.distance_to(global_position)] = entity
	
	if wagon_positions.size() <= 0:
		return
	
	var keys = wagon_positions.keys()
	keys.sort()
	targetWagon = wagon_positions[keys[0]]


func hurt():
	Globals.stats["enemiesSlain"] += 1
	queue_free()


func _physics_process(delta: float) -> void:
	
	
	getNearestWagon()
	
	if targetWagon == null:
		return
	
	$Pointer.look_at(targetWagon.global_position)
	
	var speed = 0.2
	
	if targetWagon.global_position.distance_to(global_position) < 16:
		return
	
	global_position += speed * Vector2(
		cos($Pointer.rotation),
		sin($Pointer.rotation),
		)


func timeout():
	if targetWagon == null:
		return
	
	if targetWagon.global_position.distance_to(global_position) < 16:
		targetWagon.hurt()
