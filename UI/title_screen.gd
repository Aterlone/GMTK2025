extends CanvasLayer

var muted: bool = false

func _ready() -> void:
	$CanvasLayer/main_menu/settings.connect(
	"pressed", switch_tab.bind("settings")
	)
	$CanvasLayer/main_menu/start.connect(
	"pressed", _on_start_pressed
	)
	$CanvasLayer/main_menu/exit.connect(
	"pressed", _on_exit_pressed
	)
	$CanvasLayer/settings/back.connect(
	"pressed", switch_tab.bind("menu")
	)
	
	switch_tab("menu")


func switch_tab(tab_name):
	$CanvasLayer/settings.visible = (tab_name == "settings")
	$CanvasLayer/main_menu.visible = (tab_name == "menu")


func _on_start_pressed() -> void:
	#$'../UI'.visible = true
	get_parent().add_child(load('res://UI/escape_menu.tscn').instantiate())
	
	get_parent().create_level()
	
	call_deferred("queue_free")


func _on_exit_pressed() -> void:
	pass


func _on_volume_value_changed(value: float) -> void:
	if not muted:
		$MainMenu.volume_db = value/10-20


func _on_full_screen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
