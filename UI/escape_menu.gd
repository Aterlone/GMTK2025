extends Control

var ominous_once = false

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

func _process(float) -> void:
	if ominous_once and not $music/preparation.playing and not $music/ominous_transition.playing:
		$music/ominous_transition.playing = true
		ominous_once = true
	waiting_for_battle()

# When swapping to battle phase wait until enemies come onto screen.
func waiting_for_battle():
	if $music/ominous_transition.playing:
		return false
	$music/danger_ahead.playing = true
	$music/danger_ahead.auto_loop = true
	return true

# When enemies come into screen
func charge():
	$music/danger_ahead.playing = false
	$music/danger_ahead.auto_loop = false
	$music/charge.playing = true

# Play GReedy Bastard after charge has been played.
func after_charge():
	if $music/charge.playing:
		return false
	$music/greedy_bastard.playing = true
	$music/greedy_bastard.auto_loop = true
	return true

func level_change():
	$music/greedy_bastard.playing = false
	$music/greedy_bastard.auto_loop = false
	ominous_once = false
