extends LineEdit


func _on_submit_button_score_submitting():
	editable = false


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if not Rect2(Vector2.ZERO, size).has_point(get_local_mouse_position()):
					release_focus()


func _on_visibility_changed():
	if visible:
		grab_focus()
