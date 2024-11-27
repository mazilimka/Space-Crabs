extends ScrollContainer


var dragging := false
var drag_start_pos := Vector2.ZERO


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed():
			dragging = true
			drag_start_pos = event.position
		else:
			dragging = false
	if event is InputEventScreenDrag and dragging:
		scroll_vertical -= event.relative.y
