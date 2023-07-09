class_name VolumeSlider
extends HSlider


@export var bus_name: String

@onready var _bus_idx := AudioServer.get_bus_index(bus_name)


func _ready() -> void:
	if _bus_idx != -1:
		var db := AudioServer.get_bus_volume_db(_bus_idx)
		value = db_to_linear(db)
	value_changed.connect(_on_value_changed)


func _on_value_changed(val: float) -> void:
	var db := linear_to_db(val)
	if _bus_idx != -1:
		AudioServer.set_bus_volume_db(_bus_idx, db)
