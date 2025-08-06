extends Node


@onready var MAIN = get_tree().get_root().get_child(1)

enum resource_types {
	WOOD,
	GOLD
}


var stats = {
	resource_types.WOOD : 0,  # wood gathered
	resource_types.GOLD : 0,  # gold gathered
	"enemiesSlain" : 0 
}


var resource_quantities = {
	resource_types.WOOD : 300,
	resource_types.GOLD : 0
}

enum wagon_types {
	RESOURCE,
	COMBAT,
	BUILDER,
	NONE
}

var wagon_data = {
	Globals.wagon_types.RESOURCE : {
		"health" : 2,
		"color" : Color.BLUE,
		"cost" : 200,
		"updateSpeed" : 1.0,
		"canMove" : true
	},
	Globals.wagon_types.COMBAT : {
		"health" : 2,
		"color" : Color.RED,
		"cost" : 400,
		"updateSpeed" : 1.0,
		"canMove" : true
	},
	Globals.wagon_types.BUILDER : {
		"health" : 5,
		"color" : Color.WHITE,
		"cost" : 100,
		"canMove" : false
	},
	Globals.wagon_types.NONE : {
		"health" : 0,
		"color" : Color.WHITE,
		"cost" : 100000000
	}
}

var place_type: wagon_types = wagon_types.NONE

var GRID_WIDTH: int = 19
var GRID_HEIGHT: int = 11
var GRID = []

var placing = false
var entity_to_place = wagon_types.NONE

var has_builder = false


enum levels {
	GOBLINS,
	ROBOTS
}

var current_level = levels.GOBLINS
var is_day = false

var level_number = 0
var first = 0

func resetStats():
	stats = {
		resource_types.WOOD : 0,  # wood gathered
		resource_types.GOLD : 0,  # gold gathered
		"enemiesSlain" : 0 
	}



# Create a grid which can have tiles placed on it.
func createGrid():
	GRID = []
	const CENTER_MIN = 6
	const CENTER_MAX = 14
	
	for x in range(Globals.GRID_WIDTH):
		var column = []
		for y in range(Globals.GRID_HEIGHT):
			if x == 20 and y >= 5 and y <= 12:
				break
			column.append(null)
			var bonus = abs((y * x) - 180) / 180.0
			var threshold = 1.6 - bonus
			var in_outer_area = (x < CENTER_MIN or x > CENTER_MAX or y < CENTER_MIN or y > CENTER_MAX)
			
			if randf_range(0.0, threshold) < 0.2 and in_outer_area:
				if randf_range(0.0,1.0) > 0.25:
					column[y] = "tree"
		
		Globals.GRID.append(column)
	
	# spawn gold
	var gold_count = 0
	var gold_max = 3 * (level_number+1)
	while gold_count < gold_max:
		
		## randomly scatter (gold_count) gold piles around the map
		var rand_index = Vector2(
			randi_range(0, GRID_WIDTH - 1),
			randi_range(0, GRID_HEIGHT - 1)
		)
		while GRID[rand_index.x][rand_index.y] != null:
			rand_index = Vector2(
				randi_range(0, GRID_WIDTH - 1),
				randi_range(0, GRID_HEIGHT - 1)
			)
		
		GRID[rand_index.x][rand_index.y] = "gold"
		
		gold_count += 1


# Snapped grid origin
func snap_to_grid(target: Vector2) -> Vector2:
	return Vector2(
		floor((target.x + 32) / 64) * 64,
		floor((target.y + 16) / 32) * 32
	)


# For slope calculation
func get_line_y(offset: Vector2, slope: float, shift: float) -> float:
	return slope * offset.x + shift


# Checks for diamonds edges
func is_above(target: Vector2, grid_target: Vector2, slope: float, shift: float) -> bool:
	var offset = target - grid_target
	var line_y = get_line_y(offset, slope, shift) + grid_target.y
	return target.y < line_y


# Checks for diamonds edges
func is_below(target: Vector2, grid_target: Vector2, slope: float, shift: float) -> bool:
	var offset = target - grid_target
	var line_y = get_line_y(offset, slope, shift) + grid_target.y
	return target.y > line_y


# Get gridded position.
func getGridPosition(target: Vector2) -> Vector2:
	var grid_target = snap_to_grid(target)

	if is_below(target, grid_target, -0.5, 16):
		grid_target += Vector2(32, 16)

	if is_above(target, grid_target, 0.5, -16):
		grid_target += Vector2(32, -16)

	if is_above(target, grid_target, -0.5, -16):
		grid_target += Vector2(-32, -16)

	if is_below(target, grid_target, 0.5, 16):
		grid_target += Vector2(-32, 16)
		
	return grid_target


# Get grid index values
func getGridIndex(origin):
	var grid_coords = origin / 32
	grid_coords.y = ceil(grid_coords.y)
	grid_coords -= Vector2(1,1)
	
	grid_coords.x = clamp(grid_coords.x, 0, Globals.GRID_WIDTH - 1)
	grid_coords.y = clamp(grid_coords.y, 0, Globals.GRID_HEIGHT - 1)
	
	return grid_coords


func getIndexFromGlobal(position_global):
	return getGridIndex(getGridPosition(position_global))
