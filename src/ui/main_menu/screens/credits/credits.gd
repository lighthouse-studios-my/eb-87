extends Control


signal back_pressed

@onready var _back_button := $BackButton
@onready var _cursor := $Cursor


func _ready() -> void:
	refocus()


@warning_ignore("native_method_override")
func show() -> void:
	super.show()
	refocus()


func refocus() -> void:
	_back_button.grab_focus()


func _on_back_button_pressed() -> void:
	emit_signal("back_pressed")
