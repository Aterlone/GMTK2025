extends Node2D


func getGridPosition(target):
	var gridTarget = Vector2(
		floor((target.x + 32) / 64) * 64,
		floor((target.y + 16) / 32) * 32
		)
	
	var lines = [false,false,false,false]
	var lineY;
	
	lineY = -(target - gridTarget).x / 2 + 16
	lineY += gridTarget.y
	
	lines[0] = target.y > lineY
	
	lineY = (target - gridTarget).x / 2 - 16
	lineY += gridTarget.y
	
	lines[1] = target.y < lineY
	
	lineY = -(target - gridTarget).x / 2 - 16
	lineY += gridTarget.y
	
	lines[2] = target.y < lineY
	
	lineY = (target - gridTarget).x / 2 + 16
	lineY += gridTarget.y
	
	lines[3] = target.y > lineY
	
	if lines[0]:
		gridTarget += Vector2(32,16)
	
	if lines[1]:
		gridTarget += Vector2(32,-16)
	
	if lines[2]:
		gridTarget += Vector2(-32,-16)
	
	if lines[3]:
		gridTarget += Vector2(-32,16)
	
	return gridTarget



func _physics_process(delta: float) -> void:
	$BaseTileWhite.global_position = getGridPosition(get_global_mouse_position())
	
	
