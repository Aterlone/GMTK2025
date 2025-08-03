extends Node2D


var SPAWNER;
var ENTITIES;

var clock = 0

var trees_being_mined = []
var started = false

func _ready() -> void:
	window()
	create_level()
	started = true

func create_level():
	var wagons = []
	Globals.gold_count = 0
	
	for level in $LevelContainer.get_children():
		for nodes in level.get_children():
			for child in nodes.get_children():
				if child.name.contains("wagon"):
					wagons.append(child.duplicate())
		level.queue_free()

	var level_entity = load("res://Level/level.tscn").instantiate()
	get_child(1).add_child(level_entity)
	
	if started:
		$EscapeMenu.level_change()
	
	
	SPAWNER = level_entity.get_node("Spawner")
	ENTITIES = level_entity.get_node("Entities")
	Globals.createGrid()
	SPAWNER.spawnEntities()
	
	for wagon in wagons:
		ENTITIES.add_child(wagon)
		var grid_pos = $LevelContainer.get_child(0).get_child(3).getGridIndex(wagon.position)
		Globals.GRID[grid_pos.x][grid_pos.y] = wagon
			
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
	delete_all_except_main_and_globals()
	
func delete_all_except_main_and_globals():
	var root = get_tree().get_root()
	var main = root.get_node("Main")  # Replace "Main" with your main scene node name
	var globals = root.get_node("Globals")  # Replace with your autoload name if different

	for node in root.get_children():
		if node != main and node != globals:
			node.queue_free()
