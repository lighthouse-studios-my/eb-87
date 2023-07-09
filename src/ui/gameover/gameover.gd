extends Control


signal restart_pressed
signal back_pressed

@onready var _buttons := $CenterContainer/VBoxContainer/Buttons.get_children()
@onready var _cursor := $Cursor
@onready var _first_button := _buttons[0]
@onready var leaderboard := %Leaderboard
@onready var stats_list := $Stats/StatsList


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


func show_stats(stats) -> void:
	add_stat("Enemies Killed", stats["kills"])
	add_stat("Upgrades Taken", stats["upgrades"])
	add_stat("Damage Taken", stats["damage"])
	add_stat("Bullets Shot", stats["shots"])
	add_stat("Time Survived", stats["time"])


func add_stat(text: String, value: int) -> void:
	var label = Label.new()
	label.text = text + " : " + str(value)
	stats_list.add_child(label)
