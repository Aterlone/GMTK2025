extends Node2D
 

@export var wagon_type: Globals.wagon_types = Globals.wagon_types.NONE

var mouse_over: bool = false

var health = 0;

func set_type(wagon_type: Globals.wagon_types) -> void:
	self.wagon_type = wagon_type

func _ready() -> void:
	setup_wagon()
	connect_functions()

func connect_functions():
	$Control.connect("mouse_entered", Callable(self, "set_mouse").bind(true))
	$Control.connect("mouse_exited", Callable(self, "set_mouse").bind(false))


func setup_wagon():
	$Sprite2D.modulate = Globals.wagon_data[wagon_type]["color"]
	health = Globals.wagon_data[wagon_type]["health"]
	

func set_mouse(overlapping : bool):
	mouse_over = overlapping
