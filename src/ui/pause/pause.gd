extends Control


signal settings_pressed
signal quit_pressed

@onready var _buttons := $CenterContainer/Buttons.get_children()
@onready var _resume_button := $CenterContainer/Buttons/ResumeButton
@onready var _cursor := $Cursor


func _ready() -> void:
	for button in _buttons:
		button.focus_entered.connect(_on_button_focus_entered.bind(button))
	visible = get_tree().paused


func _input(event: InputEvent) -> void:
	if (
			event is InputEventKey
			and event.keycode == Key.KEY_ESCAPE
			and event.pressed
	):
		pause(!get_tree().paused)


func refocus() -> void:
	_resume_button.grab_focus()


func pause(paused: bool) -> void:
	get_tree().paused = paused
	visible = paused
	if paused:
		refocus()


func _on_button_pressed(button: String) -> void:
	emit_signal("%s_pressed" % button)


func _on_button_focus_entered(control: Control) -> void:
	_cursor.point_at(control)


func _on_buttons_sort_children():
	_cursor.place_at(_resume_button)
