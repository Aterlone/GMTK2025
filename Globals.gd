extends Node

enum resource_types {
	WOOD,
	GOLD
}

enum place_mode {
	normal_wagon,
	none
}

enum wagon_types {
	RESOURCE,
	COMBAT,
	BUILDER,
	NONE
}

@export var place: place_mode = place_mode.none
@export var place_type: wagon_types = wagon_types.NONE

var GRID_WIDTH: int = 20
var GRID_HEIGHT: int = 20
var GRID = []

var resource_count: int = 0
