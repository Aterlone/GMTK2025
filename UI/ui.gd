extends Control

func place(wagon_type: Globals.wagon_types):
	if Globals.place == Globals.place_mode.none:
		Globals.place = Globals.place_mode.normal_wagon
		Globals.place_type = wagon_type
	else:
		Globals.place = Globals.place_mode.none	
		Globals.place_type = wagon_type

func _on_place_resource_wagon_pressed() -> void:
	place(Globals.wagon_types.RESOURCE)

func _on_place_combat_wagon_pressed() -> void:
	place(Globals.wagon_types.COMBAT)
