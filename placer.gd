extends Node2D

var WagonScene := preload("res://Wagons/wagon.tscn")
var entities: Node
var placing: Node
var selected_wagon: Node

func _ready() -> void:
	entities = get_node("/root/Main/Entities")
	placing = get_node("/root/Main/Unplaced_Entity")

func _input(event):
	var wagons = entities.get_children()
	var placing_has_child = placing.get_child_count() > 0

	# Handle placing a new wagon
	if placing_has_child:
		var placing_pos = placing.get_child(0).position
		var not_taken = true
		
		for child in wagons:
			if child.position == placing_pos:
				not_taken = false
				break

		if event.is_action_pressed("place"):
			if not_taken:
				var move_entity = placing.get_child(0)
				placing.remove_child(move_entity)
				place_wagon()
				Globals.place = Globals.place_mode.none
			else:
				placing.get_child(0).position = getGridPosition(get_viewport().get_mouse_position())

	# Handle selecting a wagon to move
	elif event.is_action_pressed("move"):
		for wagon in wagons:
			if wagon.name.contains("wagon") and wagon.is_mouse_over():
				selected_wagon = wagon
				break

	# Handle moving a selected wagon
	if event.is_action_pressed("place") and selected_wagon != null:
		var old_index = getGridIndex(selected_wagon.position)
		Globals.GRID[old_index.x][old_index.y] = null

		selected_wagon.position = getGridPosition(get_global_mouse_position())
		var new_index = getGridIndex(selected_wagon.position)
		Globals.GRID[new_index.x][new_index.y] = selected_wagon

		print("move")
		selected_wagon = null

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
	return grid_coords


func _physics_process(delta: float) -> void:
	$BaseTileWhite.global_position = getGridPosition(get_viewport().get_mouse_position())
	
	var grid_index = getGridIndex($BaseTileWhite.global_position)
	
	# If larger than map set to grid_size-1
	grid_index.x = max(0, min(grid_index.x, Globals.GRID_WIDTH - 1))
	grid_index.y = max(0, min(grid_index.y, Globals.GRID_HEIGHT - 1))
	
	var grid_value = Globals.GRID[grid_index.x][grid_index.y]

	# Set type of tile
	$Label.text = str(grid_value)
	# Color whether you can place on the tile for the tester.
	match grid_value:
		null:
			$BaseTileWhite.modulate = Color.GREEN
		_:
			$BaseTileWhite.modulate = Color.RED
	$BaseTileWhite.modulate.a = 0.5
	
	# Create Placing Wagon Object
	if Globals.place == Globals.place_mode.normal_wagon && not placing.get_child_count():
		var wagon = WagonScene.instantiate()
		wagon.position = getGridPosition(get_viewport().get_mouse_position())
		placing.add_child(wagon)


func place_wagon():
	var grid_index = getGridIndex($BaseTileWhite.global_position)
	
	if grid_index.x >= 20:
		## our position is off of the grid.
		return
	
	grid_index = getGridIndex($BaseTileWhite.global_position)
	Globals.GRID[grid_index.x][grid_index.y] = "wagon"
	get_parent().spawnEntity("wagon", grid_index, Globals.place_type)
	
