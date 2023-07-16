extends Node2D


@onready var keyboard_tutorial := $KeyboardTutorial
@onready var controller_tutorial := $ControllerTutorial

var is_mobile := false


func _ready() -> void:
	if DisplayServer.is_touchscreen_available():
		display_mobile()


func _unhandled_input(event):
	if is_mobile: return
	
	if event.get_class() == "InputEventJoypadButton" or event.get_class() == "InputEventJoypadMotion":
		display_controller()
	
	if event.get_class() == "InputEventKey":
		display_keyboard()


func erase() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 1)
	tween.tween_callback(queue_free)


func display_controller():
	controller_tutorial.visible = true
	keyboard_tutorial.visible = false


func display_keyboard():
	keyboard_tutorial.visible = true
	controller_tutorial.visible = false


func display_mobile():
	keyboard_tutorial.visible = false
	controller_tutorial.visible = false
	is_mobile = true
