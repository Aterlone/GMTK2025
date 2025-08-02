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
