extends Node2D
 

@export var wagon_type: Globals.wagon_types = Globals.wagon_types.NONE

var mouse_over: bool = false

var health = 0;

var my_resources = []


func set_type(wagon_type: Globals.wagon_types) -> void:
	self.wagon_type = wagon_type

func _ready() -> void:
	setup_wagon()
	connect_functions()
	
	if wagon_type == Globals.wagon_types.RESOURCE:
		$Timer.wait_time = Globals.wagon_data[wagon_type]["mineSpeed"]
		$Timer.start()
		$Timer.connect("timeout", timeout)


func connect_functions():
	$Control.connect("mouse_entered", Callable(self, "set_mouse").bind(true))
	$Control.connect("mouse_exited", Callable(self, "set_mouse").bind(false))


func setup_wagon():
	$Sprite2D.modulate = Globals.wagon_data[wagon_type]["color"]
	health = Globals.wagon_data[wagon_type]["health"]
	

func set_mouse(overlapping : bool):
	mouse_over = overlapping


func _physics_process(delta: float) -> void:
	if wagon_type == Globals.wagon_types.RESOURCE:
		getResources()


func getValueAtIndex(x, y):
	return Globals.GRID[x][y]


func getResources():
	my_resources = []
	var grid_index = Globals.getIndexFromGlobal(global_position)
	my_resources.append(getValueAtIndex(grid_index.x + 1, grid_index.y))
	my_resources.append(getValueAtIndex(grid_index.x - 1, grid_index.y))
	
	if int(grid_index.x) % 2 == 1:
		my_resources.append(getValueAtIndex(grid_index.x+1, grid_index.y+1))
		my_resources.append(getValueAtIndex(grid_index.x-1, grid_index.y+1))
	else:
		my_resources.append(getValueAtIndex(grid_index.x+1, grid_index.y-1))
		my_resources.append(getValueAtIndex(grid_index.x-1, grid_index.y-1))


func timeout():
	for resource in my_resources:
		if resource != null:
			if resource.name.contains("tree"):
				resource.mine()
				Globals.resource_quantities[resource.resource_type] += randi_range(9, 11)










##
