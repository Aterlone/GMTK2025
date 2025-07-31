extends Node2D


enum wagon_types {
	RESOURCE,
	COMBAT,
	BUILDER
}

var wagon_data = {
	wagon_types.RESOURCE : {
		"health" : 1,
		"color" : Color.BLUE
	},
	wagon_types.COMBAT : {
		"health" : 3,
		"color" : Color.RED
	},
	wagon_types.BUILDER : {
		"health" : 5,
		"color" : Color.WHITE
	}
}

var wagon_type = wagon_types.RESOURCE

var mouse_over: bool = false

var health = 0;

func _ready() -> void:
	setup_wagon()
	
	$Control.connect("mouse_entered", set_mouse.bind(true))
	$Control.connect("mouse_exited", set_mouse.bind(false))


func setup_wagon():
	$Sprite2D.modulate = wagon_data[wagon_type]["color"]
	health = wagon_data[wagon_type]["health"]


func set_mouse(overlapping : bool):
	mouse_over = overlapping


func _physics_process(delta: float) -> void:
	pass
