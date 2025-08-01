extends Node2D

var GRID = []


var entity_files = {
	"tree" : load("res://tree.tscn"),
	"wagon" : load("res://Wagons/wagon.tscn")
}

func _ready() -> void:
	window()
	createGrid()
	spawnEntities()


func window():
	var size = Vector2i(640, 360) * 2
	get_window().size = size
	get_window().move_to_center()

# Create a grid which can ahve tiles placed on it.
func createGrid():
	const CENTER_MIN = 6
	const CENTER_MAX = 14
	
	for x in range(Globals.GRID_WIDTH):
		var column = []
		for y in range(Globals.GRID_HEIGHT):
			var bonus = abs((y * x) - 180) / 180.0
			var threshold = 1.4 - bonus
			var in_outer_area = (x < CENTER_MIN or x > CENTER_MAX or y < CENTER_MIN or y > CENTER_MAX)
			
			if randf_range(0.0, threshold) < 0.2 and in_outer_area:
				column.append("tree")
			else:
				column.append(null)
		
		GRID.append(column)

# Spawn trees
func spawnEntities():
	for x in range(GRID.size()):
		for y in range(GRID[x].size()):
			var item = GRID[x][y]
			if item == "tree":
				spawnEntity("tree", Vector2(x, y))

# Spawn Entites. For wagons, it will spawn it with a specific wagon type, based on what this function was called with. 
# For entites such as trees it will spawn a NONE wagon type.
func spawnEntity(entity_key: String, grid_position: Vector2, type: Globals.wagon_types = Globals.wagon_types.NONE) -> void:
	var entity = entity_files[entity_key].instantiate()
	
	if type != Globals.wagon_types.NONE:
		entity.set_type(type)
	
	var game_position = Vector2(
		(grid_position.x + 1) * 32,
		(grid_position.y + 0.5) * 32 + (int(grid_position.x) % 2) * 16
	)
	
	entity.global_position = game_position
	$Entities.call_deferred("add_child", entity)
