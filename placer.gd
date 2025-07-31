extends Node2D

var WagonScene := preload("res://Wagons/wagon.tscn")
var entities: Node
var placing: Node

func _ready() -> void:
	entities = get_node("/root/Main/Entities")
	placing = get_node("/root/Main/Unplaced_Entity")

func _input(event):
	var not_taken = true
	if placing.get_child_count():
		for child in entities.get_children():
			if child.position == placing.get_child(0).position:
				not_taken = false
				break
		if event.is_action_pressed("place") and not_taken:
			var move_entity = placing.get_child(0)
			placing.remove_child(move_entity)
			entities.add_child(move_entity)
			Globals.place = Globals.place_mode.none
		else:
			placing.get_child(0).position = getGridPosition(get_global_mouse_position())
	if event.is_action_pressed("delete"):
		var wagons = entities.get_children()
		for wagon in wagons:
			if wagon.mouse_over:
				wagon.queue_free()
		
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

func _physics_process(delta: float) -> void:
	$BaseTileWhite.global_position = getGridPosition(get_global_mouse_position())
	if Globals.place == Globals.place_mode.normal_wagon && not placing.get_child_count():
		var wagon = WagonScene.instantiate()
		wagon.position = getGridPosition(get_global_mouse_position())
		placing.add_child(wagon)
