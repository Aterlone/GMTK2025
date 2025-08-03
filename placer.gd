extends Node2D


var WagonScene := preload("res://Wagons/wagon.tscn")
var entities: Node
var placing: Node
var selected_wagon: Node
var need_builder: Label = Label.new()
var need_wood: Label = Label.new()

func _ready() -> void:
	need_builder.add_theme_color_override("font_color", Color.RED)
	need_builder.add_theme_font_size_override("font_size", 18)
	need_builder.text = "Need builder."
	need_builder.visible = false
	add_child(need_builder)
	
	need_wood.add_theme_color_override("font_color", Color.RED)
	need_wood.add_theme_font_size_override("font_size", 18)
	need_wood.text = "Need more wood to place wagon."
	need_wood.visible = false
	add_child(need_wood)


func _input(event):
	# Cancel placing mode with right-click
	if Globals.placing and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		Globals.placing = false
		return
	
	# Handle placing a new wagon
	if Globals.placing:
		if isValidCell(get_global_mouse_position()):
			if event.is_action_pressed("place"):
				place_wagon()
				Globals.placing = false

	# Handle selecting a wagon to move
	elif event.is_action_pressed("move"):
		if isValidCell(get_global_mouse_position()):
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

	#var grid_value = Globals.GRID[grid_index.x][grid_index.y]
	
	placer_graphic()
	
	# Create Placing Wagon Object
	$Wagon.visible = (Globals.placing)
	$Wagon.global_position = $BaseTileWhite.global_position
	match Globals.entity_to_place:
		Globals.wagon_types.BUILDER:
			$Wagon.frame = 0
		Globals.wagon_types.RESOURCE:
			$Wagon.frame = 1
		Globals.wagon_types.COMBAT:
			$Wagon.frame = 2
	if Globals.entity_to_place != Globals.wagon_types.BUILDER and Globals.entity_to_place != Globals.wagon_types.NONE:
		if not Globals.has_builder:
			need_builder.visible = Globals.placing
			need_builder.global_position = get_global_mouse_position()
			need_builder.global_position.y -= 60
			need_builder.global_position.x -= 100

		if Globals.wagon_data[Globals.entity_to_place]["cost"] > Globals.resource_quantities[Globals.resource_types.WOOD]:
			need_wood.visible = Globals.placing
			need_wood.text = "Need " + str(Globals.wagon_data[Globals.entity_to_place]["cost"]) + " wood."
			need_wood.global_position = get_global_mouse_position()
			need_wood.global_position.y -= 80
			need_wood.global_position.x -= 100

func place_wagon():
	var grid_index = Globals.getIndexFromGlobal($BaseTileWhite.global_position)
	
	if grid_index.x >= Globals.GRID_WIDTH or grid_index.y >= Globals.GRID_HEIGHT:
		## our position is off of the grid.
		return
	
	grid_index = Globals.getIndexFromGlobal($BaseTileWhite.global_position)
	Globals.MAIN.SPAWNER.spawnEntity("wagon", grid_index, Globals.entity_to_place)
