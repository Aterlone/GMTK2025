extends Control

var muted: bool = false

func _ready() -> void:
	$CanvasLayer/main_menu/settings.connect(
	"pressed", _on_settings_pressed.bind()
	)
	$CanvasLayer/main_menu/start.connect(
	"pressed", _on_start_pressed.bind()
	)
	$CanvasLayer/main_menu/exit.connect(
	"pressed", _on_exit_pressed.bind()
	)
	$CanvasLayer/settings/back.connect(
	"pressed", _on_back_pressed.bind()
	)
	for child in $CanvasLayer/settings.get_children():
		child.visible = false
	for child in $'../UI'.get_children():
		child.visible = false

func _on_settings_pressed() -> void:
	for child in $CanvasLayer/settings.get_children():
		child.visible = true
		
	for child in $CanvasLayer/main_menu.get_children():
		child.visible = false

func _on_start_pressed() -> void:
	for child in $CanvasLayer/settings.get_children():
		child.visible = false
		
	for child in $CanvasLayer/main_menu.get_children():
		child.visible = false
		
	for child in $'../UI'.get_children():
		child.visible = true
		
	$CanvasLayer/ColorRect.visible = false
	$CanvasLayer/Sprite2D.visible = false
	$CanvasLayer/main_menu/start.text = "Continue"
	self.get_parent().add_child(load('res://UI/escape_menu.tscn').instantiate())
	self.queue_free()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	for child in $CanvasLayer/settings.get_children():
		child.visible = false
		
	for child in $CanvasLayer/main_menu.get_children():
		child.visible = true


func _on_volume_value_changed(value: float) -> void:
	if not muted:
		$AudioStreamPlayer.volume_db = value/10-20

func _on_full_screen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
