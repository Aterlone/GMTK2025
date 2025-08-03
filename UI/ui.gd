extends CanvasLayer

func place(wagon_type: Globals.wagon_types):
	if Globals.place == Globals.place_mode.none:
		Globals.place = Globals.place_mode.normal_wagon
		Globals.place_type = wagon_type
	else:
		Globals.place = Globals.place_mode.none	
		Globals.place_type = wagon_type


func _ready() -> void:
	$Main/Buttons/WagonCombat.connect(
		"pressed", set_placed_wagon.bind(Globals.wagon_types.COMBAT)
		)
	$Main/Buttons/WagonResource.connect(
		"pressed", set_placed_wagon.bind(Globals.wagon_types.RESOURCE)
		)
	$Main/Buttons/WagonBuilder.connect(
		"pressed", set_placed_wagon.bind(Globals.wagon_types.BUILDER)
		)
		
	$Main/Button.connect(
		"pressed", Globals.MAIN.create_level
		)


func _physics_process(delta: float) -> void:
	var resources = Globals.resource_quantities
	$Main/HUD/Wood.text = "x" + str(resources[Globals.resource_types.WOOD]) + ""
	$Main/HUD/Gold.text = "x" + str(resources[Globals.resource_types.GOLD]) + ""
	if Globals.has_builder:
		$Main/HUD/Builders.text = ""
	else:
		$Main/HUD/Builders.text = "No Builders!?"

func set_placed_wagon(wagon_type):
	Globals.placing = !Globals.placing
	Globals.entity_to_place = wagon_type
	print("This")
