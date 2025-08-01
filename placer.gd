extends Node2D


var WagonScene := preload("res://Wagons/wagon.tscn")
var entities: Node
var placing: Node
var selected_wagon: Node

func _input(event):
	# Handle placing a new wagon
	if Globals.placing:
		if isValidCell(get_global_mouse_position()):
			if event.is_action_pressed("place"):
				place_wagon()
				Globals.placing = false

	# Handle selecting a wagon to move
	
	elif event.is_action_pressed("move"):
		if isValidCell(get_global_mouse_position()):
			# will skip empty cells
			return
		var grid_index = Globals.getIndexFromGlobal(get_global_mouse_position())
		var grid_value = Globals.GRID[grid_index.x][grid_index.y]
		
		if grid_value.name.contains("wagon"):
			if grid_value.mouse_over:
				selected_wagon = grid_value

	# Handle moving a selected wagon
	if event.is_action_pressed("place") and selected_wagon != null:
		if !isValidCell(get_global_mouse_position()):
			return
		
		var old_index = Globals.getIndexFromGlobal(selected_wagon.position)
		Globals.GRID[old_index.x][old_index.y] = null

		selected_wagon.position = Globals.getGridPosition(get_global_mouse_position())
		var new_index = Globals.getIndexFromGlobal(selected_wagon.position)
		Globals.GRID[new_index.x][new_index.y] = selected_wagon

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
	
	# If larger than map set to grid_size-1
	grid_coords.x = clamp(grid_coords.x, 0, Globals.GRID_WIDTH - 1)
	grid_coords.y = clamp(grid_coords.y, 0, Globals.GRID_HEIGHT - 1)
	
	return grid_coords


func isValidCell(cell_global_position):
	var grid_coords = Globals.getIndexFromGlobal(get_global_mouse_position())
	var target_cell = Globals.GRID[grid_coords.x][grid_coords.y]
	return (target_cell == null)


func placer_graphic():
	$BaseTileWhite.global_position = Globals.getGridPosition(get_global_mouse_position())
	if isValidCell(get_global_mouse_position()):
		$BaseTileWhite.modulate = Color.GREEN
	else:
		$BaseTileWhite.modulate = Color.RED
	$BaseTileWhite.modulate.a = 0.5


func _physics_process(delta: float) -> void:
	
	var grid_index = Globals.getIndexFromGlobal(get_global_mouse_position())
	var grid_value = Globals.GRID[grid_index.x][grid_index.y]
	$Label.text = str(grid_value)
	
	placer_graphic()
	
	# Create Placing Wagon Object
	$Wagon.visible = (Globals.placing)
	$Wagon.global_position = $BaseTileWhite.global_position
	$Wagon.modulate = Globals.wagon_data[Globals.entity_to_place]["color"]


func place_wagon():
	var grid_index = Globals.getIndexFromGlobal($BaseTileWhite.global_position)
	
	if grid_index.x >= Globals.GRID_WIDTH or grid_index.y >= Globals.GRID_HEIGHT:
		## our position is off of the grid.
		return
	
	grid_index = Globals.getIndexFromGlobal($BaseTileWhite.global_position)
	Globals.MAIN.SPAWNER.spawnEntity("wagon", grid_index, Globals.entity_to_place)
