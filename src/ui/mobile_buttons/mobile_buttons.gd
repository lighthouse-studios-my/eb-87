extends CanvasLayer


func _on_dodge_button_pressed():
	input_press('ui_accept', true)


func _on_dodge_button_released():
	input_press('ui_accept', false)


func input_press(action: String, pressed: bool) -> void:
	var input = InputEventAction.new()
	input.action = action
	input.pressed = pressed
	Input.parse_input_event(input)
