extends Node


@onready var MAIN = get_tree().get_root().get_child(1)

enum resource_types {
	WOOD,
	GOLD
}

var resource_quantities = {
	resource_types.WOOD : 50000,
	resource_types.GOLD : 50000
}

enum wagon_types {
	RESOURCE,
	COMBAT,
	BUILDER,
	NONE
}

var wagon_data = {
	Globals.wagon_types.RESOURCE : {
		"health" : 1,
		"color" : Color.BLUE,
		"cost" : 200,
		"mineSpeed" : 1.0
	},
	Globals.wagon_types.COMBAT : {
		"health" : 3,
		"color" : Color.RED,
		"cost" : 400,
	},
	Globals.wagon_types.BUILDER : {
		"health" : 5,
		"color" : Color.WHITE,
		"cost" : 100,
	},
	Globals.wagon_types.NONE : {
		"health" : 0,
		"color" : Color.WHITE,
		"cost" : 100000000,
	}
}

var place_type: wagon_types = wagon_types.NONE

var GRID_WIDTH: int = 20
var GRID_HEIGHT: int = 20
var GRID = []

var placing = false
var entity_to_place = wagon_types.NONE

var has_builder = false


enum levels {
	GOBLINS,
	ROBOTS
}

var current_level = levels.ROBOTS
var is_day = false

var level_number = 0

# Create a grid which can ahve tiles placed on it.
func createGrid():
	GRID = []
	const CENTER_MIN = 6
	const CENTER_MAX = 14
	
	for x in range(Globals.GRID_WIDTH):
		var column = []
		for y in range(Globals.GRID_HEIGHT):
			var bonus = abs((y * x) - 180) / 180.0
			var threshold = 1.6 - bonus
			var in_outer_area = (x < CENTER_MIN or x > CENTER_MAX or y < CENTER_MIN or y > CENTER_MAX)
			
			if randf_range(0.0, threshold) < 0.2 and in_outer_area:
				#if randf_range(0.0,1.0) < 0.25:
					column.append("tree")
				#else:
					#column.append("gold")
			else:
				column.append(null)
		
		Globals.GRID.append(column)


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
	
	# If larger than map set to grid_size-1
	grid_coords.x = clamp(grid_coords.x, 0, Globals.GRID_WIDTH - 1)
	grid_coords.y = clamp(grid_coords.y, 0, Globals.GRID_HEIGHT - 1)
	
	return grid_coords


func getIndexFromGlobal(position_global):
	return getGridIndex(getGridPosition(position_global))
