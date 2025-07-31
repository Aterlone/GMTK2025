extends Control



func _process(delta: float) -> void:
	print(Globals.place)

func _on_place_normal_wagon_pressed() -> void:
	if Globals.place == Globals.place_mode.none:
		Globals.place = Globals.place_mode.normal_wagon
	else:
		Globals.place = Globals.place_mode.none	
