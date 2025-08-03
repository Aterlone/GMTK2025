extends Control

func _ready() -> void:
	for child in $CanvasLayer/settings.get_children():
		child.visible = false
	for child in $'../UI'.get_children():
		child.visible = true
	$CanvasLayer/ColorRect.visible = false
	$CanvasLayer/Sprite2D.visible = false
	for child in $music.get_children():
		child.volume_db = -20
	$music/preparation.playing = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		for child in $CanvasLayer/settings.get_children():
			child.visible = true
		for child in $'../UI'.get_children():
			child.visible = false
		$CanvasLayer/ColorRect.visible = true
		$CanvasLayer/Sprite2D.visible = true
		for child in $music.get_children():
			child.stream_paused = true
func _on_back_pressed() -> void:
	for child in $CanvasLayer/settings.get_children():
		child.visible = false
	for child in $'../UI'.get_children():
		child.visible = true
	$CanvasLayer/ColorRect.visible = false
	$CanvasLayer/Sprite2D.visible = false
	for child in $music.get_children():
		child.stream_paused = false

func _on_volume_value_changed(value: float) -> void:
	for child in $music.get_children():
		child.volume_db = value/5-40

func _on_full_screen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
