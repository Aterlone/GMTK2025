extends Node


var entity_counter = 0
var entity_files = {
	"tree" : load("res://tree.tscn"),
	"wagon" : load("res://Wagons/wagon.tscn")
}

# Spawn trees
func spawnEntities():
	for x in range(Globals.GRID.size()):
		for y in range(Globals.GRID[x].size()):
			var item = Globals.GRID[x][y]
			if item == "tree":
				spawnEntity("tree", Vector2(x, y))


func tryBuyWagon(entity_type):
	var resources = Globals.resource_quantities
	if (resources[Globals.resource_types.WOOD] >= Globals.wagon_data[entity_type]["cost"]):
		resources[Globals.resource_types.WOOD] -= Globals.wagon_data[entity_type]["cost"]
		return true;
	return false;


# Spawn Entites. For wagons, it will spawn it with a specific wagon type, based on what this function was called with. 
# For entites such as trees it will spawn a NONE wagon type.
func spawnEntity(entity_key: String, grid_position: Vector2, type: Globals.wagon_types = Globals.wagon_types.NONE) -> void:
	var entity;
	
	# if it's a wagon
	if type != Globals.wagon_types.NONE:
		if type != Globals.wagon_types.BUILDER:
			if !Globals.has_builder:
				return
		
		var bought = tryBuyWagon(Globals.entity_to_place)
		if !bought:
			return
		
		entity = entity_files[entity_key].instantiate()
		entity.name = entity_key + str(entity_counter) + str(grid_position)
		entity_counter += 1
		
		entity.set_type(type)
		
	else:
		entity = entity_files[entity_key].instantiate()
		entity.name = entity_key + str(entity_counter) + str(grid_position)
		entity_counter += 1
	
	var game_position = Vector2(
		(grid_position.x + 1) * 32,
		(grid_position.y + 0.5) * 32 + (int(grid_position.x) % 2) * 16
	)
	
	entity.global_position = game_position
	get_parent().get_node("Entities").call_deferred("add_child", entity)
	
	
	Globals.GRID[grid_position.x][grid_position.y] = entity
### Below is code for wagons checking resources.
