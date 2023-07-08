extends Control


signal start_pressed
signal settings_pressed
signal credits_pressed
signal quit_pressed


var _last_focused: Control

@onready var _buttons := $Buttons.get_children()
@onready var _cursor := $Cursor


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
	_cursor.point_at(control)
	_last_focused = control


func _on_button_pressed(button: String) -> void:
	emit_signal("%s_pressed" % button)


func _on_buttons_sort_children():
	_cursor.place_at(_last_focused)
