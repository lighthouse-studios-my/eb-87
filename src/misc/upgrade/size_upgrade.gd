class_name SizeUpgrade
extends Resource


@export var icon := preload("res://assets/ui/upgrades/bssprite.png")
@export var description := "Increase projectile size"


func apply(turret: Node2D) -> void:
	turret.projectile_size_scale += 1.0
