@tool
class_name Setting
extends Control


@export var name_: String : set = set_name_, get = get_name_

var _provider
var _setting_handler

@onready var _name_label := $Name
@onready var _value_label := $"%Value"


func _ready() -> void:
	_name_label.text = name_
	
	for child in get_children():
		if not _provider and _is_provider(child):
			_provider = child
			_provider.value_changed.connect(_on_value_changed)
			_value_label.text = _provider.display_value()
		elif not _setting_handler and _is_handler(child):
			_setting_handler = child
	
	if _setting_handler and _provider:
		if _setting_handler.get_existing():
			_provider.value = _setting_handler.get_existing()


func _input(event: InputEvent) -> void:
	if not has_focus():
		return
	
	if event.is_action_pressed("ui_right"):
		_next()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_left"):
		_prev()
		get_viewport().set_input_as_handled()


func _next() -> void:
	if _provider:
		_provider.next()


func _prev() -> void:
	if _provider:
		_provider.prev()


func _is_provider(node: Node) -> bool:
	return (
		node.has_method("display_value")
		and node.has_method("next")
		and node.has_method("prev")
		and node.has_signal("value_changed")
	)


func _is_handler(node: Node) -> bool:
	return (
		node.has_method("get_existing")
		and node.has_method("handle")
	)


func set_name_(val: String) -> void:
	name_ = val
	
	if _name_label:
		_name_label.text = val


func get_name_() -> String:
	return name_


func _on_prev_button_pressed() -> void:
	_prev()


func _on_next_button_pressed() -> void:
	_next()


func _on_value_changed() -> void:
	_value_label.text = _provider.display_value()
	if _setting_handler:
		_setting_handler.handle(_provider.value)
