class_name RicochetUpgrade
extends Resource


@export var icon := preload("res://assets/ui/upgrades/ricosprite.png")
@export var description := "+1 bounce off walls"


func apply(turret: Node2D) -> void:
	turret.projectile_bounce += 1
