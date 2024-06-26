extends Control


signal start_pressed
signal settings_pressed
signal credits_pressed
signal quit_pressed


var _last_focused: Control

@onready var _buttons := %Buttons.get_children()


func _ready() -> void:
	for button in _buttons:
		button.focus_entered.connect(_on_button_focus_entered.bind(button))
	refocus()


@warning_ignore("native_method_override")
func show() -> void:
	super.show()
	refocus()


func refocus() -> void:
	var control: Control = _last_focused if _last_focused else _buttons.front()
	control.grab_focus()


func _on_button_focus_entered(control: Control) -> void:
	_last_focused = control
	UiSfx.play_ui_select()


func _on_button_pressed(button: String) -> void:
	emit_signal("%s_pressed" % button)
	UiSfx.play_ui_press()
