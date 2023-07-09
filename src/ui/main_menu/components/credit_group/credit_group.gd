@tool
extends VBoxContainer


@export var title := "Title" : set = _set_title
@export var names: Array[String] = [] : set = _set_names

@onready var _title := %Title
@onready var _names_container := $Names


func _set_title(val: String) -> void:
	title = val
	if not _title:
		await ready
	_title.text = title


func _set_names(val: Array[String]) -> void:
	names = val
	
	if not _names_container:
		await ready
	
	for child in _names_container.get_children():
		child.queue_free()
	
	for n in names:
		var label := Label.new()
		label.text = n
		label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		_names_container.add_child(label)
