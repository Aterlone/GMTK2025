extends Node2D




var wagon_data = {
	Globals.wagon_types.RESOURCE : {
		"health" : 1,
		"color" : Color.BLUE
	},
	Globals.wagon_types.COMBAT : {
		"health" : 3,
		"color" : Color.RED
	},
	Globals.wagon_types.BUILDER : {
		"health" : 5,
		"color" : Color.WHITE
	},
	Globals.wagon_types.NONE : {
		"health" : 0,
		"color" : Color.BLACK
	}
}

var wagon_type: Globals.wagon_types = Globals.wagon_types.NONE

var mouse_over: bool = false

var health = 0;

func set_type(wagon_type: Globals.wagon_types) -> void:
	self.wagon_type = wagon_type

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
