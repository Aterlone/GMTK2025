extends Node2D
 

@export var wagon_type: Globals.wagon_types = Globals.wagon_types.NONE

var mouse_over: bool = false

var health = 0;

var my_resources = []

var target_enemy = null

func set_type(wagon_type: Globals.wagon_types) -> void:
	self.wagon_type = wagon_type

func _ready() -> void:
	setup_wagon()
	connect_functions()
	
	if wagon_type == Globals.wagon_types.RESOURCE or wagon_type == Globals.wagon_types.COMBAT:
		$Timer.wait_time = Globals.wagon_data[wagon_type]["updateSpeed"]
		$Timer.start()
		$Timer.connect("timeout", timeout)


func connect_functions():
	$Control.connect("mouse_entered", Callable(self, "set_mouse").bind(true))
	$Control.connect("mouse_exited", Callable(self, "set_mouse").bind(false))


func setup_wagon():
	health = Globals.wagon_data[wagon_type]["health"]
	
	$Target.visible = false
	
	match wagon_type:
		Globals.wagon_types.BUILDER:
			$Sprite2D.frame = 0
		Globals.wagon_types.RESOURCE:
			$Sprite2D.frame = 1
		Globals.wagon_types.COMBAT:
			$Sprite2D.frame = 2
	

func set_mouse(overlapping : bool):
	mouse_over = overlapping


func _physics_process(delta: float) -> void:
	if wagon_type == Globals.wagon_types.RESOURCE:
		getResources()
	if wagon_type == Globals.wagon_types.COMBAT:
		getTarget()
		
		$Target.visible = (target_enemy != null)
		if target_enemy != null:
			$Target.global_position = target_enemy.global_position


func getValueAtIndex(x, y):
	var dx = clamp(x, 0, Globals.GRID_WIDTH - 1)
	var dy = clamp(y, 0, Globals.GRID_HEIGHT - 1)
	
	if x > Globals.GRID_WIDTH - 1:
		return null
	if y > Globals.GRID_HEIGHT - 1:
		return null
	
	return Globals.GRID[dx][dy]



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


func mine():
	for resource in my_resources:
		if resource != null:
			if "resource_type" in resource:
				resource.mine()
				var amount = randi_range(2, 4)
				Globals.resource_quantities[resource.resource_type] += amount
				Globals.stats[resource.resource_type] += amount


func timeout():
	match wagon_type:
		Globals.wagon_types.RESOURCE:
			mine()
		Globals.wagon_types.COMBAT:
			attack()


func getTarget():
	var enemies = {}
	for entity in Globals.MAIN.ENTITIES.get_children():
		if "is_grunt" in entity:
			var dist = entity.global_position.distance_to($Sprite2D.global_position)
			if dist < 128:
				enemies[dist] = entity
	
	
	if enemies.size() <= 0:
		target_enemy = null
		return
	
	
	
	var keys = enemies.keys()
	
	var shortest_length = 1000000000
	
	for length in keys:
		if length < shortest_length:
			shortest_length = length
	
	target_enemy = enemies[shortest_length]


func attack():
	if target_enemy == null:
		return
	
	target_enemy.hurt()
	target_enemy = null


func hurt():
	$AnimationPlayer.play("Hurt")
	health -= 1
	if health <= 0:
		if wagon_type == Globals.wagon_types.BUILDER:
			Globals.MAIN.end_run()
		queue_free()


##
