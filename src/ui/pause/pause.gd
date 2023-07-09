extends Control


signal paused
signal unpaused
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
	if event.is_action_pressed("pause"):
		pause(!visible)


func refocus() -> void:
	_resume_button.grab_focus()


func pause(paused: bool) -> void:
	visible = paused
	if paused:
		refocus()
		emit_signal("paused")
	else:
		emit_signal("unpaused")


func _on_button_pressed(button: String) -> void:
	emit_signal("%s_pressed" % button)


func _on_button_focus_entered(control: Control) -> void:
	_cursor.point_at(control)
	UiSfx.play_ui_select()


func _on_buttons_sort_children():
	_cursor.place_at(_resume_button)
