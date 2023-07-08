class_name SizeUpgrade
extends Resource


@export var icon := preload("res://icon.svg")
@export var description := "Increase projectile size"


func apply(turret: Node2D) -> void:
	turret.projectile_size_scale += 0.1
