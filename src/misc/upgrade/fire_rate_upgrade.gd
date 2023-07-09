class_name FireRateUpgrade
extends Resource


@export var icon := preload("res://assets/ui/upgrades/rofsprite.png")
@export var description := "Increase fire rate"


func apply(turret: Node2D) -> void:
	turret.fire_rate += 0.3
