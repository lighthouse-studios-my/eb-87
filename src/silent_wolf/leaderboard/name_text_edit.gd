extends LineEdit


func _on_submit_button_score_submitting():
	editable = false


func _on_visibility_changed():
	if visible:
		grab_focus()
