extends Control

# Music state
var play := true
var ominous_once := false
var charge_played := false
var after_charge_set := false
var battle_waiting_once := false

func _ready() -> void:
	_hide_settings()
	_show_ui()
	_hide_overlay()
	_set_music_volume(-20)
	level_change()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		_show_settings()
		_hide_ui()
		_show_overlay()
		_pause_music()
		$music/main_theme.playing = true
		
		play = false

func _on_back_pressed() -> void:
	_hide_settings()
	_show_ui()
	_hide_overlay()
	_resume_music()
	$music/main_theme.playing = false
	
	play = true

func _on_volume_value_changed(value: float) -> void:
	_set_music_volume(value / 5 - 40)

func _on_full_screen_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if toggled_on else DisplayServer.WINDOW_MODE_WINDOWED
	)

func _process(_delta: float) -> void:

	if not ominous_once and not $music/preparation.playing and play:
		$music/ominous_transition.playing = true
		ominous_once = true
	
	if ominous_once and not battle_waiting_once and not $music/ominous_transition.playing:
		get_tree().get_root().get_child(1).get_child(2).waiting_for_battle()
		battle_waiting_once = true

	if after_charge_set and play:
		after_charge()

# Music Phase Functions

func waiting_for_battle() -> bool:
	if (not ominous_once or $music/ominous_transition.playing) and play:
		return false
	$music/danger_ahead.playing = true
	$music/danger_ahead.stream.loop = true
	return true

func charge() -> void:
	$music/danger_ahead.playing = false
	$music/danger_ahead.stream.loop = false
	$music/charge.playing = true
	charge_played = true
	after_charge_set = true

func after_charge() -> bool:
	if $music/charge.playing:
		return false
	$music/greedy_bastard.playing = true
	$music/greedy_bastard.stream.loop = true
	after_charge_set = false
	return true

func level_change() -> void:
	$music/greedy_bastard.playing = false
	$music/greedy_bastard.stream.loop = false

	#$music/traveller.playing = true
	$music/preparation.playing = true
	#$music/preparation.stream_paused = true

	ominous_once = false
	charge_played = false
	battle_waiting_once = false

# Utility Functions

func _set_music_volume(db: float) -> void:
	for child in $music.get_children():
		child.volume_db = db

func _pause_music() -> void:
	for child in $music.get_children():
		child.stream_paused = true

func _resume_music() -> void:
	for child in $music.get_children():
		child.stream_paused = false

func _hide_settings() -> void:
	$CanvasLayer/settings.visible = false

func _show_settings() -> void:
	$CanvasLayer/settings.visible = true

func _hide_ui() -> void:
	for child in $'../UI'.get_children():
		child.visible = false

func _show_ui() -> void:
	for child in $'../UI'.get_children():
		child.visible = true

func _hide_overlay() -> void:
	$CanvasLayer/ColorRect.visible = false
	$CanvasLayer/Sprite2D.visible = false

func _show_overlay() -> void:
	$CanvasLayer/ColorRect.visible = true
	$CanvasLayer/Sprite2D.visible = true
