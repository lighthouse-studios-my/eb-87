extends Control


signal restart_pressed
signal back_pressed

@onready var _buttons := $CenterContainer/VBoxContainer/Buttons.get_children()
@onready var _cursor := $Cursor
@onready var _first_button := _buttons[0]


func _ready() -> void:
	for button in _buttons:
		button.focus_entered.connect(_on_button_focus_entered.bind(button))
	refocus()


func refocus() -> void:
	_first_button.grab_focus()


func _on_button_pressed(button: String) -> void:
	emit_signal("%s_pressed" % button)
	UiSfx.play_ui_press()


func _on_button_focus_entered(control: Control) -> void:
	_cursor.point_at(control)
	UiSfx.play_ui_select()


func _on_buttons_sort_children():
	_cursor.place_at(_first_button)
