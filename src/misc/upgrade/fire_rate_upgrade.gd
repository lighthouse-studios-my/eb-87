class_name FireRateUpgrade
extends Resource


@export var icon := preload("res://icon.svg")
@export var description := "Increase fire rate"


func apply(turret: Node2D) -> void:
	turret.fire_rate += 0.1
