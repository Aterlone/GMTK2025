extends Node

enum place_mode {
	normal_wagon,
	none
}

enum place_types {
	RESOURCE,
	COMBAT,
	BUILDER
}

@export var place: place_mode = place_mode.none
@export var place_type: place_types = place_types.RESOURCE
