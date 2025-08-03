extends Control

func _ready() -> void:
	for child in $CanvasLayer/settings.get_children():
		child.visible = false
	for child in $'../UI'.get_children():
		child.visible = true
	$CanvasLayer/ColorRect.visible = false
	$CanvasLayer/Sprite2D.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		for child in $CanvasLayer/settings.get_children():
			child.visible = true
		for child in $'../UI'.get_children():
			child.visible = false
		$CanvasLayer/ColorRect.visible = true
		$CanvasLayer/Sprite2D.visible = true


func _on_back_pressed() -> void:
	for child in $CanvasLayer/settings.get_children():
		child.visible = false
	for child in $'../UI'.get_children():
		child.visible = true
	$CanvasLayer/ColorRect.visible = false
	$CanvasLayer/Sprite2D.visible = false
