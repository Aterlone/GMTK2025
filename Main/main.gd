extends Node2D


var SPAWNER;
var ENTITIES;

var clock = 0

var trees_being_mined = []

func _ready() -> void:
	window()
	
	create_level()


func create_level():
	var wagons = []
	for level in $LevelContainer.get_children():
		for nodes in level.get_children():
			for child in nodes.get_children():
				if child.name.contains("wagon"):
					wagons.append(child.duplicate())
		level.queue_free()

	var level_entity = load("res://Level/level.tscn").instantiate()
	get_child(1).add_child(level_entity)
	
	
	SPAWNER = level_entity.get_node("Spawner")
	ENTITIES = level_entity.get_node("Entities")
	Globals.createGrid()
	SPAWNER.spawnEntities()
	
	for wagon in wagons:
		ENTITIES.add_child(wagon)
					
	Globals.level_number += 1
	Globals.current_level += 1
	if Globals.current_level > Globals.levels.size() - 1:
		Globals.current_level = 0


func window():
	var size = Vector2i(640, 360) * 2
	get_window().size = size
	get_window().move_to_center()


func has_builders():
	for column in Globals.GRID:
		for item in column:
			if item != null:
				if "wagon_type" in item:
					if item.wagon_type == Globals.wagon_types.BUILDER:
						return true
	return false


func _process(delta: float) -> void:
	Globals.has_builder = has_builders()
