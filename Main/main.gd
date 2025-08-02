extends Node2D


var SPAWNER;
var ENTITIES;

var clock = 0

var trees_being_mined = []

func _ready() -> void:
	window()
	
	create_level()


func create_level():
	for child in $LevelContainer.get_children():
		child.queue_free()
	
	var level_entity = load("res://Level/level.tscn").instantiate()
	add_child(level_entity)
	
	
	SPAWNER = level_entity.get_node("Spawner")
	ENTITIES = level_entity.get_node("Spawner")
	Globals.createGrid()
	SPAWNER.spawnEntities()
	
	Globals.level_number += 1
	Globals.current_level += 1
	if Globals.current_level > Globals.levels.size() - 1:
		Globals.current_level = 0
	
	print("kids: " + str($LevelContainer.get_children()))


func window():
	var size = Vector2i(640, 360) * 2
	get_window().size = size
	get_window().move_to_center()


func check_resource(x, y):
	x = max(0, min(x, Globals.GRID_WIDTH-1))
	y = max(0, min(y, Globals.GRID_HEIGHT-1))
	if Globals.GRID[x][y] != null && Globals.GRID[x][y].name.contains("tree"):
		trees_being_mined.append(Globals.GRID[x][y])

# Somethign about the position is wrong.
func set_resources(x, y):
	check_resource(x+1, y)
	check_resource(x-1, y)
	if x%2:
		check_resource(x+1, y+1)
		check_resource(x-1, y+1)
	else:
		check_resource(x+1, y-1)
		check_resource(x-1, y-1)


func check_surrounding():
	var tree_count = 0
	var rock_count = 0
	trees_being_mined = []

	# for tile in surrounding ...
	for x in range(Globals.GRID_WIDTH):
		for y in range(Globals.GRID_HEIGHT):
			if Globals.GRID[x][y] != null:
				var is_wagon = Globals.GRID[x][y].name.contains("wagon")
				if is_wagon:
					var is_resource_wagon = Globals.GRID[x][y].wagon_type == Globals.wagon_types.RESOURCE
					if is_wagon && is_resource_wagon:
						set_resources(x, y)


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
	
	clock += delta
	check_surrounding()
	if clock >= 1:
		for tree in trees_being_mined:
			tree.being_mined()
			Globals.resource_quantities[Globals.resource_types.WOOD] += 1
		clock = 0 
	
