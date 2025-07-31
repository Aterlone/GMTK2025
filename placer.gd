extends Node2D

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
	print(grid_target)
	return grid_target

func _physics_process(delta: float) -> void:
	$BaseTileWhite.global_position = getGridPosition(get_global_mouse_position())
	
	
