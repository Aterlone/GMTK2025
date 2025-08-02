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



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		for child in $CanvasLayer/settings.get_children():
			child.visible = true
		$CanvasLayer/ColorRect.visible = true
		$CanvasLayer/Sprite2D.visible = true

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

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	for child in $CanvasLayer/settings.get_children():
		child.visible = false
		
	for child in $CanvasLayer/main_menu.get_children():
		child.visible = true


func _on_full_screen_button_up() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_full_screen_button_down() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_volume_value_changed(value: float) -> void:
	if not muted:
		$AudioStreamPlayer.volume_db = value/10
	

func _on_mute_button_up() -> void:
	$AudioStreamPlayer.volume_db = -20
	muted = true

func _on_mute_button_down() -> void:
	$AudioStreamPlayer.volume_db = $CanvasLayer/settings/Volume.value
	muted = false
	
func _process(delta: float) -> void:
	print($AudioStreamPlayer.volume_db)
