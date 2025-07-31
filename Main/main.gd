extends Node2D

var GRID = []


var entity_files = {
	"tree" : load("res://tree.tscn")
}

func _ready() -> void:
	window()
	createGrid()
	spawnEntities()


func window():
	var size = Vector2i(640, 360) * 2
	get_window().size = size
	get_window().move_to_center()


func createGrid():
	var grid_size_X = 20
	var grid_size_Y = 20
	
	for posX in range(grid_size_X):
		var column = []
		for posY in range(grid_size_Y):
			if randf_range(0.0,1.0) < 0.2:
				column.append("tree")
			else:
				column.append(null)
		GRID.append(column)


func spawnEntities():
	for posX in range(GRID.size()):
		var column = GRID[posX]
		for posY in range(column.size()):
			var item = column[posY]
			if item != null:
				spawnEntity("tree", Vector2(posX, posY))


func spawnEntity(entity_key, grid_position):
	var entity = entity_files[entity_key].instantiate()
	
	var game_position = Vector2.ZERO
	game_position.x = (grid_position.x + 1) * 32
	game_position.y = (grid_position.y + 0.5) * 32 + (int(grid_position.x) % 2) * 16
	
	entity.global_position = game_position
	
	$Entities.call_deferred("add_child", entity)
